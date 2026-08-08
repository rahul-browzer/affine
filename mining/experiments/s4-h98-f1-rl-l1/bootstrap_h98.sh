#!/usr/bin/env bash
# mine-f1-1: Tok331102 init → H98/F1 REINFORCE-L1lift; bg teacher+king; prewarm+post-train.
set -euo pipefail

LOG=/root/logs/bootstrap_h98.log
mkdir -p /root/logs /root/hf /root/affine_data /root/mining_src /root/h98
exec > >(tee -a "$LOG") 2>&1

echo "[bootstrap-h98] $(date -u +%Y-%m-%dT%H:%M:%SZ) start host=$(hostname)"

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
  echo "[bootstrap-h98] FATAL: HF_TOKEN missing in /root/mine.env"
  exit 1
fi

nvidia-smi -L || true
NGPU=$(nvidia-smi -L | wc -l)
echo "[bootstrap-h98] GPU_COUNT=$NGPU"
test "$NGPU" -ge 8
test -s /root/h98/winner_za_high_l1.jsonl
test -f /root/mining_src/s4-h98-f1-rl-l1/train_rl_l1.py
test -f /root/mining_src/s4-h1-sft/merge_lora.py
test -x /root/mining_src/s4-h98-f1-rl-l1/start_h98.sh
test -x /root/mining_src/s4-h98-f1-rl-l1/post_train_pipeline.sh

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
  2>&1 | tee /root/logs/pip_h98.log | tail -40

python - <<'PY'
import torch, transformers, vllm, peft, accelerate
print("[bootstrap-h98] VERSIONS",
      "torch", torch.__version__,
      "transformers", transformers.__version__,
      "vllm", vllm.__version__,
      "peft", peft.__version__,
      "accelerate", accelerate.__version__)
assert vllm.__version__.startswith("0.22.1"), vllm.__version__
assert transformers.__version__.startswith("5.14"), transformers.__version__
PY

python3 - <<'PY'
from pathlib import Path
p = Path("/root/mining_src/affine_pkg/evalsrv/vllm_client.py")
if not p.is_file():
    print("[bootstrap-h98] no vllm_client to patch", flush=True)
else:
    txt = p.read_text()
    orig = txt
    txt = txt.replace("httpx.Timeout(180.0, connect=10.0)", "httpx.Timeout(480.0, connect=10.0)")
    txt = txt.replace("httpx.Timeout(360.0, connect=10.0)", "httpx.Timeout(480.0, connect=10.0)")
    txt = txt.replace("for attempt in range(3):", "for attempt in range(5):")
    txt = txt.replace("if attempt == 2:", "if attempt == 4:")
    if txt != orig:
        p.write_text(txt)
        print("[bootstrap-h98] patched vllm_client timeout=480 retries=5", flush=True)
    else:
        print("[bootstrap-h98] vllm_client already patched or pattern miss", flush=True)
PY

python - <<'PY'
import os
from huggingface_hub import snapshot_download

token = os.environ["HF_TOKEN"]
repo = "Tok331102/affine-5EqYW8McUc-af10"
rev = "eb8bf9a356a254f71faaa439e8abc3cfba572c53"
print("[bootstrap-h98] DOWNLOAD tok-init start", repo, rev, flush=True)
path = snapshot_download(repo, revision=rev, token=token)
print(f"[bootstrap-h98] DOWNLOAD tok-init done -> {path}", flush=True)
open("/root/logs/tok_init.done", "w").write(path + "\n")
open("/root/logs/tok331102.done", "w").write(path + "\n")
assert path.endswith(rev) or rev in path, path
PY

echo "[bootstrap-h98] $(date -u +%Y-%m-%dT%H:%M:%SZ) launching H98/F1 train"
bash /root/mining_src/s4-h98-f1-rl-l1/start_h98.sh
touch /root/logs/h98_train_launched.stamp

nohup bash -lc '
  set -euo pipefail
  set -a; source /root/mine.env; set +a
  source /root/venv/bin/activate
  export HF_HOME=/root/hf HF_TOKEN
  python - <<PY
import os
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
print("[bootstrap-h98] DOWNLOAD teacher start", flush=True)
path = snapshot_download("zai-org/GLM-4.5-Air-FP8", token=token)
print(f"[bootstrap-h98] DOWNLOAD teacher done -> {path}", flush=True)
open("/root/logs/teacher.done", "w").write(path + "\n")
print("[bootstrap-h98] DOWNLOAD tok331102 king start", flush=True)
kpath = snapshot_download(
    "Tok331102/affine-5EqYW8McUc-af10",
    revision="eb8bf9a356a254f71faaa439e8abc3cfba572c53",
    token=token,
)
print(f"[bootstrap-h98] DOWNLOAD tok331102 done -> {kpath}", flush=True)
open("/root/logs/tok331102.done", "w").write(kpath + "\n")
PY
  bash /root/mining_src/s3-duel-sim/sync_corpus.sh || true
' >/root/logs/h98_extra_dl.nohup 2>&1 &
echo $! >/root/logs/h98_extra_dl.pid

nohup bash -lc '
  set -euo pipefail
  for i in $(seq 1 240); do
    [[ -f /root/logs/teacher.done && -f /root/logs/tok331102.done ]] && break
    sleep 30
  done
  test -f /root/logs/teacher.done
  test -f /root/logs/tok331102.done
  bash /root/mining_src/s4-h98-f1-rl-l1/prewarm_engines.sh
' >/root/logs/h98_prewarm.nohup 2>&1 &
echo $! >/root/logs/h98_prewarm.pid

nohup bash /root/mining_src/s4-h98-f1-rl-l1/post_train_pipeline.sh \
  >/root/logs/h98_post_train.nohup 2>&1 &
echo $! >/root/logs/h98_post_train.pid

echo "[bootstrap-h98] $(date -u +%Y-%m-%dT%H:%M:%SZ) BOOTSTRAP_DONE train=$(cat /root/logs/h98_train.pid) post=$(cat /root/logs/h98_post_train.pid)"
