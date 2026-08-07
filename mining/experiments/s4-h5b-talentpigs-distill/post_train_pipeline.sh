#!/usr/bin/env bash
# After H5b train.done: merge LoRA → chall:8002 → n80 vs TalentPigs king.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

export HF_HOME=${HF_HOME:-/root/hf}
export PYTHONPATH=/root/mining_src/affine_pkg:${PYTHONPATH:-}
export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:-6,7}

BASE=${BASE:-/root/hf/hub/models--TalentPigs--affine-5ekxlcg3fx-abc/snapshots/dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4}
KING_REPO=${KING_REPO:-TalentPigs/affine-5ekxlcg3fx-abc}
KING_REV=${KING_REV:-dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4}
TRAIN_DIR=${TRAIN_DIR:-/root/h5b/train}
ADAPTER=${ADAPTER:-$TRAIN_DIR/adapter}
CKPT_ROOT=${CKPT_ROOT:-$TRAIN_DIR/checkpoints}
MERGED=${MERGED:-/root/h5b/merged}
SIM_N80=/root/affine_data/h5b_sim_result.json
PROG=/root/affine_data/h5b_sim_progress.json
LOG=/root/logs/h5b_pipeline.nohup
SOFT_DEADLINE_UTC=${SOFT_DEADLINE_UTC:-2026-08-07T11:30:00Z}
DEADMAN_UTC=${DEADMAN_UTC:-2026-08-07T12:00:00Z}

