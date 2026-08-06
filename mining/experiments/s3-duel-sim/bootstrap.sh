#!/usr/bin/env bash
# Stage 3 pod bootstrap: env + pinned vLLM + HF downloads.
# Run on mine-sim-1 only. Secrets come from /root/mine.env (0600), never argv.
set -euo pipefail

LOG=/root/logs/bootstrap.log
mkdir -p /root/logs /root/hf /root/affine_data /root/mining_src
exec > >(tee -a "$LOG") 2>&1

echo "[bootstrap] $(date -u +%Y-%m-%dT%H:%M:%SZ) start host=$(hostname)"

if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi
export HF_HOME=${HF_HOME:-/root/hf}
export HF_HUB_ENABLE_HF_TRANSFER=${HF_HUB_ENABLE_HF_TRANSFER:-1}
export PATH="$HOME/.local/bin:$PATH"

if [[ -z "${HF_TOKEN:-}" ]]; then
  echo "[bootstrap] FATAL: HF_TOKEN missing in /root/mine.env"
  exit 1
fi

nvidia-smi -L || true

if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

if [[ ! -d /root/venv ]]; then
  uv venv /root/venv --python 3.12
fi
# shellcheck disable=SC1091
source /root/venv/bin/activate

# Match live eval_machine versions from api/v1/snapshot.
uv pip install \
  "torch==2.11.0" \
  "transformers==5.14.1" \
  "vllm==0.22.1" \
  "huggingface_hub[hf_transfer]" \
  "hf_transfer" \
  "numpy" \
  "scipy" \
  2>&1 | tee /root/logs/pip_vllm.log | tail -30

python - <<'PY'
import torch, transformers, vllm
print("[bootstrap] VERSIONS",
      "torch", torch.__version__,
      "transformers", transformers.__version__,
      "vllm", vllm.__version__)
assert vllm.__version__.startswith("0.22.1"), vllm.__version__
assert transformers.__version__.startswith("5.14"), transformers.__version__
PY

# Download models into HF_HOME (pod-local only).
python - <<'PY'
import os
from huggingface_hub import snapshot_download

token = os.environ["HF_TOKEN"]
jobs = [
    ("zai-org/GLM-4.5-Air-FP8", None),
    ("kevin954/Affine-5dfqbbh8ev-sft",
     "6a5815fad8f4e34c983b1933c1fae5762fe25220"),
    ("dendriteholdings/albedo-qwen3.6-35b-king-genesis", None),
]
for repo, rev in jobs:
    print(f"[bootstrap] DOWNLOAD start {repo} rev={rev}", flush=True)
    path = snapshot_download(repo, revision=rev, token=token)
    print(f"[bootstrap] DOWNLOAD done  {repo} -> {path}", flush=True)
print("[bootstrap] ALL_DOWNLOADS_OK")
PY

echo "[bootstrap] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE — ready for serve+score"
touch /root/logs/bootstrap.done
