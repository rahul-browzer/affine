#!/usr/bin/env bash
# p2123b: resume R3 after merge+visual graft — correct n80 flags
set -euo pipefail
[[ -f /root/mine.env ]] && set -a && source /root/mine.env && set +a
source /root/venv/bin/activate 2>/dev/null || true
# score.py lives in the staged affine package (not site-packages)
export PYTHONPATH=/root/mining_src/affine_pkg:${PYTHONPATH:-}
# Prefer venv python — bare `python` can miss pyarrow / affine path
PY=${PY:-/root/venv/bin/python}

MERGED=${MERGED:-/tmp/r3_merged}
BASE=${BASE:-/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53}
KING_REPO=${KING_REPO:-Tok331102/affine-5EqYW8McUc-af10}
KING_REV=${KING_REV:-eb8bf9a356a254f71faaa439e8abc3cfba572c53}
LOG=/root/logs/r3_resume_p2123.nohup
SIM_N80=/root/affine_data/r3_sim_result.json
PROG=/root/affine_data/r3_sim_progress.json
mkdir -p /root/logs /root/affine_data
exec >>"$LOG" 2>&1
log() { echo "[r3-resume] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

log "START_p2123b merged=$MERGED"
[[ -f "$MERGED/model-visual-restored.safetensors" ]] || { log "missing visual"; exit 1; }
nvis=$(python3 -c 'import json; m=json.load(open("/tmp/r3_merged/model.safetensors.index.json")); print(sum(1 for k in m["weight_map"] if "visual" in k))')
log "n_visual=$nvis"
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/r3_merge.done
rm -f /root/logs/r3_pipeline.aborted

# Identity already verified this pass — re-check quickly
python - <<'PY'
import hashlib, json, sys
from pathlib import Path
merged=Path("/tmp/r3_merged")
base=Path("/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53")

def window_sha(path, offset, nbytes=1<<20):
    h=hashlib.sha256(); size=path.stat().st_size
    off=max(0,min(offset,max(0,size-nbytes)))
    with open(path,"rb") as f:
        f.seek(off); h.update(f.read(nbytes))
    return h.hexdigest()

def numbered(p):
    shards=sorted(p.glob("model-*-of-*.safetensors"))
    return shards or sorted(x for x in p.glob("model-*.safetensors") if "visual" not in x.name)

ms, rs = numbered(merged), numbered(base)
by={r.name:r for r in rs}; pairs=[(m,by[m.name]) for m in ms if m.name in by]
any_diff=False
for m,r in pairs:
    size=r.stat().st_size
    if any(window_sha(r,o)!=window_sha(m,o) for o in (0,size//2,max(0,size-(1<<20)))):
        any_diff=True; break
if not any_diff:
    sys.exit("REFUSE identical")
print("[r3] OK_NON_IDENTICAL", flush=True)
PY

code_t=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/health || true)
code_k=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/health || true)
log "engines t=$code_t k=$code_k"
[[ "$code_t" == "200" && "$code_k" == "200" ]] || { log "ABORT teacher/king"; exit 1; }

# If chall already launching/running under prior resume, wait; else re-serve
code_c=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/health || true)
if [[ "$code_c" != "200" ]]; then
  if ! pgrep -f 'restart_for_h2.sh' >/dev/null && ! pgrep -f 'vllm serve /tmp/r3_merged' >/dev/null && ! pgrep -f 'vllm serve .*r3_merged' >/dev/null; then
    log "chall-only re-serve"
    unset CUDA_VISIBLE_DEVICES
    RESTART_KING=0 MERGE="$MERGED" KEVIN_REPO="$KING_REPO" KEVIN_REV="$KING_REV" \
      TEACHER_REPO=zai-org/GLM-4.5-Air-FP8 bash /root/mining_src/s4-h2-merge/restart_for_h2.sh
  else
    log "chall/restart already in flight — wait health"
  fi
  for _ in $(seq 1 180); do
    code_c=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/health || true)
    [[ "$code_c" == "200" ]] && break
    sleep 10
  done
fi
code_c=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/health || true)
log "chall health=$code_c"
[[ "$code_c" == "200" ]] || { log "ABORT chall"; echo "aborted_chall $(date -u +%Y-%m-%dT%H:%M:%SZ)" > /root/logs/r3_pipeline.aborted; exit 1; }
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/r3_chall_serve.done

N80_MAX_ATTEMPTS=3
BLOCK_HASHES=(
  "a203000000000000000000000000000000000000000000000000000000000001"
  "b203000000000000000000000000000000000000000000000000000000000002"
  "c203000000000000000000000000000000000000000000000000000000000003"
)
n80_ok=0
for attempt in $(seq 1 "$N80_MAX_ATTEMPTS"); do
  if ps -eo args | awk '/[r]un_sim_duel.py/ && /local-r3/' | grep -q .; then
    log "n80 already running — wait"; n80_ok=1; break
  fi
  bh="${BLOCK_HASHES[$(( (attempt - 1) % ${#BLOCK_HASHES[@]} ))]}"
  rm -f "$SIM_N80" "$PROG" /root/logs/r3_sim_n80.done
  log "launch n80 attempt $attempt block_hash=${bh:0:16}…"
  set +e
  "$PY" /root/mining_src/s4-h2-merge/run_sim_duel.py \
    --king-repo "$KING_REPO" \
    --king-rev "$KING_REV" \
    --chall-repo "$MERGED" \
    --chall-rev local \
    --n-turns 80 \
    --hotkey local-r3 \
    --block-hash "$bh" \
    --out "$SIM_N80" \
    --progress-out "$PROG" \
    --save-artifact \
    2>&1 | tee -a /root/logs/r3_sim.nohup
  sim_rc=${PIPESTATUS[0]}
  set -e
  if [[ "$sim_rc" -eq 0 && -f "$SIM_N80" ]]; then
    n80_ok=1
    log "n80 attempt $attempt OK"
    break
  fi
  log "WARN n80 attempt $attempt rc=$sim_rc"
  sleep 15
done

if [[ "$n80_ok" -ne 1 ]]; then
  log "ERROR n80 failed"
  echo "aborted_n80_failed $(date -u +%Y-%m-%dT%H:%M:%SZ)" > /root/logs/r3_pipeline.aborted
  exit 1
fi
# If we deferred to already-running, wait for result
for _ in $(seq 1 360); do
  [[ -f "$SIM_N80" ]] && break
  sleep 30
done
[[ -f "$SIM_N80" ]] || { log "no sim result"; exit 1; }
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/r3_sim_n80.done
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/r3_pipeline.done
if [[ -f /root/mining_src/s4-h2-merge/write_merge_decision.py ]]; then
  "$PY" /root/mining_src/s4-h2-merge/write_merge_decision.py \
    --result "$SIM_N80" --out /root/affine_data/r3_decision.json --label r3-reason-grpo || true
fi
log "SIM_DONE margin=$("$PY" -c "import json;print(json.load(open('$SIM_N80'))['verdict'].get('margin'))" 2>/dev/null || echo '?')"
log "PIPELINE_DONE"
