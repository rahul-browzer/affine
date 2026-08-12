#!/usr/bin/env bash
# On-pod: DL sbs-v2 → Tok×sbs α-merge → Reason-GRPO on GPUs 6,7 → arm post_train.
# Assumes teacher:8000 + king:8001 already healthy; skip bootstrap/prewarm.
set -euo pipefail
exec > >(tee -a /root/logs/r10_lean_warm.log) 2>&1

set -a
# shellcheck disable=SC1091
source /root/mine.env
set +a
# shellcheck disable=SC1091
source /root/venv/bin/activate
export HF_HOME=/root/hf
export HF_TOKEN
export PATH="$HOME/.local/bin:$PATH"
export PYTHONPATH=/root/mining_src/affine_pkg:${PYTHONPATH:-}

echo "[r10-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"

TOK=$(readlink -f /root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53)
test -d "$TOK"
echo "$TOK" >/root/logs/tok_init.done

python - <<'PY'
import os
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
sbs_repo = "ammazon/Affine-5dvqtektxx-sbs-v2"
sbs_rev = "6f1b8e682aea94a00d8387f4ab9bdef6da153944"
print("[r10-lean] DOWNLOAD sbs-v2", sbs_repo, sbs_rev, flush=True)
sbs = snapshot_download(sbs_repo, revision=sbs_rev, token=token)
print("[r10-lean] DOWNLOAD sbs-v2 done", sbs, flush=True)
open("/root/logs/sbs_v2.done", "w").write(sbs + "\n")
PY
SBS=$(cat /root/logs/sbs_v2.done)
MERGE_OUT=/root/r10/merge_base
rm -rf "$MERGE_OUT"
echo "[r10-lean] α-merge Tok0.5 × sbs 0.5 → $MERGE_OUT"
python3 /root/mining_src/r10-merge-rl/merge_alpha.py \
  --parent "${TOK}:0.5" --parent "${SBS}:0.5" \
  --out "$MERGE_OUT" --device cpu \
  2>&1 | tee /root/logs/r10_merge_alpha.log
test -f "$MERGE_OUT/model.safetensors.index.json"
echo "$MERGE_OUT" >/root/r10/merge_base.path
echo "[r10-lean] MERGE_OK"

nvidia-smi --query-gpu=index,memory.used --format=csv,noheader | tee /root/logs/r10_gpu_before_train.txt
BASE="$MERGE_OUT" CUDA_VISIBLE_DEVICES=6,7 bash /root/mining_src/r10-merge-rl/start_r10.sh
touch /root/logs/r10_train_launched.stamp

BASE="$MERGE_OUT" TRAIN_DIR=/root/r10/train MERGED=/root/r10/merged \
  KING_REPO=tolegend/Affine-5fqbxvz29b-ckp333 \
  KING_REV=24c137e8a978aea1e2b4abeec594fb6ca943f03c \
  nohup bash /root/mining_src/r10-merge-rl/post_train_pipeline.sh \
  >/root/logs/r10_post_train.nohup 2>&1 &
echo $! >/root/logs/r10_post_train.pid

echo "[r10-lean] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE train=$(cat /root/logs/r10_train.pid) post=$(cat /root/logs/r10_post_train.pid)"
