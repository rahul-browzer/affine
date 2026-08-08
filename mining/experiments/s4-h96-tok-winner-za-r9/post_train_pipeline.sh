#!/usr/bin/env bash
# After H96 train.done: merge LoRA → chall:8002 → n80 vs Tok331102 king.
# Base = Tok331102 (train init = king) (train init); sim king = live Tok331102. Prewarm holds teacher+king.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export HF_TOKEN="${HF_TOKEN:-}"

export HF_HOME=${HF_HOME:-/root/hf}
export PYTHONPATH=/root/mining_src/affine_pkg:${PYTHONPATH:-}
export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:-6,7}

BASE=${BASE:-/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53}
KING_REPO=${KING_REPO:-Tok331102/affine-5EqYW8McUc-af10}
KING_REV=${KING_REV:-eb8bf9a356a254f71faaa439e8abc3cfba572c53}
KING_LOCAL=${KING_LOCAL:-/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53}
TRAIN_DIR=${TRAIN_DIR:-/root/h96/train}
ADAPTER=${ADAPTER:-$TRAIN_DIR/adapter}
CKPT_ROOT=${CKPT_ROOT:-$TRAIN_DIR/checkpoints}
MERGED=${MERGED:-/root/h96/merged}
SIM_N80=/root/affine_data/h96_sim_result.json
PROG=/root/affine_data/h96_sim_progress.json
LOG=/root/logs/h96_pipeline.nohup
# Patched pass259: TTL remove_at=2026-08-08T19:01Z → soft=TTL−1h, deadman=TTL
# Pass312 rent ~13:19Z ttl12h → remove≈01:19Z+1d; soft=TTL−1h, deadman=TTL−30m
SOFT_DEADLINE_UTC=${SOFT_DEADLINE_UTC:-2026-08-09T00:29:00Z}
DEADMAN_UTC=${DEADMAN_UTC:-2026-08-09T00:59:00Z}

