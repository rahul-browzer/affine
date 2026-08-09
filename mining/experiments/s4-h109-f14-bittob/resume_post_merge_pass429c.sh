#!/usr/bin/env bash
# After finish_visual_pass429c.py succeeds: symlink + SKIP_MERGE post_train.
set -euo pipefail
EXP=/root/mining_src/s4-h109-f14-bittob
LOG=/root/logs/h109_resume_post_merge_pass429c.nohup
MERGED_TMP=/tmp/h109_merged
MERGED_LINK=/root/h109/merged

log() { echo "[h109-resume429c] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }
mkdir -p /root/logs /root/affine_data
: >"$LOG"

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi

log "finish visual restore"
python /root/mining_src/s4-h109-f14-bittob/finish_visual_pass429c.py \
  "$MERGED_TMP" 2>&1 | tee -a "$LOG"

if [[ ! -f "$MERGED_TMP/model-visual-restored.safetensors" ]]; then
  log "ERROR: visual restore missing"
  exit 1
fi

rm -rf "$MERGED_LINK"
ln -sfn "$MERGED_TMP" "$MERGED_LINK"
log "symlink $MERGED_LINK -> $MERGED_TMP"

date -u +%Y-%m-%dT%H:%M:%SZ >/root/logs/h109_merge.done
cp -f "$MERGED_TMP/merge_meta.json" /root/affine_data/h109_merge_meta.json
nshard=$(ls "$MERGED_TMP"/model-*-of-*.safetensors | wc -l)
log "merge.done shards=$nshard visual_ok → post_train SKIP_MERGE=1"

if [[ -x "$EXP/watch_preempt_bare_tcache_pass264.sh" ]]; then
  nohup bash "$EXP/watch_preempt_bare_tcache_pass264.sh" \
    >>/root/logs/h109_preempt_bare_pass264.log 2>&1 &
  echo $! >/root/logs/h109_preempt_bare_pass264.pid
  log "rearmed preempt264 pid=$(cat /root/logs/h109_preempt_bare_pass264.pid)"
fi

export SKIP_MERGE=1
export MERGE_DEVICE_MAP=cpu
export CUDA_VISIBLE_DEVICES=6,7
export SOFT_DEADLINE_UTC=2026-08-09T11:00:00Z
export DEADMAN_UTC=2026-08-09T11:30:00Z
nohup bash "$EXP/post_train_pipeline.sh" \
  >>/root/logs/h109_pipeline.nohup 2>&1 &
echo $! >/root/logs/h109_post_train.pid
log "post_train resumed pid=$(cat /root/logs/h109_post_train.pid)"
log "DONE"
