#!/usr/bin/env bash
# mine-h10-1 bootstrap: pinned eval stack + TalentPigs/kevin/teacher → merge α0.75.
# Secrets from /root/mine.env only (never argv).
set -euo pipefail

LOG=/root/logs/bootstrap_h10.log
mkdir -p /root/logs /root/hf /root/affine_data /root/mining_src /root/merges
exec > >(tee -a "$LOG") 2>&1

echo "[bootstrap-h10] $(date -u +%Y-%m-%dT%H:%M:%SZ) start host=$(hostname)"

if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export HF_HOME=${HF_HOME:-/root/hf}
export HF_HUB_ENABLE_HF_TRANSFER=${HF_HUB_ENABLE_HF_TRANSFER:-1}
export HF_XET_HIGH_PERFORMANCE=${HF_XET_HIGH_PERFORMANCE:-1}
export PATH="$HOME/.local/bin:$PATH"
export HF_TOKEN

if [[ -z "${HF_TOKEN:-}" ]]; then
  echo "[bootstrap-h10] FATAL: HF_TOKEN missing in /root/mine.env"
  exit 1
fi

nvidia-smi -L || true
test -f /root/mining_src/s4-h2-merge/merge_linear.py
test -f /root/mining_src/s4-h2-merge/run_sim_duel.py
test -x /root/mining_src/s3-duel-sim/serve_three.sh
test -x /root/mining_src/s3-duel-sim/sync_corpus.sh

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
  "huggingface_hub[hf_transfer]" \
  "hf_transfer" \
  "safetensors" \
  "numpy" \
  "scipy" \
  2>&1 | tee /root/logs/pip_h10.log | tail -40

python - <<'PY'
import torch, transformers, vllm
print("[bootstrap-h10] VERSIONS",
      "torch", torch.__version__,
      "transformers", transformers.__version__,
      "vllm", vllm.__version__)
assert vllm.__version__.startswith("0.22.1"), vllm.__version__
assert transformers.__version__.startswith("5.14"), transformers.__version__
PY

python - <<'PY'
import os
from huggingface_hub import snapshot_download

token = os.environ["HF_TOKEN"]
jobs = [
    ("TalentPigs/affine-5ekxlcg3fx-abc",
     "dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4", "talentpigs"),
    ("kevin954/Affine-5dfqbbh8ev-sft",
     "6a5815fad8f4e34c983b1933c1fae5762fe25220", "kevin"),
    ("zai-org/GLM-4.5-Air-FP8", None, "teacher"),
]
for repo, rev, label in jobs:
    print(f"[bootstrap-h10] DOWNLOAD start {label} {repo} rev={rev}", flush=True)
    path = snapshot_download(repo, revision=rev, token=token)
    print(f"[bootstrap-h10] DOWNLOAD done {label} -> {path}", flush=True)
    open(f"/root/logs/{label}.done", "w").write(path + "\n")
print("[bootstrap-h10] ALL_DOWNLOADS_OK", flush=True)
PY

export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
bash /root/mining_src/s3-duel-sim/sync_corpus.sh

ALPHA=0.75
OUT=/root/merges/h10-tp75
rm -rf "$OUT"
python /root/mining_src/s4-h2-merge/merge_linear.py \
  --a-repo TalentPigs/affine-5ekxlcg3fx-abc \
  --a-rev dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4 \
  --b-repo kevin954/Affine-5dfqbbh8ev-sft \
  --b-rev 6a5815fad8f4e34c983b1933c1fae5762fe25220 \
  --alpha "$ALPHA" \
  --out "$OUT" \
  --hf-home "$HF_HOME" \
  2>&1 | tee /root/logs/h10_merge.log

date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h10_merge.done
echo "[bootstrap-h10] MERGE_DONE alpha=$ALPHA out=$OUT"

export TEACHER_REPO=zai-org/GLM-4.5-Air-FP8
export TEACHER_REV=
export KING_REPO=TalentPigs/affine-5ekxlcg3fx-abc
export KING_REV=dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4
export CHALL_REPO=/root/merges/h10-tp75
export CHALL_REV=
bash /root/mining_src/s3-duel-sim/serve_three.sh

touch /root/logs/bootstrap_h10.done
echo "[bootstrap-h10] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE — engines launching; next: wait_ready + n80"