log() { echo "[h96-pipe] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

# Prefer pidfile over `pgrep -f train_lora.py`: host SSH scrapes that embed the
# pattern in argv false-match and can stall the post-train.done GPU wait forever.
_train_alive() {
  if [[ -f /root/logs/h96_train.pid ]]; then
    local tpid
    tpid=$(cat /root/logs/h96_train.pid 2>/dev/null || true)
    if [[ -n "${tpid:-}" ]] && kill -0 "$tpid" 2>/dev/null; then
      return 0
    fi
  fi
  # Narrow fallback: real trainer argv starts with python3 + full script path.
  pgrep -f "python3 /root/mining_src/s4-h1v2-sft/train_lora.py --base" >/dev/null 2>&1
}

_abort_on_exit() {
  local rc=$?
  if [[ $rc -eq 0 ]]; then
    return 0
  fi
  if [[ -f /root/logs/h96_pipeline.done ]]; then
    return 0
  fi
  if [[ ! -f /root/logs/h96_pipeline.aborted ]]; then
    echo "aborted_err_rc=${rc} $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
      >/root/logs/h96_pipeline.aborted
    echo "[h96-pipe] $(date -u +%Y-%m-%dT%H:%M:%SZ) EXIT trap wrote aborted_err_rc=${rc}" \
      | tee -a "$LOG" >/dev/null 2>&1 || true
  fi
}
trap _abort_on_exit EXIT

mkdir -p /root/logs /root/affine_data /root/h96
rm -f /root/logs/h96_pipeline.aborted /root/logs/h96_pipeline.done \
  /root/logs/h96_merge.done /root/logs/h96_chall_serve.done \
  /root/logs/h96_sim_n80.done

log "waiting for $TRAIN_DIR/train.done (or adapter + no train proc)"
_wait_i=0
while true; do
  if [[ -f "$TRAIN_DIR/train.done" ]]; then
    log "train.done present"
    break
  fi
  if [[ -f "$ADAPTER/adapter_config.json" ]] && ! _train_alive; then
    log "adapter present and train proc gone - proceed"
    break
  fi
  now=$(date -u +%s)
  soft=$(date -u -d "$SOFT_DEADLINE_UTC" +%s)
  if (( now > soft - 3600 )); then
    log "WARN: <60m to soft and train not done; abort"
    echo "aborted_no_train $(date -u +%Y-%m-%dT%H:%M:%SZ)" > /root/logs/h96_pipeline.aborted
    exit 1
  fi
  _wait_i=$((_wait_i + 1))
  if (( _wait_i % 10 == 0 )); then
    log "still waiting for train.done (poll #$_wait_i)"
  fi
  sleep 30
done

log "waiting for train pid to exit and release GPUs 6,7"
for _ in $(seq 1 180); do
  if ! _train_alive; then
    log "train proc gone"
    break
  fi
  sleep 5
done
if _train_alive; then
  log "ERROR: train still alive >15m after train.done; abort"
  echo "aborted_train_stuck $(date -u +%Y-%m-%dT%H:%M:%SZ)" > /root/logs/h96_pipeline.aborted
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
      >/root/logs/h96_pipeline.aborted
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
cp -f "$MERGED/merge_meta.json" /root/affine_data/h96_merge_meta.json 2>/dev/null || true
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h96_merge.done

# Refuse weight-identical to Tok331102 base/king (same checkpoint).
python - <<PY 2>&1 | tee -a "$LOG"
import hashlib, json, sys
from pathlib import Path

merged = Path("$MERGED")
base = Path("$BASE")
king = Path("$KING_LOCAL")
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


def probe(ref: Path, label: str):
    ms, rs = numbered(merged), numbered(ref)
    if not ms or not rs:
        return {"label": label, "error": "missing shards", "identical": True}
    by_name = {r.name: r for r in rs}
    pairs = [(m, by_name[m.name]) for m in ms if m.name in by_name]
    if not pairs:
        n = min(len(ms), len(rs))
        pairs = list(zip(ms[:n], rs[:n]))
    any_diff = False
    for m, r in pairs:
        size = r.stat().st_size
        windows = [
            (window_sha(r, 0), window_sha(m, 0)),
            (window_sha(r, size // 2), window_sha(m, size // 2)),
            (
                window_sha(r, max(0, size - (1 << 20))),
                window_sha(m, max(0, m.stat().st_size - (1 << 20))),
            ),
        ]
        if any(a != b for a, b in windows):
            any_diff = True
            break
    return {
        "label": label,
        "n_pairs": len(pairs),
        "window_any_diff": any_diff,
        "identical": not any_diff and len(pairs) > 0,
    }


base_probe = probe(base, "tok_init_base")
king_probe = probe(king, "tok331102_king") if king.is_dir() else {
    "label": "tok331102_king", "error": "missing local king", "identical": False
}
merge_meta_identical = bool(meta.get("weight_identical"))
identical_base = merge_meta_identical or base_probe.get("identical")
identical_king = bool(king_probe.get("identical"))
payload = {
    "merge_meta_weight_identical": merge_meta_identical,
    "vs_tok_init_base": base_probe,
    "vs_tok331102_king": king_probe,
    "identical_to_base": identical_base,
    "identical_to_king": identical_king,
}
Path("/root/affine_data/h96_identity.json").write_text(
    json.dumps(payload, indent=2) + "\n"
)
print(json.dumps(payload, indent=2), flush=True)
if identical_base:
    sys.exit("REFUSE: merged weight-identical to Tok init base")
if identical_king:
    sys.exit("REFUSE: merged weight-identical to Tok331102 king")
print("[h96] OK_NON_IDENTICAL", flush=True)
PY

HF_LORA_REPO=${HF_LORA_REPO:-unconst/Affine-5czsc2fc98-h96-lora}
HF_MERGED_REPO=${HF_MERGED_REPO:-unconst/Affine-5czsc2fc98-h96-merged}
HF_BASE_HUB=${HF_BASE_HUB:-Tok331102/affine-5EqYW8McUc-af10}
SEEN_MID=${SEEN_MID:-/root/h96/mid_ckpt_salvaged.txt}
if [[ -n "${HF_TOKEN:-}" ]]; then
  if [[ -f "$SEEN_MID" ]] && grep -qx "adapter-final" "$SEEN_MID"; then
    log "mid already salvaged adapter-final - skip root adapter push"
    echo "{\"skipped\":true,\"reason\":\"mid adapter-final present\"}" \
      >/root/affine_data/h96_adapter_salvage.json
    rm -f /root/logs/h96_push_adapter.pid
  elif pgrep -f "s4-h96-tok-winner-za-r9/mid_ckpt_salvage.sh" >/dev/null 2>&1; then
    log "mid still running - skip root adapter push"
    echo "{\"skipped\":true,\"reason\":\"mid still running\"}" \
      >/root/affine_data/h96_adapter_salvage.json
    rm -f /root/logs/h96_push_adapter.pid
  else
    log "background HF push adapter → $HF_LORA_REPO"
    nohup python3 /root/mining_src/s4-h1-sft/salvage_adapter.py \
      --adapter "$ADAPTER" \
      --repo "$HF_LORA_REPO" \
      --base-hub "$HF_BASE_HUB" \
      --commit-message "H96 Tok-init winner-zA thought LoRA salvage (TTL insurance; not a submission)" \
      --out-meta /root/affine_data/h96_adapter_salvage.json \
      >>/root/logs/h96_push_adapter.nohup 2>&1 &
    echo $! >/root/logs/h96_push_adapter.pid
  fi
  log "background HF push merged → $HF_MERGED_REPO (non-blocking)"
  # Always --public: private HF storage quota hard-fails full merges (LESSONS).
  nohup python3 /root/mining_src/s4-h1-sft/push_merged.py \
    --merged "$MERGED" \
    --repo "$HF_MERGED_REPO" \
    --public \
    --commit-message "H96 Tok-init winner-zA thought merged salvage (TTL insurance; not a submission)" \
    --out-meta /root/affine_data/h96_merged_salvage.json \
    >>/root/logs/h96_push_merged.nohup 2>&1 &
  echo $! >/root/logs/h96_push_merged.pid
  log "adapter push pid=$(cat /root/logs/h96_push_adapter.pid 2>/dev/null || echo skipped) merged push pid=$(cat /root/logs/h96_push_merged.pid)"
else
  log "WARN: HF_TOKEN unset; skipping H96 HF salvage pushes"
fi

# Prefer prewarmed teacher+king; otherwise start them before chall.
code_t=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/health || true)
code_k=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/health || true)
if [[ "$code_t" != "200" || "$code_k" != "200" ]]; then
  log "teacher/king not ready (t=$code_t k=$code_k); launching via serve_three (chall placeholder=Tok331102)"
  unset CUDA_VISIBLE_DEVICES
  TEACHER_REPO=${TEACHER_REPO:-zai-org/GLM-4.5-Air-FP8} \
    TEACHER_REV=${TEACHER_REV:-} \
    KING_REPO="$KING_REPO" \
    KING_REV="$KING_REV" \
    CHALL_REPO="$BASE" \
    CHALL_REV=local \
    bash /root/mining_src/s3-duel-sim/serve_three.sh
  # Wait teacher+king only; kill placeholder chall so GPUs 4,5 stay free for merge settle / real chall.
  if [[ -f /root/logs/vllm_chall.pid ]]; then
    cpid=$(cat /root/logs/vllm_chall.pid)
    if kill -0 "$cpid" 2>/dev/null; then
      log "stop placeholder chall pid=$cpid"
      kill "$cpid" || true
      for _ in $(seq 1 30); do
        kill -0 "$cpid" 2>/dev/null || break
        sleep 2
      done
      kill -9 "$cpid" 2>/dev/null || true
    fi
    rm -f /root/logs/vllm_chall.pid
  fi
  for _ in $(seq 1 120); do
    code_t=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/health || true)
    code_k=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/health || true)
    if [[ "$code_t" == "200" && "$code_k" == "200" ]]; then
      break
    fi
    sleep 15
  done
