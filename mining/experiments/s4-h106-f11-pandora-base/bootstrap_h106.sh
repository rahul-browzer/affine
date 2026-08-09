#!/usr/bin/env bash
# mine-f11-1: pandora init download → H106 train; bg teacher+Tok331102 king; arm prewarm+post-train.
set -euo pipefail

LOG=/root/logs/bootstrap_h106.log
mkdir -p /root/logs /root/hf /root/affine_data /root/mining_src /root/h106
exec > >(tee -a "$LOG") 2>&1

echo "[bootstrap-h106] $(date -u +%Y-%m-%dT%H:%M:%SZ) start host=$(hostname)"

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
  echo "[bootstrap-h106] FATAL: HF_TOKEN missing in /root/mine.env"
  exit 1
fi

nvidia-smi -L || true
NGPU=$(nvidia-smi -L | wc -l)
echo "[bootstrap-h106] GPU_COUNT=$NGPU"
test "$NGPU" -ge 8
test -s /root/h106/winner_za_high_l2.jsonl
test -f /root/mining_src/s4-h1v2-sft/train_lora.py
test -f /root/mining_src/s4-h1-sft/merge_lora.py
test -x /root/mining_src/s4-h106-f11-pandora-base/start_h106.sh
test -x /root/mining_src/s4-h106-f11-pandora-base/post_train_pipeline.sh

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
  "safetensors" \
  "numpy" \
  "scipy" \
  2>&1 | tee /root/logs/pip_h106.log | tail -40

python - <<'PY'
import torch, transformers, vllm, peft, accelerate
print("[bootstrap-h106] VERSIONS",
      "torch", torch.__version__,
      "transformers", transformers.__version__,
      "vllm", vllm.__version__,
      "peft", peft.__version__,
      "accelerate", accelerate.__version__)
assert vllm.__version__.startswith("0.22.1"), vllm.__version__
assert transformers.__version__.startswith("5.14"), transformers.__version__
PY

# B300 SM10.3 flash_attn upper-bound patch (no-op on H200).
if [[ -x /root/mining_src/s3-duel-sim/patch_b300_sm103_flash_attn.sh ]]; then
  bash /root/mining_src/s3-duel-sim/patch_b300_sm103_flash_attn.sh || true
fi

# Patch vllm client timeouts before any sim.
python3 - <<'PY'
from pathlib import Path
p = Path("/root/mining_src/affine_pkg/evalsrv/vllm_client.py")
if not p.is_file():
    print("[bootstrap-h106] no vllm_client to patch", flush=True)
else:
    txt = p.read_text()
    orig = txt
    txt = txt.replace("httpx.Timeout(180.0, connect=10.0)", "httpx.Timeout(480.0, connect=10.0)")
    txt = txt.replace("httpx.Timeout(360.0, connect=10.0)", "httpx.Timeout(480.0, connect=10.0)")
    txt = txt.replace("for attempt in range(3):", "for attempt in range(5):")
    txt = txt.replace("if attempt == 2:", "if attempt == 4:")
    if txt != orig:
        p.write_text(txt)
        print("[bootstrap-h106] patched vllm_client timeout=480 retries=5", flush=True)
    else:
        print("[bootstrap-h106] vllm_client already patched or pattern miss", flush=True)
PY

# Train init = pandora (non-king base). Live king Tok still downloaded in bg.
python - <<'PY'
import os
from huggingface_hub import snapshot_download

token = os.environ["HF_TOKEN"]
repo = "pandora-box/Affine-5eqdtdzqle-ckpt300-m4"
rev = "5218b1383952ff7a8d49b1d7b82acfe5e1bd448d"
print("[bootstrap-h106] DOWNLOAD pandora-init start", repo, rev, flush=True)
path = snapshot_download(repo, revision=rev, token=token)
print(f"[bootstrap-h106] DOWNLOAD pandora-init done -> {path}", flush=True)
open("/root/logs/pandora_init.done", "w").write(path + "\n")
# Do NOT stamp tok331102.done here — train init ≠ live king (F11 non-king base).
assert path.endswith(rev) or rev in path, path
PY

echo "[bootstrap-h106] $(date -u +%Y-%m-%dT%H:%M:%SZ) launching H106 train"
bash /root/mining_src/s4-h106-f11-pandora-base/start_h106.sh
touch /root/logs/h106_train_launched.stamp

# Teacher + Tok331102 king + corpus in background for prewarm/n80.
nohup bash -lc '
  set -euo pipefail
  set -a; source /root/mine.env; set +a
  source /root/venv/bin/activate
  export HF_HOME=/root/hf HF_TOKEN
  python - <<PY
import os
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
print("[bootstrap-h106] DOWNLOAD teacher start", flush=True)
path = snapshot_download("zai-org/GLM-4.5-Air-FP8", token=token)
print(f"[bootstrap-h106] DOWNLOAD teacher done -> {path}", flush=True)
open("/root/logs/teacher.done", "w").write(path + "\n")
print("[bootstrap-h106] DOWNLOAD tok331102 king start", flush=True)
kpath = snapshot_download(
    "Tok331102/affine-5EqYW8McUc-af10",
    revision="eb8bf9a356a254f71faaa439e8abc3cfba572c53",
    token=token,
)
print(f"[bootstrap-h106] DOWNLOAD tok331102 done -> {kpath}", flush=True)
open("/root/logs/tok331102.done", "w").write(kpath + "\n")
PY
  bash /root/mining_src/s3-duel-sim/sync_corpus.sh || true
' >/root/logs/h106_extra_dl.nohup 2>&1 &
echo $! >/root/logs/h106_extra_dl.pid

# Prewarm teacher+king once both ready; post-train waits on train.done.
nohup bash -lc '
  set -euo pipefail
  for i in $(seq 1 240); do
    [[ -f /root/logs/teacher.done && -f /root/logs/tok331102.done ]] && break
    sleep 30
  done
  test -f /root/logs/teacher.done
  test -f /root/logs/tok331102.done
  bash /root/mining_src/s4-h106-f11-pandora-base/prewarm_engines.sh
' >/root/logs/h106_prewarm.nohup 2>&1 &
echo $! >/root/logs/h106_prewarm.pid

nohup bash /root/mining_src/s4-h106-f11-pandora-base/post_train_pipeline.sh \
  >/root/logs/h106_post_train.nohup 2>&1 &
echo $! >/root/logs/h106_post_train.pid

echo "[bootstrap-h106] $(date -u +%Y-%m-%dT%H:%M:%SZ) BOOTSTRAP_DONE train=$(cat /root/logs/h106_train.pid) post=$(cat /root/logs/h106_post_train.pid)"
