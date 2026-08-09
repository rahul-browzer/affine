#!/usr/bin/env bash
# After H121 train.done: finalize visual → chall:8002 → n80 vs Tok331102 king.
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

BASE=${BASE:-/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53}
KING_REPO=${KING_REPO:-Tok331102/affine-5EqYW8McUc-af10}
KING_REV=${KING_REV:-eb8bf9a356a254f71faaa439e8abc3cfba572c53}
KING_LOCAL=${KING_LOCAL:-$BASE}
TRAIN_DIR=${TRAIN_DIR:-/root/h121/train}
# Prefer /tmp staging — gocryptfs /root copytree hangs (WCHAN=request_wait_answer; p472).
FULL_FT=${FULL_FT:-/tmp/h121_full_ft_save}
if [[ ! -d "$FULL_FT" ]]; then
  FULL_FT=$TRAIN_DIR/full_ft
fi
MERGED=${MERGED:-/tmp/h121_merged}
MERGED_LINK=${MERGED_LINK:-/root/h121/merged}
SIM_N80=/root/affine_data/h121_sim_result.json
PROG=/root/affine_data/h121_sim_progress.json
LOG=/root/logs/h121_pipeline.nohup
# remove_at≈2026-08-09T16:10Z (TTL12h from ~04:10Z) → soft=TTL−1h, deadman=TTL−30m
SOFT_DEADLINE_UTC=${SOFT_DEADLINE_UTC:-2026-08-09T15:10:00Z}
DEADMAN_UTC=${DEADMAN_UTC:-2026-08-09T15:40:00Z}