fi
code_t=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/health || true)
code_k=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/health || true)
if [[ "$code_t" != "200" || "$code_k" != "200" ]]; then
  log "ABORT: teacher/king unhealthy after wait t=$code_t k=$code_k"
  echo "aborted_engines_unhealthy $(date -u +%Y-%m-%dT%H:%M:%SZ)" > /root/logs/h96_pipeline.aborted
  exit 1
fi

unset CUDA_VISIBLE_DEVICES

# RESTART_KING=0 keeps prewarmed Tok331102 on :8001; KEVIN_REPO is the env name
# restart_for_h2.sh uses for KING_REPO when it would restart king (it won't here).
log "chall-only re-serve $MERGED (keep teacher+Tok331102 king)"
RESTART_KING=0 \
  MERGE="$MERGED" \
  KEVIN_REPO="$KING_REPO" \
  KEVIN_REV="$KING_REV" \
  TEACHER_REPO=${TEACHER_REPO:-zai-org/GLM-4.5-Air-FP8} \
  TEACHER_REV=${TEACHER_REV:-} \
  bash /root/mining_src/s4-h2-merge/restart_for_h2.sh
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h96_chall_serve.done
log "CHALL_SERVE_DONE"

now=$(date -u +%s)
dead=$(date -u -d "$DEADMAN_UTC" +%s)
if (( dead - now < 2400 )); then
  log "ABORT: <40m to deadman; skip n80"
  echo "aborted_no_n80_budget $(date -u +%Y-%m-%dT%H:%M:%SZ)" > /root/logs/h96_pipeline.aborted
  exit 1
