#!/usr/bin/env bash
# Watch for Trainer mid-checkpoints (save_steps=50) and push each to HF.
# Complements post_train_pipeline final-adapter salvage. TTL insurance.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

CKPT_ROOT=/root/h1/train/checkpoints
TRAIN_DONE=/root/h1/train/train.done
REPO=${H1_LORA_REPO:-unconst/Affine-5czsc2fc98-h1-lora}
SEEN=/root/h1/mid_ckpt_salvaged.txt
LOG_TAG=h1-mid-salvage

touch "$SEEN"
log() { echo "[$LOG_TAG] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

if [[ -z "${HF_TOKEN:-}" ]]; then
  log "FATAL: HF_TOKEN missing"
  exit 2
fi

log "watching $CKPT_ROOT for checkpoint-* (repo=$REPO)"
while true; do
  if [[ -d "$CKPT_ROOT" ]]; then
    for d in "$CKPT_ROOT"/checkpoint-*; do
      [[ -d "$d" ]] || continue
      name=$(basename "$d")
      if grep -qx "$name" "$SEEN"; then
        continue
      fi
      # Wait until adapter_config or config looks complete.
      if [[ ! -f "$d/adapter_config.json" && ! -f "$d/config.json" ]]; then
        continue
      fi
      # Trainer may still be writing; require a quiet 10s.
      sleep 10
      if [[ ! -d "$d" ]]; then
        continue
      fi
      log "salvaging $name → $REPO ($name/)"
      meta=/root/h1/mid_${name}_salvage.json
      if python3 /root/mining_src/s4-h1-sft/salvage_adapter.py \
        --adapter "$d" \
        --repo "$REPO" \
        --path-in-repo "$name" \
        --commit-message "H1 mid-ckpt salvage $name (TTL insurance)" \
        --out-meta "$meta"; then
        echo "$name" >>"$SEEN"
        log "OK $name meta=$meta"
      else
        log "WARN salvage failed for $name; will retry"
      fi
    done
  fi
  if [[ -f "$TRAIN_DONE" ]]; then
    log "train.done seen; exiting mid-salvage watcher"
    exit 0
  fi
  # Bail if train died without done.
  if [[ -f /root/logs/h1_train.pid ]]; then
    tpid=$(cat /root/logs/h1_train.pid)
    if ! kill -0 "$tpid" 2>/dev/null && [[ ! -f "$TRAIN_DONE" ]]; then
      log "ERROR: train pid $tpid dead; exiting"
      exit 1
    fi
  fi
  sleep 30
done
