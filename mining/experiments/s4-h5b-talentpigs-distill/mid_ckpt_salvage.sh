#!/usr/bin/env bash
# Watch for H5b Trainer mid-checkpoints and push each to HF (TTL insurance).
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

CKPT_ROOT=/root/h5b/train/checkpoints
TRAIN_DONE=/root/h5b/train/train.done
REPO=${H5B_LORA_REPO:-unconst/Affine-5czsc2fc98-h5b-lora}
SEEN=/root/h5b/mid_ckpt_salvaged.txt
LOG_TAG=h5b-mid-salvage

mkdir -p /root/h5b /root/logs /root/affine_data
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
      meta=/root/affine_data/h5b_mid_${name}_salvage.json
      if python3 /root/mining_src/s4-h1-sft/salvage_adapter.py \
        --adapter "$d" \
        --repo "$REPO" \
        --path-in-repo "$name" \
        --commit-message "H5b mid-ckpt salvage $name (TTL insurance)" \
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
