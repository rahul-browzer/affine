#!/usr/bin/env bash
# H110/F15 pass432: preempt gocryptfs /root GPU save hang (49.7GiB .tmp mid-write).
# Same recipe as H109 p429c: contiguous-clone state_dict → 5GB shards on /tmp; symlink.
set -euo pipefail

EXP=/root/mining_src/s4-h110-f15-everest12
LOG=/root/logs/h110_merge_recover_pass432.nohup
PIDF=/root/logs/h110_merge_recover_pass432.pid
MERGED_TMP=/tmp/h110_merged
MERGED_LINK=/root/h110/merged
ADAPTER=/root/h110/train/adapter
BASE=/root/hf/hub/models--everest12--affine-5EkhZHopy9CAoUhKmVTDsyGQi7Voo9gURYPnNDiMZX1pQZxp/snapshots/a5ac5311d32f5d96d604c14294046e27130e1b5c
MERGE_PY=/tmp/merge_lora_contig432.py

log() { echo "[h110-merge432] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

mkdir -p /root/logs /root/affine_data
: >"$LOG"
echo $$ >"$PIDF"

# Kill leftover merge/post_train by cmdline match (not SSH argv)
while read -r pid cmd; do
  case "$cmd" in
    *merge_lora*h110*|*merge_lora_sharded*|*merge_lora_contig*|*post_train_pipeline.sh*)
      kill "$pid" 2>/dev/null || true
      sleep 1
      kill -9 "$pid" 2>/dev/null || true
      log "killed $pid"
      ;;
  esac
done < <(ps -eo pid=,cmd=)
rm -f /root/logs/h110_pipeline.aborted
# Drop partial gocryptfs save junk
rm -rf "$MERGED_LINK" /root/h110/merged/.tmp* 2>/dev/null || true
sleep 2

if [[ ! -f "$ADAPTER/adapter_config.json" ]]; then
  log "ERROR: no adapter at $ADAPTER"
  exit 1
fi

rm -rf "$MERGED_TMP"
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

# Patch: after merge_and_unload, contiguous-clone state_dict before save
cp -f /root/mining_src/s4-h1-sft/merge_lora.py "$MERGE_PY"
python3 - "$MERGE_PY" <<'PY'
import pathlib, sys
p = pathlib.Path(sys.argv[1])
t = p.read_text()
old = """    print("[merge] merge_and_unload", flush=True)
    model = model.merge_and_unload()
    print(f"[merge] save {args.out}", flush=True)
    model.save_pretrained(str(args.out), safe_serialization=True)"""
new = """    print("[merge] merge_and_unload", flush=True)
    model = model.merge_and_unload()
    print("[merge] contiguous-clone state_dict (EFAULT/gocryptfs workaround)", flush=True)
    sd = {k: v.detach().to("cpu").contiguous().clone() for k, v in model.state_dict().items()}
    print(f"[merge] save {args.out} shards<=5GB n_tensors={len(sd)}", flush=True)
    model.save_pretrained(
        str(args.out),
        state_dict=sd,
        safe_serialization=True,
        max_shard_size="5GB",
    )
    del sd"""
if old not in t:
    raise SystemExit("merge/save block not found for patch")
p.write_text(t.replace(old, new, 1))
print("[patch] contiguous+5GB applied", flush=True)
PY

log "CPU merge → $MERGED_TMP contiguous-clone + 5GB shards (preempt /root gocryptfs hang)"
python "$MERGE_PY" \
  --base "$BASE" \
  --adapter "$ADAPTER" \
  --out "$MERGED_TMP" \
  --device-map cpu \
  2>&1 | tee -a "$LOG"
log "CPU merge finished"

if [[ ! -f "$MERGED_TMP/config.json" ]] \
  || ! ls "$MERGED_TMP"/model-*-of-*.safetensors >/dev/null 2>&1; then
  log "ERROR: merge incomplete at $MERGED_TMP"
  exit 1
fi

ln -sfn "$MERGED_TMP" "$MERGED_LINK"
log "symlink $MERGED_LINK -> $MERGED_TMP"

date -u +%Y-%m-%dT%H:%M:%SZ >/root/logs/h110_merge.done
cp -f "$MERGED_TMP/merge_meta.json" /root/affine_data/h110_merge_meta.json 2>/dev/null || true
nshard=$(ls "$MERGED_TMP"/model-*-of-*.safetensors | wc -l)
log "merge.done shards=$nshard → resume post_train SKIP_MERGE=1"

if [[ -x "$EXP/watch_preempt_bare_tcache_pass264.sh" ]]; then
  nohup bash "$EXP/watch_preempt_bare_tcache_pass264.sh" \
    >>/root/logs/h110_preempt_bare_pass264.log 2>&1 &
  echo $! >/root/logs/h110_preempt_bare_pass264.pid
  log "rearmed preempt264 pid=$(cat /root/logs/h110_preempt_bare_pass264.pid)"
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
log "DONE recover432"