log() { echo "[h5b-pipe] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

# Any non-zero exit that does not already write h5b_pipeline.aborted leaves
# host harvest spinning until 11:45Z with no decision (merge fail, identity
# REFUSE, wait_ready timeout, serve crash, missing adapter). Trap closes that.
_abort_on_exit() {
  local rc=$?
  if [[ $rc -eq 0 ]]; then
    return 0
  fi
  if [[ -f /root/logs/h5b_pipeline.done ]]; then
    return 0
  fi
  if [[ ! -f /root/logs/h5b_pipeline.aborted ]]; then
    echo "aborted_err_rc=${rc} $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
      >/root/logs/h5b_pipeline.aborted
    echo "[h5b-pipe] $(date -u +%Y-%m-%dT%H:%M:%SZ) EXIT trap wrote aborted_err_rc=${rc}" \
      | tee -a "$LOG" >/dev/null 2>&1 || true
  fi
}
trap _abort_on_exit EXIT

mkdir -p /root/logs /root/affine_data /root/h5b
rm -f /root/logs/h5b_pipeline.aborted /root/logs/h5b_pipeline.done \
  /root/logs/h5b_merge.done /root/logs/h5b_sim_n80.done

log "waiting for $TRAIN_DIR/train.done (or adapter + no train proc)"
while true; do
  if [[ -f "$TRAIN_DIR/train.done" ]]; then
    log "train.done present"
    break
  fi
  if [[ -f "$ADAPTER/adapter_config.json" ]] && ! pgrep -f "s4-h1v2-sft/train_lora.py" >/dev/null 2>&1; then
    log "adapter present and train proc gone — proceed"
    break
  fi
  now=$(date -u +%s)
  soft=$(date -u -d "$SOFT_DEADLINE_UTC" +%s)
  if (( now > soft - 3600 )); then
    log "WARN: <60m to soft and train not done; abort"
    echo "aborted_no_train $(date -u +%Y-%m-%dT%H:%M:%SZ)" > /root/logs/h5b_pipeline.aborted
    exit 1
  fi
  sleep 30
done

# train.done is written BEFORE Python tears down the 35B resident on GPUs
# 6,7. Merging immediately OOMs / thrashes those GPUs. Wait for the train
# proc to exit, then a short CUDA settle.
log "waiting for train_lora.py to exit and release GPUs 6,7"
for _ in $(seq 1 180); do
  if ! pgrep -f "s4-h1v2-sft/train_lora.py" >/dev/null 2>&1; then
    log "train proc gone"
    break
  fi
  sleep 5
done
if pgrep -f "s4-h1v2-sft/train_lora.py" >/dev/null 2>&1; then
  log "ERROR: train still alive >15m after train.done; abort"
  echo "aborted_train_stuck $(date -u +%Y-%m-%dT%H:%M:%SZ)" > /root/logs/h5b_pipeline.aborted
  exit 1
fi
sleep 15
log "GPU settle done; proceeding to merge"

if [[ ! -f "$ADAPTER/adapter_config.json" ]]; then
  latest=$(ls -d "$CKPT_ROOT"/checkpoint-* 2>/dev/null | sort -V | tail -1 || true)
  if [[ -n "${latest:-}" && -f "$latest/adapter_config.json" ]]; then
    ADAPTER=$latest
    log "using checkpoint adapter $ADAPTER"
  else
    log "ERROR: no adapter"
    echo "aborted_no_adapter $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
      >/root/logs/h5b_pipeline.aborted
    exit 1
  fi
fi

log "merge LoRA → $MERGED"
rm -rf "$MERGED"
python /root/mining_src/s4-h1-sft/merge_lora.py \
  --base "$BASE" \
  --adapter "$ADAPTER" \
  --out "$MERGED" \
  --device-map auto \
  | tee -a "$LOG"
cp -f "$MERGED/merge_meta.json" /root/affine_data/h5b_merge_meta.json 2>/dev/null || true
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h5b_merge.done

# Refuse weight-identical to king/base.
# Do NOT use first-1MiB-of-shard-1 alone: LoRA leaves embed/lm_head windows
# untouched → false-positive REFUSE (H1 2026-08-07). Trust merge_lora's
# multi-window weight_identical; also probe numbered shards vs TalentPigs.
python - <<PY 2>&1 | tee -a "$LOG"
import hashlib, json, sys
from pathlib import Path

merged = Path("$MERGED")
king = Path("$BASE")
meta_path = merged / "merge_meta.json"
meta = json.loads(meta_path.read_text()) if meta_path.is_file() else {}


def window_sha(path: Path, offset: int, nbytes: int = 1 << 20) -> str:
    h = hashlib.sha256()
    size = path.stat().st_size
    off = max(0, min(offset, max(0, size - nbytes)))
    with open(path, "rb") as f:
        f.seek(off)
        h.update(f.read(nbytes))
    return h.hexdigest()


def numbered(p: Path):
    shards = sorted(p.glob("model-*-of-*.safetensors"))
    if shards:
        return shards
    return sorted(
        x for x in p.glob("model-*.safetensors") if "visual" not in x.name
    )


ms, ks = numbered(merged), numbered(king)
if not ms or not ks:
    sys.exit("REFUSE: missing language-model shards")

# Pair by basename when layouts match; else compare first N shared by index.
by_name = {k.name: k for k in ks}
pairs = []
for m in ms:
    if m.name in by_name:
        pairs.append((m, by_name[m.name]))
if not pairs:
    n = min(len(ms), len(ks))
    pairs = list(zip(ms[:n], ks[:n]))

any_diff = False
shard_windows = {}
for m, k in pairs:
    size = k.stat().st_size
    windows = {
        "head": (window_sha(k, 0), window_sha(m, 0)),
        "mid": (window_sha(k, size // 2), window_sha(m, size // 2)),
        "tail": (
            window_sha(k, max(0, size - (1 << 20))),
            window_sha(m, max(0, m.stat().st_size - (1 << 20))),
        ),
    }
    eqs = {name: a == b for name, (a, b) in windows.items()}
    if not all(eqs.values()):
        any_diff = True
    shard_windows[m.name] = {"king": k.name, "equal": eqs}

merge_meta_identical = bool(meta.get("weight_identical"))
# Prefer merge_lora verdict; window probe is a second line of defense when
# shard layouts differ (TalentPigs 16-shard vs CausalLM re-shard).
identical = merge_meta_identical or (not any_diff and len(pairs) > 0)
first_1mib_same = window_sha(ks[0], 0) == window_sha(ms[0], 0)
payload = {
    "merged_n_shards": len(ms),
    "king_n_shards": len(ks),
    "merged_first": ms[0].name,
    "king_first": ks[0].name,
    "first_1MiB_identical": first_1mib_same,
    "merge_meta_weight_identical": merge_meta_identical,
    "window_any_diff": any_diff,
    "identical_to_king": identical,
    "shard_windows_sample": {
        k: shard_windows[k] for k in list(shard_windows)[:3]
    },
    "note": (
        "first_1MiB match alone is NOT refuse (LoRA leaves embeds); "
        "refuse only on merge_meta.weight_identical or all windows equal"
    ),
}
Path("/root/affine_data/h5b_identity.json").write_text(
    json.dumps(payload, indent=2) + "\n"
)
print(json.dumps(payload, indent=2), flush=True)
if identical:
    sys.exit("REFUSE: merged weight-identical to TalentPigs king")
if first_1mib_same and any_diff:
    print(
        "[h5b] NOTE: first_1MiB matches king (expected for TalentPigs-init "
        "LoRA); later windows differ — OK",
        flush=True,
    )
print("[h5b] OK_NON_IDENTICAL_VS_KING", flush=True)
PY

# Adapter + merged HF salvage in background (TTL/deadman insurance).
# Do not submit these repos — salvage only.
# Mid-ckpt watcher already pushes adapter-final under path-in-repo=adapter/;
# wait for that (or mid exit) so we do not race two commits on the same
# private repo, then only push adapter root if mid missed it.
HF_LORA_REPO=${HF_LORA_REPO:-unconst/Affine-5czsc2fc98-h5b-lora}
HF_MERGED_REPO=${HF_MERGED_REPO:-unconst/Affine-5czsc2fc98-h5b-merged}
HF_BASE_HUB=${HF_BASE_HUB:-TalentPigs/affine-5ekxlcg3fx-abc}
SEEN_MID=${SEEN_MID:-/root/h5b/mid_ckpt_salvaged.txt}
if [[ -n "${HF_TOKEN:-}" ]]; then
  log "wait briefly for mid-salvage adapter-final (avoid HF commit race)"
  for _ in $(seq 1 60); do
    if [[ -f "$SEEN_MID" ]] && grep -qx "adapter-final" "$SEEN_MID"; then
      log "mid already salvaged adapter-final — skip root adapter push"
      break
    fi
    if ! pgrep -f "s4-h5b-talentpigs-distill/mid_ckpt_salvage.sh" >/dev/null 2>&1 \
      && [[ -f "$TRAIN_DIR/train.done" ]]; then
      log "mid watcher gone; will push adapter root if needed"
      break
    fi
    sleep 10
  done
  if [[ -f "$SEEN_MID" ]] && grep -qx "adapter-final" "$SEEN_MID"; then
    echo "{\"skipped\":true,\"reason\":\"mid adapter-final present\"}" \
      >/root/affine_data/h5b_adapter_salvage.json
    rm -f /root/logs/h5b_push_adapter.pid
  else
    log "background HF push adapter → $HF_LORA_REPO (base_hub=$HF_BASE_HUB)"
    nohup python3 /root/mining_src/s4-h1-sft/salvage_adapter.py \
      --adapter "$ADAPTER" \
      --repo "$HF_LORA_REPO" \
      --base-hub "$HF_BASE_HUB" \
      --commit-message "H5b TalentPigs-init thought LoRA salvage (TTL insurance; not a submission)" \
      --out-meta /root/affine_data/h5b_adapter_salvage.json \
      >>/root/logs/h5b_push_adapter.nohup 2>&1 &
    echo $! >/root/logs/h5b_push_adapter.pid
  fi
  log "background HF push merged → $HF_MERGED_REPO"
  nohup python3 /root/mining_src/s4-h1-sft/push_merged.py \
    --merged "$MERGED" \
    --repo "$HF_MERGED_REPO" \
    --commit-message "H5b TalentPigs-init thought merged salvage (TTL insurance; not a submission)" \
    --out-meta /root/affine_data/h5b_merged_salvage.json \
    >>/root/logs/h5b_push_merged.nohup 2>&1 &
  echo $! >/root/logs/h5b_push_merged.pid
  log "adapter push pid=$(cat /root/logs/h5b_push_adapter.pid 2>/dev/null || echo skipped) merged push pid=$(cat /root/logs/h5b_push_merged.pid)"
else
  log "WARN: HF_TOKEN unset; skipping H5b HF salvage pushes"
fi

# Health-check king before chall swap.
code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/health || true)
if [[ "$code" != "200" ]]; then
  log "ABORT: king:8001 health=$code"
  echo "aborted_king_unhealthy $(date -u +%Y-%m-%dT%H:%M:%SZ)" > /root/logs/h5b_pipeline.aborted
  exit 1
fi

# Merge used CUDA 6,7; clear before serve so chall lands on physical 4,5
# (serve_three sets CUDA_VISIBLE_DEVICES per engine, but a leaked 6,7 parent
# env has bitten us before — be explicit).
unset CUDA_VISIBLE_DEVICES

log "stop chall; serve merged as chall:8002 (keep teacher+TalentPigs king)"
pidf=/root/logs/vllm_chall.pid
if [[ -f "$pidf" ]]; then
  pid=$(cat "$pidf")
  if kill -0 "$pid" 2>/dev/null; then
    kill "$pid" || true
    for _ in $(seq 1 40); do
      kill -0 "$pid" 2>/dev/null || break
      sleep 2
    done
    kill -9 "$pid" 2>/dev/null || true
  fi
  rm -f "$pidf"
fi
pkill -f "vllm serve .*--port 8002" 2>/dev/null || true
sleep 5

export TEACHER_REPO=${TEACHER_REPO:-zai-org/GLM-4.5-Air-FP8}
export TEACHER_REV=${TEACHER_REV:-}
export KING_REPO KING_REV
export CHALL_REPO=$MERGED
# Local dir: serve_three clears rev when repo is a directory; sentinel avoids
# the kevin Hub-sha default when CHALL_REV is empty.
export CHALL_REV=local
bash /root/mining_src/s3-duel-sim/serve_three.sh
bash /root/mining_src/s3-duel-sim/wait_ready.sh
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h5b_chall_serve.done
log "CHALL_SERVE_DONE"

now=$(date -u +%s)
dead=$(date -u -d "$DEADMAN_UTC" +%s)
if (( dead - now < 2400 )); then
  log "ABORT: <40m to deadman; skip n80"
  echo "aborted_no_n80_budget $(date -u +%Y-%m-%dT%H:%M:%SZ)" > /root/logs/h5b_pipeline.aborted
  exit 1
fi

# n80 under teacher load has died once on httpx.ReadTimeout (H1 @16/80).
# Client is already 360s×5; still wrap retries so a single crash does not
# burn the TalentPigs-init train under deadman 12:00Z.
N80_MAX_ATTEMPTS=${N80_MAX_ATTEMPTS:-3}
n80_ok=0
for attempt in $(seq 1 "$N80_MAX_ATTEMPTS"); do
  now=$(date -u +%s)
  dead=$(date -u -d "$DEADMAN_UTC" +%s)
  # Need ~40m for a full n80; refuse to start a doomed retry.
  if (( dead - now < 2400 )); then
    log "ABORT: <40m to deadman before n80 attempt $attempt; stop"
    echo "aborted_no_n80_budget attempt=$attempt $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
      > /root/logs/h5b_pipeline.aborted
    exit 1
  fi
  # Engines must still be healthy (transient teacher stall / OOM).
  for port in 8000 8001 8002; do
    code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 \
      "http://127.0.0.1:${port}/health" || true)
    if [[ "$code" != "200" ]]; then
      log "WARN: engine :${port} health=${code} before n80 attempt $attempt"
    fi
  done
  rm -f "$SIM_N80" "$PROG" /root/logs/h5b_sim_n80.done
  log "launch n80 sim attempt $attempt/$N80_MAX_ATTEMPTS → $SIM_N80"
  set +e
  python /root/mining_src/s4-h2-merge/run_sim_duel.py \
    --king-repo "$KING_REPO" \
    --king-rev "$KING_REV" \
    --chall-repo "$MERGED" \
    --chall-rev local \
    --n-turns 80 \
    --hotkey local-h5b \
    --out "$SIM_N80" \
    --progress-out "$PROG" \
    --save-artifact \
    2>&1 | tee -a /root/logs/h5b_sim.nohup
  sim_rc=${PIPESTATUS[0]}
  set -e
  if [[ "$sim_rc" -eq 0 && -f "$SIM_N80" ]]; then
    n80_ok=1
    log "n80 attempt $attempt OK"
    break
  fi
  log "WARN: n80 attempt $attempt failed rc=$sim_rc; will retry if budget"
  echo "n80_attempt_${attempt}_failed rc=$sim_rc $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    >> /root/logs/h5b_sim_retries.log
  sleep 15
done
if [[ "$n80_ok" -ne 1 ]]; then
  log "ERROR: n80 failed after $N80_MAX_ATTEMPTS attempts"
  echo "aborted_n80_failed $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    > /root/logs/h5b_pipeline.aborted
  exit 1
fi
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h5b_sim_n80.done
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h5b_pipeline.done
log "SIM_DONE margin=$(python -c "import json;print(json.load(open('$SIM_N80'))['verdict'].get('margin'))" 2>/dev/null || echo '?')"
log "PIPELINE_DONE"
