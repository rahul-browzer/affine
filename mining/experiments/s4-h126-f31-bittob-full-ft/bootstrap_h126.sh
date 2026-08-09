#!/usr/bin/env bash
# mine-f31-1: Bittob11040 init download → H126 full-FT; bg teacher+Tok DL; post-train after train.done.
set -euo pipefail

LOG=/root/logs/bootstrap_h126.log
mkdir -p /root/logs /root/hf /root/affine_data /root/mining_src /root/h126
exec > >(tee -a "$LOG") 2>&1

echo "[bootstrap-h126] $(date -u +%Y-%m-%dT%H:%M:%SZ) start host=$(hostname)"

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
  echo "[bootstrap-h126] FATAL: HF_TOKEN missing in /root/mine.env"
  exit 1
fi

nvidia-smi -L || true
NGPU=$(nvidia-smi -L | wc -l)
echo "[bootstrap-h126] GPU_COUNT=$NGPU"
test "$NGPU" -ge 8
test -s /root/h126/winner_za_high_l2.jsonl
test -f /root/mining_src/s4-h126-f31-bittob-full-ft/train_full.py
test -f /root/mining_src/s4-h126-f31-bittob-full-ft/finalize_full_ft.py
test -x /root/mining_src/s4-h126-f31-bittob-full-ft/start_h126.sh
test -x /root/mining_src/s4-h126-f31-bittob-full-ft/post_train_pipeline.sh

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
  "accelerate" \
  "huggingface_hub[hf_transfer]" \
  "hf_transfer" \
  "safetensors" \
  "numpy" \
  "scipy" \
  2>&1 | tee /root/logs/pip_h126.log | tail -40

python - <<'PY'
import torch, transformers, vllm, accelerate
print("[bootstrap-h126] VERSIONS",
      "torch", torch.__version__,
      "transformers", transformers.__version__,
      "vllm", vllm.__version__,
      "accelerate", accelerate.__version__)
assert vllm.__version__.startswith("0.22.1"), vllm.__version__
assert transformers.__version__.startswith("5.14"), transformers.__version__
PY

if [[ -x /root/mining_src/s3-duel-sim/patch_b300_sm103_flash_attn.sh ]]; then
  bash /root/mining_src/s3-duel-sim/patch_b300_sm103_flash_attn.sh || true
fi

python3 - <<'PY'
from pathlib import Path
p = Path("/root/mining_src/affine_pkg/evalsrv/vllm_client.py")
if not p.is_file():
    print("[bootstrap-h126] no vllm_client to patch", flush=True)
else:
    txt = p.read_text()
    orig = txt
    txt = txt.replace("httpx.Timeout(180.0, connect=10.0)", "httpx.Timeout(480.0, connect=10.0)")
    txt = txt.replace("httpx.Timeout(360.0, connect=10.0)", "httpx.Timeout(480.0, connect=10.0)")
    txt = txt.replace("for attempt in range(3):", "for attempt in range(5):")
    txt = txt.replace("if attempt == 2:", "if attempt == 4:")
    if txt != orig:
        p.write_text(txt)
        print("[bootstrap-h126] patched vllm_client timeout=480 retries=5", flush=True)
    else:
        print("[bootstrap-h126] vllm_client already patched or pattern miss", flush=True)
PY

# Train init = Bittob11040 (full-FT). King Tok downloaded in post_train / extra_dl.
python - <<'PY'
import os
from huggingface_hub import snapshot_download

token = os.environ["HF_TOKEN"]
repo = "Bittob11040/Affine_5DSW4cTwQt2U8rck6mFN1nNqoj37j1waqwszQDuz2zh9zC7z"
rev = "0c04fe92ce952ffb13af69f3218d5e13cb571df5"
print("[bootstrap-h126] DOWNLOAD bittob-init start", repo, rev, flush=True)
path = snapshot_download(repo, revision=rev, token=token)
print(f"[bootstrap-h126] DOWNLOAD bittob-init done -> {path}", flush=True)
open("/root/logs/bittob_init.done", "w").write(path + "\n")
assert rev in path, path
PY

echo "[bootstrap-h126] $(date -u +%Y-%m-%dT%H:%M:%SZ) launching H126 full-FT train"
bash /root/mining_src/s4-h126-f31-bittob-full-ft/start_h126.sh
touch /root/logs/h126_train_launched.stamp

# Teacher + corpus in background (disk only; GPUs busy with train).
nohup bash -lc '
  set -euo pipefail
  set -a; source /root/mine.env; set +a
  source /root/venv/bin/activate
  export HF_HOME=/root/hf HF_TOKEN
  python - <<PY
import os
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
print("[bootstrap-h126] DOWNLOAD teacher start", flush=True)
path = snapshot_download("zai-org/GLM-4.5-Air-FP8", token=token)
print(f"[bootstrap-h126] DOWNLOAD teacher done -> {path}", flush=True)
open("/root/logs/teacher.done", "w").write(path + "\n")
print("[bootstrap-h126] DOWNLOAD tok-king start", flush=True)
kpath = snapshot_download("Tok331102/affine-5EqYW8McUc-af10", revision="eb8bf9a356a254f71faaa439e8abc3cfba572c53", token=token)
print(f"[bootstrap-h126] DOWNLOAD tok-king done -> {kpath}", flush=True)
open("/root/logs/tok331102.done", "w").write(kpath + "\n")
PY
  bash /root/mining_src/s3-duel-sim/sync_corpus.sh || true
' >/root/logs/h126_extra_dl.nohup 2>&1 &
echo $! >/root/logs/h126_extra_dl.pid

# No prewarm during train (all 8 GPUs in use). Post-train serves three after train.done.
nohup bash /root/mining_src/s4-h126-f31-bittob-full-ft/post_train_pipeline.sh \
  >/root/logs/h126_post_train.nohup 2>&1 &
echo $! >/root/logs/h126_post_train.pid

echo "[bootstrap-h126] $(date -u +%Y-%m-%dT%H:%M:%SZ) BOOTSTRAP_DONE train=$(cat /root/logs/h126_train.pid) post=$(cat /root/logs/h126_post_train.pid)"
