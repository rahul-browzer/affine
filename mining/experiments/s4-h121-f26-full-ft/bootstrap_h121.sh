#!/usr/bin/env bash
# mine-f26-1: Tok init download → H121 full-FT; bg teacher DL; post-train after train.done.
set -euo pipefail

LOG=/root/logs/bootstrap_h121.log
mkdir -p /root/logs /root/hf /root/affine_data /root/mining_src /root/h121
exec > >(tee -a "$LOG") 2>&1

echo "[bootstrap-h121] $(date -u +%Y-%m-%dT%H:%M:%SZ) start host=$(hostname)"

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
  echo "[bootstrap-h121] FATAL: HF_TOKEN missing in /root/mine.env"
  exit 1
fi

nvidia-smi -L || true
NGPU=$(nvidia-smi -L | wc -l)
echo "[bootstrap-h121] GPU_COUNT=$NGPU"
test "$NGPU" -ge 8
test -s /root/h121/winner_za_high_l2.jsonl
test -f /root/mining_src/s4-h121-f26-full-ft/train_full.py
test -f /root/mining_src/s4-h121-f26-full-ft/finalize_full_ft.py
test -x /root/mining_src/s4-h121-f26-full-ft/start_h121.sh
test -x /root/mining_src/s4-h121-f26-full-ft/post_train_pipeline.sh

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
  2>&1 | tee /root/logs/pip_h121.log | tail -40

python - <<'PY'
import torch, transformers, vllm, accelerate
print("[bootstrap-h121] VERSIONS",
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
    print("[bootstrap-h121] no vllm_client to patch", flush=True)
else:
    txt = p.read_text()
    orig = txt
    txt = txt.replace("httpx.Timeout(180.0, connect=10.0)", "httpx.Timeout(480.0, connect=10.0)")
    txt = txt.replace("httpx.Timeout(360.0, connect=10.0)", "httpx.Timeout(480.0, connect=10.0)")
    txt = txt.replace("for attempt in range(3):", "for attempt in range(5):")
    txt = txt.replace("if attempt == 2:", "if attempt == 4:")
    if txt != orig:
        p.write_text(txt)
        print("[bootstrap-h121] patched vllm_client timeout=480 retries=5", flush=True)
    else:
        print("[bootstrap-h121] vllm_client already patched or pattern miss", flush=True)
PY

# Train init = live Tok (full-FT will diverge). Also stamps tok331102.done for later king serve.
python - <<'PY'
import os
from huggingface_hub import snapshot_download

token = os.environ["HF_TOKEN"]
repo = "Tok331102/affine-5EqYW8McUc-af10"
rev = "eb8bf9a356a254f71faaa439e8abc3cfba572c53"
print("[bootstrap-h121] DOWNLOAD tok-init start", repo, rev, flush=True)
path = snapshot_download(repo, revision=rev, token=token)
print(f"[bootstrap-h121] DOWNLOAD tok-init done -> {path}", flush=True)
open("/root/logs/tok331102.done", "w").write(path + "\n")
assert rev in path, path
PY

echo "[bootstrap-h121] $(date -u +%Y-%m-%dT%H:%M:%SZ) launching H121 full-FT train"
bash /root/mining_src/s4-h121-f26-full-ft/start_h121.sh
touch /root/logs/h121_train_launched.stamp

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
print("[bootstrap-h121] DOWNLOAD teacher start", flush=True)
path = snapshot_download("zai-org/GLM-4.5-Air-FP8", token=token)
print(f"[bootstrap-h121] DOWNLOAD teacher done -> {path}", flush=True)
open("/root/logs/teacher.done", "w").write(path + "\n")
PY
  bash /root/mining_src/s3-duel-sim/sync_corpus.sh || true
' >/root/logs/h121_extra_dl.nohup 2>&1 &
echo $! >/root/logs/h121_extra_dl.pid

# No prewarm during train (all 8 GPUs in use). Post-train serves three after train.done.
nohup bash /root/mining_src/s4-h121-f26-full-ft/post_train_pipeline.sh \
  >/root/logs/h121_post_train.nohup 2>&1 &
echo $! >/root/logs/h121_post_train.pid

echo "[bootstrap-h121] $(date -u +%Y-%m-%dT%H:%M:%SZ) BOOTSTRAP_DONE train=$(cat /root/logs/h121_train.pid) post=$(cat /root/logs/h121_post_train.pid)"
