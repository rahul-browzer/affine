#!/usr/bin/env bash
# mine-f37-1: Tok331102 init → H132/F37 REINFORCE teacher-Λ2.
# Order: pip → DL tok+teacher → serve teacher → train (6,7) → king DL + post_train.
set -euo pipefail

LOG=/root/logs/bootstrap_h132.log
mkdir -p /root/logs /root/hf /root/affine_data /root/mining_src /root/h132
exec > >(tee -a "$LOG") 2>&1

echo "[bootstrap-h132] $(date -u +%Y-%m-%dT%H:%M:%SZ) start host=$(hostname)"

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
export PYTHONPATH=/root/mining_src/affine_pkg:${PYTHONPATH:-}

if [[ -z "${HF_TOKEN:-}" ]]; then
  echo "[bootstrap-h132] FATAL: HF_TOKEN missing in /root/mine.env"
  exit 1
fi

nvidia-smi -L || true
NGPU=$(nvidia-smi -L | wc -l)
echo "[bootstrap-h132] GPU_COUNT=$NGPU"
test "$NGPU" -ge 8
test -s /root/h132/winner_za_high_l1.jsonl
test -f /root/mining_src/s4-h132-f37-tok-rl-l2/train_rl_l2.py
test -f /root/mining_src/s4-h1-sft/merge_lora.py
test -x /root/mining_src/s4-h132-f37-tok-rl-l2/start_h132.sh
test -x /root/mining_src/s4-h132-f37-tok-rl-l2/post_train_pipeline.sh

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
  "httpx" \
  "huggingface_hub[hf_transfer]" \
  "hf_transfer" \
  "safetensors" \
  "numpy" \
  "scipy" \
  2>&1 | tee /root/logs/pip_h132.log | tail -40

python - <<'PY'
import torch, transformers, vllm, peft, accelerate, httpx
print("[bootstrap-h132] VERSIONS",
      "torch", torch.__version__,
      "transformers", transformers.__version__,
      "vllm", vllm.__version__,
      "peft", peft.__version__)
assert vllm.__version__.startswith("0.22.1"), vllm.__version__
assert transformers.__version__.startswith("5.14"), transformers.__version__
PY

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
        print("[bootstrap-h132] patched vllm_client timeout=480 retries=5", flush=True)
    else:
        print("[bootstrap-h132] vllm_client already patched or pattern miss", flush=True)
PY

# Blocking DL: tok-init + teacher (train needs both; teacher must be served first).
python - <<'PY'
import os
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
repo = "Tok331102/affine-5EqYW8McUc-af10"
rev = "eb8bf9a356a254f71faaa439e8abc3cfba572c53"
print("[bootstrap-h132] DOWNLOAD tok-init start", repo, rev, flush=True)
path = snapshot_download(repo, revision=rev, token=token)
print(f"[bootstrap-h132] DOWNLOAD tok-init done -> {path}", flush=True)
open("/root/logs/tok_init.done", "w").write(path + "\n")
open("/root/logs/tok331102.done", "w").write(path + "\n")
print("[bootstrap-h132] DOWNLOAD teacher start", flush=True)
tpath = snapshot_download("zai-org/GLM-4.5-Air-FP8", token=token)
print(f"[bootstrap-h132] DOWNLOAD teacher done -> {tpath}", flush=True)
open("/root/logs/teacher.done", "w").write(tpath + "\n")
PY

# Serve teacher only on 0,1 (chall placeholder stopped; king later).
echo "[bootstrap-h132] $(date -u +%Y-%m-%dT%H:%M:%SZ) serving teacher before train"
bash /root/mining_src/s4-h132-f37-tok-rl-l2/prewarm_engines.sh \
  >/root/logs/h132_prewarm.nohup 2>&1 &
echo $! >/root/logs/h132_prewarm.pid

# Wait teacher :8000 (king optional for train; start_h132 waits teacher).
for i in $(seq 1 240); do
  if curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null 2>&1; then
    echo "[bootstrap-h132] teacher :8000 up at iter=$i"
    break
  fi
  if (( i == 240 )); then
    echo "[bootstrap-h132] FATAL teacher never up"
    tail -80 /root/logs/h132_prewarm.nohup || true
    tail -80 /root/logs/vllm_teacher.log || true
    exit 1
  fi
  sleep 15
done

echo "[bootstrap-h132] $(date -u +%Y-%m-%dT%H:%M:%SZ) launching H132/F37 train"
bash /root/mining_src/s4-h132-f37-tok-rl-l2/start_h132.sh
touch /root/logs/h132_train_launched.stamp

nohup bash -lc '
  set -euo pipefail
  set -a; source /root/mine.env; set +a
  source /root/venv/bin/activate
  export HF_HOME=/root/hf HF_TOKEN
  bash /root/mining_src/s3-duel-sim/sync_corpus.sh || true
' >/root/logs/h132_extra_dl.nohup 2>&1 &
echo $! >/root/logs/h132_extra_dl.pid

nohup bash /root/mining_src/s4-h132-f37-tok-rl-l2/post_train_pipeline.sh \
  >/root/logs/h132_post_train.nohup 2>&1 &
echo $! >/root/logs/h132_post_train.pid

echo "[bootstrap-h132] $(date -u +%Y-%m-%dT%H:%M:%SZ) BOOTSTRAP_DONE train=$(cat /root/logs/h132_train.pid) post=$(cat /root/logs/h132_post_train.pid)"