log() { echo "[h121-pipe] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

_train_alive() {
  if [[ -f /root/logs/h121_train.pid ]]; then
    local tpid
    tpid=$(cat /root/logs/h121_train.pid 2>/dev/null || true)
    if [[ -n "${tpid:-}" ]] && kill -0 "$tpid" 2>/dev/null; then
      return 0
    fi
  fi
  pgrep -f "python3 /root/mining_src/s4-h121-f26-full-ft/train_full.py --base" >/dev/null 2>&1
}

_abort_on_exit() {
  local rc=$?
  if [[ $rc -eq 0 ]]; then
    return 0
  fi
  if [[ -f /root/logs/h121_pipeline.done ]]; then
    return 0
  fi
  if [[ ! -f /root/logs/h121_pipeline.aborted ]]; then
    echo "aborted_err_rc=${rc} $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
      >/root/logs/h121_pipeline.aborted
    echo "[h121-pipe] $(date -u +%Y-%m-%dT%H:%M:%SZ) EXIT trap wrote aborted_err_rc=${rc}" \
      | tee -a "$LOG" >/dev/null 2>&1 || true
  fi
}
trap _abort_on_exit EXIT

mkdir -p /root/logs /root/affine_data /root/h121
rm -f /root/logs/h121_pipeline.aborted /root/logs/h121_pipeline.done \
  /root/logs/h121_merge.done /root/logs/h121_chall_serve.done \
  /root/logs/h121_sim_n80.done

log "waiting for $TRAIN_DIR/train.done (or full_ft + no train proc)"
_wait_i=0
while true; do
  if [[ -f "$TRAIN_DIR/train.done" ]]; then
    log "train.done present"
    break
  fi
  if [[ -f "$FULL_FT/config.json" ]] && ! _train_alive; then
    log "full_ft present and train proc gone - proceed"
    break
  fi
  now=$(date -u +%s)
  soft=$(date -u -d "$SOFT_DEADLINE_UTC" +%s)
  if (( now > soft - 3600 )); then
    log "WARN: <60m to soft and train not done; abort"
    echo "aborted_no_train $(date -u +%Y-%m-%dT%H:%M:%SZ)" > /root/logs/h121_pipeline.aborted
    exit 1
  fi
  _wait_i=$((_wait_i + 1))
  if (( _wait_i % 10 == 0 )); then
    log "still waiting for train.done (poll #$_wait_i)"
  fi
  sleep 30
done

log "waiting for train pid to exit and release GPUs"
for _ in $(seq 1 180); do
  if ! _train_alive; then
    log "train proc gone"
    break
  fi
  sleep 5
done
if _train_alive; then
  log "ERROR: train still alive >15m after train.done; abort"
  echo "aborted_train_stuck $(date -u +%Y-%m-%dT%H:%M:%SZ)" > /root/logs/h121_pipeline.aborted
  exit 1
fi
sleep 15
log "GPU settle done; finalize full-FT → $MERGED"

if [[ ! -d "$FULL_FT" ]]; then
  log "ERROR: no full_ft dir"
  echo "aborted_no_full_ft $(date -u +%Y-%m-%dT%H:%M:%SZ)" >/root/logs/h121_pipeline.aborted
  exit 1
fi

if [[ "${SKIP_MERGE:-0}" == "1" && -f "$MERGED/config.json" ]] \
  && ls "$MERGED"/model-*-of-*.safetensors >/dev/null 2>&1; then
  log "SKIP_MERGE=1 — reuse $MERGED"
else
  rm -rf "$MERGED"
  python3 /root/mining_src/s4-h121-f26-full-ft/finalize_full_ft.py \
    --base "$BASE" \
    --full-ft "$FULL_FT" \
    --out "$MERGED" \
    --king "$KING_LOCAL" \
    | tee -a "$LOG"
fi
mkdir -p "$(dirname "$MERGED_LINK")"
ln -sfn "$MERGED" "$MERGED_LINK"
log "merged link $MERGED_LINK → $MERGED"
cp -f "$MERGED/finalize_meta.json" /root/affine_data/h121_finalize_meta.json 2>/dev/null || true
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h121_merge.done

HF_MERGED_REPO=${HF_MERGED_REPO:-unconst/Affine-5czsc2fc98-h121-fullft}
if [[ -n "${HF_TOKEN:-}" ]]; then
  log "background HF push full-FT → $HF_MERGED_REPO"
  nohup python3 /root/mining_src/s4-h1-sft/push_merged.py \
    --merged "$MERGED" \
    --repo "$HF_MERGED_REPO" \
    --public \
    --commit-message "H121 Tok full-FT high-Λ2 salvage (TTL insurance; not a submission)" \
    --out-meta /root/affine_data/h121_merged_salvage.json \
    >>/root/logs/h121_push_merged.nohup 2>&1 &
  echo $! >/root/logs/h121_push_merged.pid
fi

# Wait teacher.done (downloaded during train).
log "wait teacher.done"
for _ in $(seq 1 240); do
  [[ -f /root/logs/teacher.done ]] && break
  sleep 30
done
test -f /root/logs/teacher.done
test -f /root/logs/tok331102.done

unset CUDA_VISIBLE_DEVICES
log "serve teacher + Tok king + full-FT chall"
TEACHER_REPO=${TEACHER_REPO:-zai-org/GLM-4.5-Air-FP8} \
  TEACHER_REV=${TEACHER_REV:-} \
  KING_REPO="$KING_REPO" \
  KING_REV="$KING_REV" \
  CHALL_REPO="$MERGED" \
  CHALL_REV=local \
  bash /root/mining_src/s3-duel-sim/serve_three.sh | tee -a "$LOG"

# Arm bare-tcache preempt after chall serve.
if [[ -x /root/mining_src/s4-h121-f26-full-ft/watch_preempt_bare_tcache_pass264.sh ]]; then
  nohup bash /root/mining_src/s4-h121-f26-full-ft/watch_preempt_bare_tcache_pass264.sh \
    >/root/logs/h121_preempt.nohup 2>&1 &
  echo $! >/root/logs/h121_preempt.pid
fi

date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h121_chall_serve.done
log "CHALL_SERVE_DONE — n80 owned by watch_n80_retry / retry_h121_n80_d203first"
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h121_pipeline.done
log "PIPELINE_DONE (n80 via watcher)"
