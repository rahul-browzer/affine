#!/usr/bin/env bash
# mine-h5c-1 bootstrap: pinned eval stack + kevin download → H5c train.
# Also downloads TalentPigs + teacher in background for later n80 sim.
# Secrets from /root/mine.env only (never argv).
set -euo pipefail

LOG=/root/logs/bootstrap_h5c.log
mkdir -p /root/logs /root/hf /root/affine_data /root/mining_src /root/h5c
exec > >(tee -a "$LOG") 2>&1

echo "[bootstrap-h5c] $(date -u +%Y-%m-%dT%H:%M:%SZ) start host=$(hostname)"

if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi
export HF_HOME=${HF_HOME:-/root/hf}
export HF_HUB_ENABLE_HF_TRANSFER=${HF_HUB_ENABLE_HF_TRANSFER:-1}
export PATH="$HOME/.local/bin:$PATH"

if [[ -z "${HF_TOKEN:-}" ]]; then
  echo "[bootstrap-h5c] FATAL: HF_TOKEN missing in /root/mine.env"
  exit 1
fi

nvidia-smi -L || true
test -s /root/h5c/teacher_refs_shortz.jsonl
test -f /root/mining_src/s4-h1v2-sft/train_lora.py
test -f /root/mining_src/s4-h1-sft/merge_lora.py
test -x /root/mining_src/s4-h5c-expand-refs/start_h5c.sh

if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

if [[ ! -d /root/venv ]]; then
  uv venv /root/venv --python 3.12
fi
# shellcheck disable=SC1091
source /root/venv/bin/activate

uv pip install \
  "torch==2.11.0" \
  "transformers==5.14.1" \
  "vllm==0.22.1" \
  "peft" \
  "accelerate" \
  "huggingface_hub[hf_transfer]" \
  "hf_transfer" \
  "numpy" \
  "scipy" \
  2>&1 | tee /root/logs/pip_h5c.log | tail -40

python - <<'PY'
import torch, transformers, vllm, peft, accelerate
print("[bootstrap-h5c] VERSIONS",
      "torch", torch.__version__,
      "transformers", transformers.__version__,
      "vllm", vllm.__version__,
      "peft", peft.__version__,
      "accelerate", accelerate.__version__)
assert vllm.__version__.startswith("0.22.1"), vllm.__version__
assert transformers.__version__.startswith("5.14"), transformers.__version__
PY

# Kevin first (train init). Then bg TalentPigs + teacher for sim.
python - <<'PY'
import os
from huggingface_hub import snapshot_download

token = os.environ["HF_TOKEN"]
print("[bootstrap-h5c] DOWNLOAD kevin start", flush=True)
path = snapshot_download(
    "kevin954/Affine-5dfqbbh8ev-sft",
    revision="6a5815fad8f4e34c983b1933c1fae5762fe25220",
    token=token,
)
print(f"[bootstrap-h5c] DOWNLOAD kevin done -> {path}", flush=True)
open("/root/logs/kevin.done", "w").write(path + "\n")
PY

echo "[bootstrap-h5c] $(date -u +%Y-%m-%dT%H:%M:%SZ) launching H5c train"
bash /root/mining_src/s4-h5c-expand-refs/start_h5c.sh
touch /root/logs/h5c_train_launched.stamp

# Background downloads for later n80 (do not block train).
nohup python - <<'PY' >/root/logs/h5c_extra_dl.nohup 2>&1 &
import os
from huggingface_hub import snapshot_download

token = os.environ["HF_TOKEN"]
jobs = [
    ("TalentPigs/affine-5ekxlcg3fx-abc",
     "dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4"),
    ("zai-org/GLM-4.5-Air-FP8", None),
]
for repo, rev in jobs:
    print(f"[extra-dl] start {repo} rev={rev}", flush=True)
    path = snapshot_download(repo, revision=rev, token=token)
    print(f"[extra-dl] done {repo} -> {path}", flush=True)
open("/root/logs/h5c_extra_dl.done", "w").write("ok\n")
print("[extra-dl] ALL_OK", flush=True)
PY
echo $! > /root/logs/h5c_extra_dl.pid

echo "[bootstrap-h5c] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE — train launched; extra dl pid=$(cat /root/logs/h5c_extra_dl.pid)"
touch /root/logs/bootstrap_h5c.done
