#!/usr/bin/env bash
# H110/F15 pass433: finish visual (contig-clone) after merge432 EFAULT, then
# symlink /tmp → /root/h110/merged and resume post_train SKIP_MERGE=1.
set -euo pipefail
EXP=/root/mining_src/s4-h110-f15-everest12
LOG=/root/logs/h110_resume_post_merge_pass433.nohup
MERGED_TMP=/tmp/h110_merged
MERGED_LINK=/root/h110/merged
BASE=/root/hf/hub/models--everest12--affine-5EkhZHopy9CAoUhKmVTDsyGQi7Voo9gURYPnNDiMZX1pQZxp/snapshots/a5ac5311d32f5d96d604c14294046e27130e1b5c

log() { echo "[h110-resume433] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }
mkdir -p /root/logs /root/affine_data
: >"$LOG"

# Kill stale post_train if any (not SSH argv)
while read -r pid cmd; do
  case "$cmd" in
    *s4-h110-f15-everest12/post_train_pipeline.sh*)
      kill "$pid" 2>/dev/null || true
      sleep 1
      kill -9 "$pid" 2>/dev/null || true
      log "killed stale post_train $pid"
      ;;
  esac
done < <(ps -eo pid=,cmd=)
rm -f /root/logs/h110_pipeline.aborted

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi

if [[ ! -f "$MERGED_TMP/config.json" ]] \
  || ! ls "$MERGED_TMP"/model-*-of-*.safetensors >/dev/null 2>&1; then
  log "ERROR: language merge incomplete at $MERGED_TMP"
  exit 1
fi

log "finish visual restore (contig-clone; merge432 EFAULT)"
python "$EXP/finish_visual_pass433.py" "$MERGED_TMP" "$BASE" 2>&1 | tee -a "$LOG"

if [[ ! -f "$MERGED_TMP/model-visual-restored.safetensors" ]]; then
  log "ERROR: visual restore missing"
  exit 1
fi

rm -rf "$MERGED_LINK"
ln -sfn "$MERGED_TMP" "$MERGED_LINK"
log "symlink $MERGED_LINK -> $MERGED_TMP"

date -u +%Y-%m-%dT%H:%M:%SZ >/root/logs/h110_merge.done
cp -f "$MERGED_TMP/merge_meta.json" /root/affine_data/h110_merge_meta.json
nshard=$(ls "$MERGED_TMP"/model-*-of-*.safetensors | wc -l)
nvis=$(python3 -c "import json; print(sum(1 for k in json.load(open('$MERGED_TMP/model.safetensors.index.json'))['weight_map'] if 'visual' in k))")
log "merge.done shards=$nshard visual_keys=$nvis → post_train SKIP_MERGE=1"

if [[ -x "$EXP/watch_preempt_bare_tcache_pass264.sh" ]]; then
  # avoid duplicate preempt watchers
  if ! ps -eo cmd= | grep -q '[w]atch_preempt_bare_tcache_pass264.sh'; then
    nohup bash "$EXP/watch_preempt_bare_tcache_pass264.sh" \
      >>/root/logs/h110_preempt_bare_pass264.log 2>&1 &
    echo $! >/root/logs/h110_preempt_bare_pass264.pid
    log "rearmed preempt264 pid=$(cat /root/logs/h110_preempt_bare_pass264.pid)"
  else
    log "preempt264 already armed — leave"
  fi
fi

export SKIP_MERGE=1
export MERGE_DEVICE_MAP=cpu
export CUDA_VISIBLE_DEVICES=6,7
export SOFT_DEADLINE_UTC=2026-08-09T11:37:00Z
export DEADMAN_UTC=2026-08-09T12:07:00Z
nohup bash "$EXP/post_train_pipeline.sh" \
  >>/root/logs/h110_pipeline.nohup 2>&1 &
echo $! >/root/logs/h110_post_train.pid
log "post_train resumed pid=$(cat /root/logs/h110_post_train.pid) SKIP_MERGE=1"
log "DONE"
