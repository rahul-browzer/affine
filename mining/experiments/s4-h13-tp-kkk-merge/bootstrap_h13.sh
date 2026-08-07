#!/usr/bin/env bash
# mine-h13-1 bootstrap: pinned eval stack + TalentPigs/kkk-af/teacher → merge α0.75.
# Secrets from /root/mine.env only (never argv).
set -euo pipefail

LOG=/root/logs/bootstrap_h13.log
mkdir -p /root/logs /root/hf /root/affine_data /root/mining_src /root/merges
exec > >(tee -a "$LOG") 2>&1

echo "[bootstrap-h13] $(date -u +%Y-%m-%dT%H:%M:%SZ) start host=$(hostname)"

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
  echo "[bootstrap-h13] FATAL: HF_TOKEN missing in /root/mine.env"
  exit 1
fi

nvidia-smi -L || true
test -f /root/mining_src/s4-h2-merge/merge_linear.py
test -f /root/mining_src/s4-h2-merge/run_sim_duel.py
test -f /root/mining_src/s4-h2-merge/write_merge_decision.py
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
  2>&1 | tee /root/logs/pip_h13.log | tail -40

python - <<'PY'
import torch, transformers, vllm
print("[bootstrap-h13] VERSIONS",
      "torch", torch.__version__,
      "transformers", transformers.__version__,
      "vllm", vllm.__version__)
assert vllm.__version__.startswith("0.22.1"), vllm.__version__
assert transformers.__version__.startswith("5.14"), transformers.__version__
PY

# LESSON: dual-side n80 ReadTimeout at default 180s×3 — patch before any sim.
python3 - <<'PY'
from pathlib import Path
p = Path("/root/mining_src/affine_pkg/evalsrv/vllm_client.py")
txt = p.read_text()
orig = txt
txt = txt.replace("httpx.Timeout(180.0, connect=10.0)", "httpx.Timeout(480.0, connect=10.0)")
txt = txt.replace("httpx.Timeout(360.0, connect=10.0)", "httpx.Timeout(480.0, connect=10.0)")
txt = txt.replace("for attempt in range(3):", "for attempt in range(5):")
txt = txt.replace("if attempt == 2:", "if attempt == 4:")
if txt == orig:
    print("[bootstrap-h13] vllm_client already patched or pattern miss", flush=True)
else:
    p.write_text(txt)
    print("[bootstrap-h13] patched vllm_client timeout=480 retries=5", flush=True)
PY

B_REPO=bluecolor777/kkk-af
B_REV=7426296b0a2d74aaf0e2c282410677bfccd0dac6

python - <<PY
import os
from huggingface_hub import snapshot_download

token = os.environ["HF_TOKEN"]
jobs = [
    ("TalentPigs/affine-5ekxlcg3fx-abc",
     "dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4", "talentpigs"),
    ("$B_REPO", "$B_REV", "kkk"),
    ("zai-org/GLM-4.5-Air-FP8", None, "teacher"),
]
for repo, rev, label in jobs:
    done = f"/root/logs/{label}.done"
    if os.path.isfile(done):
        print(f"[bootstrap-h13] SKIP {label} (have {done})", flush=True)
        continue
    print(f"[bootstrap-h13] DOWNLOAD start {label} {repo} rev={rev}", flush=True)
    path = snapshot_download(repo, revision=rev, token=token)
    print(f"[bootstrap-h13] DOWNLOAD done {label} -> {path}", flush=True)
    open(done, "w").write(path + "\n")
print("[bootstrap-h13] ALL_DOWNLOADS_OK", flush=True)
open("/root/logs/ALL_DOWNLOADS_OK", "w").write("ok\n")
PY

export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
bash /root/mining_src/s3-duel-sim/sync_corpus.sh

ALPHA=0.75
OUT=/root/merges/h13-tp75
rm -rf "$OUT"
python /root/mining_src/s4-h2-merge/merge_linear.py \
  --a-repo TalentPigs/affine-5ekxlcg3fx-abc \
  --a-rev dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4 \
  --b-repo "$B_REPO" \
  --b-rev "$B_REV" \
  --alpha "$ALPHA" \
  --out "$OUT" \
  --hf-home "$HF_HOME" \
  2>&1 | tee /root/logs/h13_merge.log

date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h13_merge.done
echo "[bootstrap-h13] MERGE_DONE alpha=$ALPHA out=$OUT b=$B_REPO@$B_REV"

export TEACHER_REPO=zai-org/GLM-4.5-Air-FP8
export TEACHER_REV=
export KING_REPO=TalentPigs/affine-5ekxlcg3fx-abc
export KING_REV=dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4
export CHALL_REPO=/root/merges/h13-tp75
export CHALL_REV=
bash /root/mining_src/s3-duel-sim/serve_three.sh

touch /root/logs/bootstrap_h13.done
echo "[bootstrap-h13] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE — engines launching; next: wait_ready + n80"
