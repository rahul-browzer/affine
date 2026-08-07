#!/usr/bin/env bash
# Watch H32 Trainer mid-checkpoints + final adapter; push to HF (TTL insurance).
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

TRAIN_DIR=/root/h32/train
CKPT_ROOT=$TRAIN_DIR/checkpoints
ADAPTER=$TRAIN_DIR/adapter
TRAIN_DONE=$TRAIN_DIR/train.done
REPO=${H5C_LORA_REPO:-unconst/Affine-5czsc2fc98-h32-lora}
SEEN=/root/h32/mid_ckpt_salvaged.txt
LOG_TAG=h32-mid-salvage
BASE_HUB=${H5C_BASE_HUB:-TalentPigs/affine-5ekxlcg3fx-abc}

mkdir -p /root/h32 /root/logs /root/affine_data
touch "$SEEN"
log() { echo "[$LOG_TAG] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

if [[ -z "${HF_TOKEN:-}" ]]; then
  log "FATAL: HF_TOKEN missing"
  exit 2
fi

salvage_one() {
  local src=$1
  local path_in_repo=$2
  local tag=$3
  if [[ ! -f "$src/adapter_config.json" && ! -f "$src/config.json" ]]; then
    return 1
  fi
  if grep -qx "$tag" "$SEEN"; then
    return 0
  fi
  sleep 10
  if [[ ! -d "$src" ]]; then
    return 1
  fi
  if [[ ! -f "$src/adapter_config.json" && ! -f "$src/config.json" ]]; then
    return 1
  fi
  log "salvaging $tag → $REPO ($path_in_repo)"
  local meta=/root/affine_data/h32_mid_${tag}_salvage.json
  if python3 /root/mining_src/s4-h1-sft/salvage_adapter.py \
    --adapter "$src" \
    --repo "$REPO" \
    --path-in-repo "$path_in_repo" \
    --base-hub "$BASE_HUB" \
    --commit-message "H32 mid-ckpt salvage $tag (TTL insurance)" \
    --out-meta "$meta"; then
    echo "$tag" >>"$SEEN"
    log "OK $tag meta=$meta"
    return 0
  fi
  log "WARN salvage failed for $tag; will retry"
  return 1
}

sweep_ckpts() {
  if [[ ! -d "$CKPT_ROOT" ]]; then
    return 0
  fi
  local d name
  for d in "$CKPT_ROOT"/checkpoint-*; do
    [[ -d "$d" ]] || continue
    name=$(basename "$d")
    salvage_one "$d" "$name" "$name" || true
  done
}

log "watching $CKPT_ROOT for checkpoint-* + final adapter (repo=$REPO)"
while true; do
  sweep_ckpts
  if [[ -f "$TRAIN_DONE" ]]; then
    log "train.done seen; final sweep"
    sweep_ckpts
    if [[ -f "$ADAPTER/adapter_config.json" ]]; then
      salvage_one "$ADAPTER" "adapter-final" "adapter-final" || true
    fi
    log "DONE"
    exit 0
  fi
  sleep 60
done
