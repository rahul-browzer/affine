#!/usr/bin/env bash
# Resume H5 after merge wrote /root/merges/h5-kt65 but the king-identity
# check crashed (TalentPigs 16-shard vs merge 2-shard filename mismatch).
# Skips re-merge; runs refuse check → chall re-serve → n80 sim.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

export HF_HOME=${HF_HOME:-/root/hf}
export PYTHONPATH=/root/mining_src/affine_pkg:${PYTHONPATH:-}

SRC=${SRC:-/root/mining_src/s4-h5-talentpigs}
H2SRC=${H2SRC:-/root/mining_src/s4-h2-merge}
OUT=${OUT:-/root/merges/h5-kt65}
ALPHA=${ALPHA:-0.65}
KING_REPO=${KING_REPO:-TalentPigs/affine-5ekxlcg3fx-abc}
KING_REV=${KING_REV:-dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4}

LOG=/root/logs/h5_merge_sim.nohup
MERGE_DONE=/root/logs/h5_merge.done
SERVE_DONE=/root/logs/h5_chall_serve.done
SIM_DONE=/root/logs/h5_sim_n80.done
PIPE_DONE=/root/logs/h5_merge_sim.done
mkdir -p /root/logs /root/affine_data
rm -f "$SERVE_DONE" "$SIM_DONE" "$PIPE_DONE" \
  /root/logs/h5_merge_sim.aborted /root/logs/h5_merge_sim.partial

log() { echo "[h5-resume] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

if [[ ! -f "$OUT/model.safetensors.index.json" || ! -f "$OUT/merge_meta.json" ]]; then
  log "ABORT: merge incomplete at $OUT"
  echo "aborted_no_merge $(date -u +%Y-%m-%dT%H:%M:%SZ)" > /root/logs/h5_merge_sim.aborted
  exit 1
fi

log "resume from existing merge alpha=$ALPHA out=$OUT"

# Refuse weight-identical (layout-aware: TalentPigs=16-shard, merge=2-shard)
python - <<PY 2>&1 | tee -a "$LOG"
import hashlib, json, sys
from pathlib import Path
out = Path("$OUT")
king = Path("$HF_HOME") / "hub" / "models--TalentPigs--affine-5ekxlcg3fx-abc" / "snapshots" / "$KING_REV"
meta = json.loads((out / "merge_meta.json").read_text())
shard = meta["first_shard"]
king_shards = sorted(king.glob("model-*.safetensors"))
if not king_shards:
    sys.exit(f"REFUSE: no model-*.safetensors under {king}")
king_shard = king_shards[0].name
def sha1m(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        h.update(f.read(1 << 20))
    return h.hexdigest()
o = sha1m(out / shard)
k = sha1m(king / king_shard)
payload = {
    "out_first_shard": shard,
    "king_first_shard": king_shard,
    "shard_layout_match": shard == king_shard,
    "king_first_1MiB": k,
    "out_first_1MiB": o,
    "identical_to_king": (shard == king_shard and o == k),
    "max_abs_delta_sample": meta.get("max_abs_delta_sample"),
    "first_1MiB_identical_vs_A": meta.get("first_1MiB_identical"),
}
print(json.dumps(payload, indent=2), flush=True)
Path("/root/affine_data/h5_kt65_identity.json").write_text(json.dumps(payload, indent=2) + "\n")
if payload["identical_to_king"]:
    sys.exit("REFUSE: merge first_1MiB identical to TalentPigs king")
if meta.get("first_1MiB_identical"):
    sys.exit("REFUSE: merge first_1MiB identical to kevin (A)")
print("[h5-resume] OK_NON_IDENTICAL_VS_KING", flush=True)
PY

date -u +%Y-%m-%dT%H:%M:%SZ >"$MERGE_DONE"
cp -f "$OUT/merge_meta.json" /root/affine_data/h5_kt65_merge_meta.json
log "MERGE_DONE -> $MERGE_DONE"

# King must already be TalentPigs
if [[ ! -f /root/logs/h5_king_pivot.done ]]; then
  log "ABORT: missing h5_king_pivot.done"
  echo "aborted_no_king_pivot $(date -u +%Y-%m-%dT%H:%M:%SZ)" > /root/logs/h5_merge_sim.aborted
  exit 1
fi
code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/health || true)
if [[ "$code" != "200" ]]; then
  log "ABORT: king:8001 health=$code"
  echo "aborted_king_unhealthy $(date -u +%Y-%m-%dT%H:%M:%SZ)" > /root/logs/h5_merge_sim.aborted
  exit 1
fi
log "king:8001 healthy"

# Re-serve chall = merge (keep teacher+king)
log "stop chall; serve merge as chall:8002"
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
export KING_REPO
export KING_REV
export CHALL_REPO=$OUT
export CHALL_REV=local
bash /root/mining_src/s3-duel-sim/serve_three.sh
bash /root/mining_src/s3-duel-sim/wait_ready.sh
date -u +%Y-%m-%dT%H:%M:%SZ >"$SERVE_DONE"
log "CHALL_SERVE_DONE -> $SERVE_DONE"

SIM_OUT=/root/affine_data/h5_kt65_sim_result.json
PROG=/root/affine_data/h5_kt65_sim_progress.json
rm -f "$SIM_OUT" "$PROG" "$SIM_DONE"
log "launch n80 sim -> $SIM_OUT"
python "$H2SRC/run_sim_duel.py" \
  --king-repo "$KING_REPO" \
  --king-rev "$KING_REV" \
  --chall-repo "$OUT" \
  --chall-rev local \
  --n-turns 80 \
  --hotkey local-h5-kt65 \
  --out "$SIM_OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee -a /root/logs/h5_kt65_sim.nohup
date -u +%Y-%m-%dT%H:%M:%SZ >"$SIM_DONE"
date -u +%Y-%m-%dT%H:%M:%SZ >"$PIPE_DONE"
log "SIM_DONE margin=$(python -c "import json;print(json.load(open('$SIM_OUT'))['verdict'].get('margin'))" 2>/dev/null || echo '?')"
log "PIPELINE_DONE -> $PIPE_DONE"
