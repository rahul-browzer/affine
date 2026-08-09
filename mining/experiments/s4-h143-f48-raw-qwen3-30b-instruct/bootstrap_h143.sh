#!/usr/bin/env bash
# mine-f48-1: raw Qwen3-30B-Instruct-2507 chall (no train) vs Tok king — F48/H143 screen.
set -euo pipefail

LOG=/root/logs/bootstrap_h143.log
mkdir -p /root/logs /root/hf /root/affine_data /root/mining_src /root/h143
exec > >(tee -a "$LOG") 2>&1

echo "[bootstrap-h143] $(date -u +%Y-%m-%dT%H:%M:%SZ) start host=$(hostname)"

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
  echo "[bootstrap-h143] FATAL: HF_TOKEN missing in /root/mine.env"
  exit 1
fi

nvidia-smi -L || true
NGPU=$(nvidia-smi -L | wc -l)
echo "[bootstrap-h143] GPU_COUNT=$NGPU"
test "$NGPU" -ge 8

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
  2>&1 | tee /root/logs/pip_h143.log | tail -40

python - <<'PY'
import torch, transformers, vllm
print("[bootstrap-h143] VERSIONS",
      "torch", torch.__version__,
      "transformers", transformers.__version__,
      "vllm", vllm.__version__)
assert vllm.__version__.startswith("0.22.1"), vllm.__version__
assert transformers.__version__.startswith("5.14"), transformers.__version__
PY

if [[ -x /root/mining_src/s3-duel-sim/patch_b300_sm103_flash_attn.sh ]]; then
  bash /root/mining_src/s3-duel-sim/patch_b300_sm103_flash_attn.sh || true
fi

python3 - <<'PY'
from pathlib import Path
p = Path("/root/mining_src/affine_pkg/evalsrv/vllm_client.py")
if p.is_file():
    txt = p.read_text()
    orig = txt
    txt = txt.replace("httpx.Timeout(180.0, connect=10.0)", "httpx.Timeout(480.0, connect=10.0)")
    txt = txt.replace("httpx.Timeout(360.0, connect=10.0)", "httpx.Timeout(480.0, connect=10.0)")
    txt = txt.replace("for attempt in range(3):", "for attempt in range(5):")
    txt = txt.replace("if attempt == 2:", "if attempt == 4:")
    if txt != orig:
        p.write_text(txt)
        print("[bootstrap-h143] patched vllm_client timeout=480 retries=5", flush=True)
    else:
        print("[bootstrap-h143] vllm_client already patched or pattern miss", flush=True)
PY

# Download chall=instruct-2507, king=Tok, teacher — then serve + stamp chall ready.
python - <<'PY'
import os
from pathlib import Path
from huggingface_hub import snapshot_download

token = os.environ["HF_TOKEN"]
print("[bootstrap-h143] DOWNLOAD instruct chall start", flush=True)
gpath = snapshot_download(
    "Qwen/Qwen3-30B-A3B-Instruct-2507",
    revision="0d7cf23991f47feeb3a57ecb4c9cee8ea4a17bfe",
    token=token,
)
print(f"[bootstrap-h143] DOWNLOAD instruct done -> {gpath}", flush=True)
chall = Path("/root/h143/chall")
if chall.is_symlink() or chall.exists():
    if chall.is_dir() and not chall.is_symlink():
        pass
    else:
        chall.unlink()
if not chall.exists():
    chall.symlink_to(gpath)
Path("/root/logs/instruct_chall.done").write_text(gpath + "\n")
# retry script expects merge.done for legacy gate — stamp it (no merge occurred)
Path("/root/logs/h143_merge.done").write_text(
    "RAW_QWEN3_30B_INSTRUCT_NO_MERGE " + gpath + "\n"
)
print("[bootstrap-h143] DOWNLOAD teacher start", flush=True)
tpath = snapshot_download("zai-org/GLM-4.5-Air-FP8", token=token)
print(f"[bootstrap-h143] DOWNLOAD teacher done -> {tpath}", flush=True)
Path("/root/logs/teacher.done").write_text(tpath + "\n")
print("[bootstrap-h143] DOWNLOAD tok331102 king start", flush=True)
kpath = snapshot_download(
    "Tok331102/affine-5EqYW8McUc-af10",
    revision="eb8bf9a356a254f71faaa439e8abc3cfba572c53",
    token=token,
)
print(f"[bootstrap-h143] DOWNLOAD tok331102 done -> {kpath}", flush=True)
Path("/root/logs/tok331102.done").write_text(kpath + "\n")
print("[bootstrap-h143] ALL_DOWNLOADS_OK", flush=True)
PY

bash /root/mining_src/s3-duel-sim/sync_corpus.sh || true

echo "[bootstrap-h143] $(date -u +%Y-%m-%dT%H:%M:%SZ) serving teacher+Tok+instruct"
export TEACHER_REPO=zai-org/GLM-4.5-Air-FP8
export KING_REPO=Tok331102/affine-5EqYW8McUc-af10
export KING_REV=eb8bf9a356a254f71faaa439e8abc3cfba572c53
export CHALL_REPO=/root/h143/chall
export CHALL_REV=
export CHALL_GPUUTIL=0.72
export GPUUTIL=0.72
bash /root/mining_src/s3-duel-sim/serve_three.sh

# Wait chall promptable then stamp serve done for retry watcher.
for i in $(seq 1 240); do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$code" == "200" ]]; then
    echo "chall_serve_ok poll=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
      | tee /root/logs/h143_chall_serve.done
    break
  fi
  sleep 15
done
test -f /root/logs/h143_chall_serve.done

echo "[bootstrap-h143] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE — engines up; n80 watcher owns screen"
touch /root/logs/bootstrap_h143.done
