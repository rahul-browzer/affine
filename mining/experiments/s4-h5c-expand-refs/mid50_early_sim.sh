#!/usr/bin/env bash
# Early mid50 merge → chall:8002 → n40 while final train continues on GPUs 6,7.
# Uses free GPUs 4,5 only. Separate paths from post_train_pipeline.sh.
# Yields (stops chall, exits) when final pipe writes h5c_merge.done so the
# final chall re-serve is not blocked. Does NOT touch pipeline markers.
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

BASE=${BASE:-/root/hf/hub/models--kevin954--Affine-5dfqbbh8ev-sft/snapshots/6a5815fad8f4e34c983b1933c1fae5762fe25220}
KING_REPO=${KING_REPO:-TalentPigs/affine-5ekxlcg3fx-abc}
KING_REV=${KING_REV:-dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4}
ADAPTER=${ADAPTER:-/root/h5c/train/checkpoints/checkpoint-50}
MERGED=${MERGED:-/root/h5c/merged_mid50}
SIM_N40=${SIM_N40:-/root/affine_data/h5c_mid50_sim_n40.json}
PROG=${PROG:-/root/affine_data/h5c_mid50_sim_progress.json}
LOG=/root/logs/h5c_mid50_early.nohup
HF_MERGED_REPO=${HF_MERGED_REPO:-unconst/Affine-5czsc2fc98-h5c-merged}

log() { echo "[h5c-mid50] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

mkdir -p /root/logs /root/affine_data /root/h5c
rm -f /root/logs/h5c_mid50_early.{done,aborted} \
  /root/logs/h5c_mid50_merge.done /root/logs/h5c_mid50_chall.done \
  /root/logs/h5c_mid50_sim_n40.done

if [[ ! -f "$ADAPTER/adapter_config.json" ]]; then
  log "ERROR: adapter missing at $ADAPTER"
  echo "aborted_no_adapter $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    >/root/logs/h5c_mid50_early.aborted
  exit 1
fi

# Abort helpers: final pipe owns chall once it finishes its own merge.
_final_merge_done() { [[ -f /root/logs/h5c_merge.done ]]; }

_yield_to_final() {
  log "YIELD: final h5c_merge.done present — stop mid50 chall, exit"
  if [[ -f /root/logs/vllm_chall.pid ]]; then
    cpid=$(cat /root/logs/vllm_chall.pid)
    if kill -0 "$cpid" 2>/dev/null; then
      kill "$cpid" || true
      for _ in $(seq 1 20); do
        kill -0 "$cpid" 2>/dev/null || break
        sleep 2
      done
      kill -9 "$cpid" 2>/dev/null || true
    fi
    rm -f /root/logs/vllm_chall.pid
  fi
  echo "yielded_to_final_pipe $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    >/root/logs/h5c_mid50_early.aborted
  exit 0
}

if _final_merge_done; then
  log "final merge already done — nothing to do"
  echo "skipped_final_already $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    >/root/logs/h5c_mid50_early.aborted
  exit 0
fi

log "merge mid50 LoRA → $MERGED on CUDA 4,5"
export CUDA_VISIBLE_DEVICES=4,5
rm -rf "$MERGED"
python /root/mining_src/s4-h1-sft/merge_lora.py \
  --base "$BASE" \
  --adapter "$ADAPTER" \
  --out "$MERGED" \
  --device-map auto \
  | tee -a "$LOG"
cp -f "$MERGED/merge_meta.json" /root/affine_data/h5c_mid50_merge_meta.json 2>/dev/null || true
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h5c_mid50_merge.done
log "MERGE_DONE"

if _final_merge_done; then _yield_to_final; fi

# Background HF push of mid50 merged (non-blocking; TTL insurance).
if [[ -n "${HF_TOKEN:-}" ]]; then
  log "background HF push mid50 merged → $HF_MERGED_REPO"
  nohup python3 /root/mining_src/s4-h1-sft/push_merged.py \
    --merged "$MERGED" \
    --repo "$HF_MERGED_REPO" \
    --commit-message "H5c mid50 merged salvage (TTL insurance; not a submission)" \
    --out-meta /root/affine_data/h5c_mid50_merged_salvage.json \
    >>/root/logs/h5c_mid50_push_merged.nohup 2>&1 &
  echo $! >/root/logs/h5c_mid50_push_merged.pid
fi

unset CUDA_VISIBLE_DEVICES

if _final_merge_done; then _yield_to_final; fi

# Teacher+king must already be up from prewarm; only swap chall.
code_t=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/health || true)
code_k=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/health || true)
if [[ "$code_t" != "200" || "$code_k" != "200" ]]; then
  log "ERROR: teacher/king not ready t=$code_t k=$code_k — abort mid50 early"
  echo "aborted_engines $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    >/root/logs/h5c_mid50_early.aborted
  exit 1
fi

log "chall-only serve mid50 merged (keep teacher+TalentPigs king)"
RESTART_KING=0 \
  MERGE="$MERGED" \
  KEVIN_REPO="$KING_REPO" \
  KEVIN_REV="$KING_REV" \
  TEACHER_REPO=${TEACHER_REPO:-zai-org/GLM-4.5-Air-FP8} \
  TEACHER_REV=${TEACHER_REV:-} \
  bash /root/mining_src/s4-h2-merge/restart_for_h2.sh \
  | tee -a "$LOG"
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h5c_mid50_chall.done
log "CHALL_SERVE_DONE"

if _final_merge_done; then _yield_to_final; fi

rm -f "$SIM_N40" "$PROG" /root/logs/h5c_mid50_sim_n40.done
log "launch n40 sim vs TalentPigs → $SIM_N40"
set +e
python /root/mining_src/s4-h2-merge/run_sim_duel.py \
  --king-repo "$KING_REPO" \
  --king-rev "$KING_REV" \
  --chall-repo "$MERGED" \
  --chall-rev local \
  --n-turns 40 \
  --hotkey local-h5c-mid50 \
  --out "$SIM_N40" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee -a /root/logs/h5c_mid50_sim.nohup &
sim_pid=$!
set -e

# Poll: finish or yield if final pipe claims chall.
while kill -0 "$sim_pid" 2>/dev/null; do
  if _final_merge_done; then
    log "final merge during n40 — kill sim and yield chall"
    kill "$sim_pid" 2>/dev/null || true
    wait "$sim_pid" 2>/dev/null || true
    _yield_to_final
  fi
  sleep 15
done
wait "$sim_pid" || true
sim_rc=$?

if [[ -f "$SIM_N40" ]]; then
  date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h5c_mid50_sim_n40.done
  margin=$(python -c "import json;print(json.load(open('$SIM_N40'))['verdict'].get('margin'))" 2>/dev/null || echo '?')
  log "N40_DONE margin=$margin rc=$sim_rc"
  # Free chall for final pipe (do not leave mid50 occupying :8002).
  if [[ -f /root/logs/vllm_chall.pid ]]; then
    cpid=$(cat /root/logs/vllm_chall.pid)
    if kill -0 "$cpid" 2>/dev/null; then
      log "stop mid50 chall pid=$cpid (free 4,5 for final pipe)"
      kill "$cpid" || true
      sleep 5
      kill -9 "$cpid" 2>/dev/null || true
    fi
    rm -f /root/logs/vllm_chall.pid
  fi
  date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h5c_mid50_early.done
  log "MID50_EARLY_DONE"
  exit 0
fi

log "ERROR: n40 produced no result rc=$sim_rc"
echo "aborted_n40_failed rc=$sim_rc $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  >/root/logs/h5c_mid50_early.aborted
exit 1