fi

N80_MAX_ATTEMPTS=${N80_MAX_ATTEMPTS:-3}
# Fresh block_hash per attempt (H32/H34/H96): default 0*64 dies teacher 400 @~40/80.
# Prefer leaving n80 to retry_h*_n80.sh when watch_n80_retry is armed — dual launch races.
BLOCK_HASHES=(
  "a203000000000000000000000000000000000000000000000000000000000001"
  "b203000000000000000000000000000000000000000000000000000000000002"
  "c203000000000000000000000000000000000000000000000000000000000003"
)
n80_ok=0
for attempt in $(seq 1 "$N80_MAX_ATTEMPTS"); do
  now=$(date -u +%s)
  dead=$(date -u -d "$DEADMAN_UTC" +%s)
  if (( dead - now < 2400 )); then
    log "ABORT: <40m to deadman before n80 attempt $attempt; stop"
    echo "aborted_no_n80_budget attempt=$attempt $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
      > /root/logs/h96_pipeline.aborted
    exit 1
  fi
  for port in 8000 8001 8002; do
    code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 \
      "http://127.0.0.1:${port}/health" || true)
    if [[ "$code" != "200" ]]; then
      log "WARN: engine :${port} health=${code} before n80 attempt $attempt"
    fi
  done
  # Retry owns hashed n80. Skip if sim OR watcher/retry armed (pass218:
  # sim-only check lost the race — both launched within ~16s of promptable).
  if ps -eo args | awk '/[r]un_sim_duel.py/ && /local-h96/' | grep -q .; then
    log "n80 already running under retry — skip post_train launch"
    n80_ok=1
    break
  fi
  if ps -eo args | awk '/[w]atch_n80_retry\.sh/ && / h96 /' | grep -q . \
    || ps -eo args | awk '/[r]etry_h96_n80\.sh/' | grep -q .; then
    log "watch_n80_retry/retry_h96 armed — defer n80 to retry; skip post_train launch"
    n80_ok=1
    break
  fi
  rm -f "$SIM_N80" "$PROG" /root/logs/h96_sim_n80.done
  bh="${BLOCK_HASHES[$(( (attempt - 1) % ${#BLOCK_HASHES[@]} ))]}"
  log "launch n80 sim attempt $attempt/$N80_MAX_ATTEMPTS block_hash=${bh:0:16}… → $SIM_N80"
  set +e
  python /root/mining_src/s4-h2-merge/run_sim_duel.py \
    --king-repo "$KING_REPO" \
    --king-rev "$KING_REV" \
    --chall-repo "$MERGED" \
    --chall-rev local \
    --n-turns 80 \
    --hotkey local-h96 \
    --block-hash "$bh" \
    --out "$SIM_N80" \
    --progress-out "$PROG" \
    --save-artifact \
    2>&1 | tee -a /root/logs/h96_sim.nohup
  sim_rc=${PIPESTATUS[0]}
  set -e
  if [[ "$sim_rc" -eq 0 && -f "$SIM_N80" ]]; then
    n80_ok=1
    log "n80 attempt $attempt OK"
    break
  fi
  log "WARN: n80 attempt $attempt failed rc=$sim_rc; will retry if budget"
  echo "n80_attempt_${attempt}_failed rc=$sim_rc $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    >> /root/logs/h96_sim_retries.log
  sleep 15
done
if [[ "$n80_ok" -ne 1 ]]; then
  log "ERROR: n80 failed after $N80_MAX_ATTEMPTS attempts"
  echo "aborted_n80_failed $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    > /root/logs/h96_pipeline.aborted
  exit 1
fi
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h96_sim_n80.done
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h96_pipeline.done
log "SIM_DONE margin=$(python -c "import json;print(json.load(open('$SIM_N80'))['verdict'].get('margin'))" 2>/dev/null || echo '?')"
log "PIPELINE_DONE"
