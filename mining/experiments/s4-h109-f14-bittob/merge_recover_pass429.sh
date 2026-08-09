#!/usr/bin/env bash
# H109/F14 pass429: CPU merge to /root (gocryptfs) hung same as GPU —
# .tmpU0UAYq stuck 49739502312 B, write_bytes=4096, WCHAN=request_wait_answer,
# wchar growing. Save to /tmp (overlay) then symlink into /root/h109/merged.
set -euo pipefail

EXP=/root/mining_src/s4-h109-f14-bittob
LOG=/root/logs/h109_merge_recover_pass429.nohup
PIDF=/root/logs/h109_merge_recover_pass429.pid
MERGED_TMP=/tmp/h109_merged
MERGED_LINK=/root/h109/merged
ADAPTER=/root/h109/train/adapter
BASE=/root/hf/hub/models--Bittob11040--Affine_5DSW4cTwQt2U8rck6mFN1nNqoj37j1waqwszQDuz2zh9zC7z/snapshots/0c04fe92ce952ffb13af69f3218d5e13cb571df5

log() { echo "[h109-merge429] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

mkdir -p /root/logs /root/affine_data
: >"$LOG"
echo $$ >"$PIDF"

# Kill hung recover393 + merge + any post_train
for pat in \
  '[b]ash .*merge_recover_pass393\.sh' \
  '[p]ython .*merge_lora.py --base .*h109' \
  '[b]ash .*s4-h109-f14-bittob/post_train_pipeline\.sh'
do
  while read -r pid; do
    [[ -n "$pid" ]] || continue
    kill "$pid" 2>/dev/null || true
    sleep 1
    kill -9 "$pid" 2>/dev/null || true
    log "killed $pid ($pat)"
  done < <(ps -eo pid,cmd | awk -v p="$pat" '$0 ~ p {print $1}')
done
# orphan tee
pkill -9 -f 'tee -a /root/logs/h109_merge_recover_pass393' 2>/dev/null || true
rm -f /root/logs/h109_pipeline.aborted
sleep 3

if [[ ! -f "$ADAPTER/adapter_config.json" ]]; then
  log "ERROR: no adapter at $ADAPTER"
  exit 1
fi

rm -rf "$MERGED_TMP" "$MERGED_LINK"
mkdir -p "$MERGED_TMP"

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export HF_HOME=${HF_HOME:-/root/hf}
export PYTHONPATH=/root/mining_src/affine_pkg:${PYTHONPATH:-}
unset CUDA_VISIBLE_DEVICES || true

# pass429b: first /tmp save died SafetensorError EFAULT on 47G shard serialize.
# Copy merge_lora and force max_shard_size=5GB (F13 wrote 47G+19G OK on
# another host; this box faults the huge contiguous serialize).
MERGE_PY=/tmp/merge_lora_sharded429.py
cp -f /root/mining_src/s4-h1-sft/merge_lora.py "$MERGE_PY"
python3 - "$MERGE_PY" <<'PY'
import pathlib, sys
p = pathlib.Path(sys.argv[1])
t = p.read_text()
old = "model.save_pretrained(str(args.out), safe_serialization=True)"
new = (
    "model.save_pretrained(str(args.out), safe_serialization=True, "
    'max_shard_size="5GB")'
)
if old not in t:
    raise SystemExit("save_pretrained line not found for patch")
p.write_text(t.replace(old, new, 1))
print("[patch] max_shard_size=5GB applied", flush=True)
PY

log "CPU merge → overlay $MERGED_TMP max_shard=5GB (avoid gocryptfs + EFAULT)"
python "$MERGE_PY" \
  --base "$BASE" \
  --adapter "$ADAPTER" \
  --out "$MERGED_TMP" \
  --device-map cpu \
  2>&1 | tee -a "$LOG"
log "CPU merge finished on overlay"

if [[ ! -f "$MERGED_TMP/config.json" ]] \
  || ! ls "$MERGED_TMP"/model-*-of-*.safetensors >/dev/null 2>&1; then
  log "ERROR: merge incomplete at $MERGED_TMP"
  exit 1
fi

# Point the path post_train/n80 expect at the overlay tree
ln -sfn "$MERGED_TMP" "$MERGED_LINK"
log "symlink $MERGED_LINK -> $MERGED_TMP"

date -u +%Y-%m-%dT%H:%M:%SZ >/root/logs/h109_merge.done
cp -f "$MERGED_TMP/merge_meta.json" /root/affine_data/h109_merge_meta.json 2>/dev/null || true
nshard=$(ls "$MERGED_TMP"/model-*-of-*.safetensors | wc -l)
log "merge.done shards=$nshard → resume post_train SKIP_MERGE=1"

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
log "post_train resumed pid=$(cat /root/logs/h109_post_train.pid) SKIP_MERGE=1"
log "DONE recover429"
