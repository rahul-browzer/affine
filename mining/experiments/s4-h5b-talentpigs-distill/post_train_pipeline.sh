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

if [[ ! -f "$ADAPTER/adapter_config.json" ]]; then
  latest=$(ls -d "$CKPT_ROOT"/checkpoint-* 2>/dev/null | sort -V | tail -1 || true)
  if [[ -n "${latest:-}" && -f "$latest/adapter_config.json" ]]; then
    ADAPTER=$latest
    log "using checkpoint adapter $ADAPTER"
  else
    log "ERROR: no adapter"
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

# Refuse weight-identical to king (first 1MiB of first shard).
python - <<PY 2>&1 | tee -a "$LOG"
import hashlib, json, sys
from pathlib import Path
merged = Path("$MERGED")
king = Path("$BASE")
meta = json.loads((merged / "merge_meta.json").read_text()) if (merged / "merge_meta.json").is_file() else {}
def sha1m(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        h.update(f.read(1 << 20))
    return h.hexdigest()
ms = sorted(merged.glob("model-*.safetensors"))
ks = sorted(king.glob("model-*.safetensors"))
if not ms or not ks:
    sys.exit("REFUSE: missing shards")
o, k = sha1m(ms[0]), sha1m(ks[0])
payload = {
    "merged_first": ms[0].name,
    "king_first": ks[0].name,
    "out_first_1MiB": o,
    "king_first_1MiB": k,
    "identical_to_king": (ms[0].name == ks[0].name and o == k),
    "merge_meta_keys": list(meta.keys())[:12],
}
Path("/root/affine_data/h5b_identity.json").write_text(json.dumps(payload, indent=2) + "\n")
print(json.dumps(payload, indent=2), flush=True)
if payload["identical_to_king"]:
    sys.exit("REFUSE: merged first_1MiB identical to TalentPigs king")
print("[h5b] OK_NON_IDENTICAL_VS_KING", flush=True)
PY

# Adapter + merged HF salvage in background (TTL/deadman insurance).
# Do not submit these repos — salvage only.
HF_LORA_REPO=${HF_LORA_REPO:-unconst/Affine-5czsc2fc98-h5b-lora}
HF_MERGED_REPO=${HF_MERGED_REPO:-unconst/Affine-5czsc2fc98-h5b-merged}
if [[ -n "${HF_TOKEN:-}" ]]; then
  log "background HF push adapter → $HF_LORA_REPO"
  nohup python3 /root/mining_src/s4-h1-sft/salvage_adapter.py \
    --adapter "$ADAPTER" \
    --repo "$HF_LORA_REPO" \
    --commit-message "H5b TalentPigs-init thought LoRA salvage (TTL insurance; not a submission)" \
    --out-meta /root/affine_data/h5b_adapter_salvage.json \
    >>/root/logs/h5b_push_adapter.nohup 2>&1 &
  echo $! >/root/logs/h5b_push_adapter.pid
  log "background HF push merged → $HF_MERGED_REPO"
  nohup python3 /root/mining_src/s4-h1-sft/push_merged.py \
    --merged "$MERGED" \
    --repo "$HF_MERGED_REPO" \
    --commit-message "H5b TalentPigs-init thought merged salvage (TTL insurance; not a submission)" \
    --out-meta /root/affine_data/h5b_merged_salvage.json \
    >>/root/logs/h5b_push_merged.nohup 2>&1 &
  echo $! >/root/logs/h5b_push_merged.pid
  log "adapter push pid=$(cat /root/logs/h5b_push_adapter.pid) merged push pid=$(cat /root/logs/h5b_push_merged.pid)"
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

log "stop chall; serve merged as chall:8002"
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

rm -f "$SIM_N80" "$PROG" /root/logs/h5b_sim_n80.done
log "launch n80 sim → $SIM_N80"
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
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h5b_sim_n80.done
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h5b_pipeline.done
log "SIM_DONE margin=$(python -c "import json;print(json.load(open('$SIM_N80'))['verdict'].get('margin'))" 2>/dev/null || echo '?')"
log "PIPELINE_DONE"
