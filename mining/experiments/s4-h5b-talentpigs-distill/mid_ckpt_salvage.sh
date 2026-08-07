#!/usr/bin/env bash
# Watch for H5b Trainer mid-checkpoints and push each to HF (TTL insurance).
# On train.done: one final sweep of checkpoint-* PLUS $TRAIN_DIR/adapter
# before exiting — otherwise a pipeline crash before the post-merge push
# loses the only TalentPigs-init candidate (deadman 12:00Z).
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

TRAIN_DIR=/root/h5b/train
CKPT_ROOT=$TRAIN_DIR/checkpoints
ADAPTER=$TRAIN_DIR/adapter
TRAIN_DONE=$TRAIN_DIR/train.done
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
  # Wait briefly for Trainer to finish writing the directory.
  sleep 10
  if [[ ! -d "$src" ]]; then
    return 1
  fi
  if [[ ! -f "$src/adapter_config.json" && ! -f "$src/config.json" ]]; then
    return 1
  fi
  log "salvaging $tag → $REPO ($path_in_repo)"
  local meta=/root/affine_data/h5b_mid_${tag}_salvage.json
  if python3 /root/mining_src/s4-h1-sft/salvage_adapter.py \
    --adapter "$src" \
    --repo "$REPO" \
    --path-in-repo "$path_in_repo" \
    --commit-message "H5b mid-ckpt salvage $tag (TTL insurance)" \
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
    log "train.done seen; final sweep + adapter salvage"
    # Adapter is written before train.done in train_lora.py, but give the
    # filesystem a beat and retry a few times if HF/transient fails.
    sweep_ckpts
    for _ in 1 2 3 4 5 6; do
      if [[ -f "$ADAPTER/adapter_config.json" ]]; then
        if salvage_one "$ADAPTER" "adapter" "adapter-final"; then
          break
        fi
      else
        log "adapter not yet visible; sleep"
      fi
      sleep 15
    done
    if ! grep -qx "adapter-final" "$SEEN"; then
      log "ERROR: train.done but adapter-final not salvaged"
      exit 1
    fi
    log "final salvage complete; exiting mid-salvage watcher"
    exit 0
  fi

  if ! pgrep -f "s4-h1v2-sft/train_lora.py" >/dev/null 2>&1 \
    && [[ ! -f "$TRAIN_DONE" ]]; then
    log "ERROR: train proc gone without train.done; last-chance ckpt sweep"
    sweep_ckpts
    exit 1
  fi
  sleep 30
done
