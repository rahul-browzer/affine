#!/usr/bin/env bash
# Watch for H1v2 Trainer mid-checkpoints (save_steps=50) and push each to HF.
# Complements post_train_pipeline final adapter+merged salvage. TTL insurance.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

CKPT_ROOT=/root/h1v2/train/checkpoints
TRAIN_DONE=/root/h1v2/train/train.done
REPO=${H1V2_LORA_REPO:-unconst/Affine-5czsc2fc98-h1v2-lora}
SEEN=/root/h1v2/mid_ckpt_salvaged.txt
LOG_TAG=h1v2-mid-salvage

mkdir -p /root/h1v2 /root/logs /root/affine_data
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
      if [[ ! -f "$d/adapter_config.json" && ! -f "$d/config.json" ]]; then
        continue
      fi
      sleep 10
      if [[ ! -d "$d" ]]; then
        continue
      fi
      log "salvaging $name → $REPO ($name/)"
      meta=/root/affine_data/h1v2_mid_${name}_salvage.json
      if python3 /root/mining_src/s4-h1-sft/salvage_adapter.py \
        --adapter "$d" \
        --repo "$REPO" \
        --path-in-repo "$name" \
        --commit-message "H1v2 mid-ckpt salvage $name (TTL insurance)" \
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
  if ! pgrep -f "s4-h1v2-sft/train_lora.py" >/dev/null 2>&1 \
    && [[ ! -f "$TRAIN_DONE" ]]; then
    log "ERROR: train proc gone without train.done; exiting"
    exit 1
  fi
  sleep 30
done
