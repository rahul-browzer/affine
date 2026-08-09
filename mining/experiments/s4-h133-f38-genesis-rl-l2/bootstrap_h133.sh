#!/usr/bin/env bash
# mine-f38-1: Genesis init → H133/F38 REINFORCE teacher-Λ2.
# Order: pip → DL genesis+teacher → serve teacher → train (6,7) → Tok king DL + post_train.
set -euo pipefail

LOG=/root/logs/bootstrap_h133.log
mkdir -p /root/logs /root/hf /root/affine_data /root/mining_src /root/h133
exec > >(tee -a "$LOG") 2>&1

echo "[bootstrap-h133] $(date -u +%Y-%m-%dT%H:%M:%SZ) start host=$(hostname)"

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
  echo "[bootstrap-h133] FATAL: HF_TOKEN missing in /root/mine.env"
  exit 1
fi

nvidia-smi -L || true
NGPU=$(nvidia-smi -L | wc -l)
echo "[bootstrap-h133] GPU_COUNT=$NGPU"
test "$NGPU" -ge 8
test -s /root/h133/winner_za_high_l1.jsonl
test -f /root/mining_src/s4-h133-f38-genesis-rl-l2/train_rl_l2.py
test -f /root/mining_src/s4-h1-sft/merge_lora.py
test -x /root/mining_src/s4-h133-f38-genesis-rl-l2/start_h133.sh
test -x /root/mining_src/s4-h133-f38-genesis-rl-l2/post_train_pipeline.sh

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
  2>&1 | tee /root/logs/pip_h133.log | tail -40

python - <<'PY'
import torch, transformers, vllm, peft, accelerate, httpx
print("[bootstrap-h133] VERSIONS",
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
        print("[bootstrap-h133] patched vllm_client timeout=480 retries=5", flush=True)
    else:
        print("[bootstrap-h133] vllm_client already patched or pattern miss", flush=True)
PY

# Blocking DL: genesis-init + teacher (train needs both; teacher first).
# Tok king DL happens in extra_dl (n80 only).
python - <<'PY'
import os
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
repo = "dendriteholdings/albedo-qwen3.6-35b-king-genesis"
rev = "abe89194d6addf82e71f3f1ba9fef94b05404abf"
print("[bootstrap-h133] DOWNLOAD genesis-init start", repo, rev, flush=True)
path = snapshot_download(repo, revision=rev, token=token)
print(f"[bootstrap-h133] DOWNLOAD genesis-init done -> {path}", flush=True)
open("/root/logs/genesis_init.done", "w").write(path + "
")
print("[bootstrap-h133] DOWNLOAD teacher start", flush=True)
tpath = snapshot_download("zai-org/GLM-4.5-Air-FP8", token=token)
print(f"[bootstrap-h133] DOWNLOAD teacher done -> {tpath}", flush=True)
open("/root/logs/teacher.done", "w").write(tpath + "
")
PY

# Serve teacher only on 0,1 (chall placeholder stopped; king later).
echo "[bootstrap-h133] $(date -u +%Y-%m-%dT%H:%M:%SZ) serving teacher before train"
bash /root/mining_src/s4-h133-f38-genesis-rl-l2/prewarm_engines.sh \
  >/root/logs/h133_prewarm.nohup 2>&1 &
echo $! >/root/logs/h133_prewarm.pid

# Wait teacher :8000 (king optional for train; start_h133 waits teacher).
for i in $(seq 1 240); do
  if curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null 2>&1; then
    echo "[bootstrap-h133] teacher :8000 up at iter=$i"
    break
  fi
  if (( i == 240 )); then
    echo "[bootstrap-h133] FATAL teacher never up"
    tail -80 /root/logs/h133_prewarm.nohup || true
    tail -80 /root/logs/vllm_teacher.log || true
    exit 1
  fi
  sleep 15
done

echo "[bootstrap-h133] $(date -u +%Y-%m-%dT%H:%M:%SZ) launching H133/F38 train"
bash /root/mining_src/s4-h133-f38-genesis-rl-l2/start_h133.sh
touch /root/logs/h133_train_launched.stamp

nohup bash -lc '
  set -euo pipefail
  set -a; source /root/mine.env; set +a
  source /root/venv/bin/activate
  export HF_HOME=/root/hf HF_TOKEN
  python - <<PY
import os
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
print("[bootstrap-h133] DOWNLOAD tok331102 king start", flush=True)
kpath = snapshot_download(
    "Tok331102/affine-5EqYW8McUc-af10",
    revision="eb8bf9a356a254f71faaa439e8abc3cfba572c53",
    token=token,
)
print(f"[bootstrap-h133] DOWNLOAD tok331102 done -> {kpath}", flush=True)
open("/root/logs/tok331102.done", "w").write(kpath + "\n")
PY
  bash /root/mining_src/s3-duel-sim/sync_corpus.sh || true
' >/root/logs/h133_extra_dl.nohup 2>&1 &
echo $! >/root/logs/h133_extra_dl.pid

nohup bash /root/mining_src/s4-h133-f38-genesis-rl-l2/post_train_pipeline.sh \
  >/root/logs/h133_post_train.nohup 2>&1 &
echo $! >/root/logs/h133_post_train.pid

echo "[bootstrap-h133] $(date -u +%Y-%m-%dT%H:%M:%SZ) BOOTSTRAP_DONE train=$(cat /root/logs/h133_train.pid) post=$(cat /root/logs/h133_post_train.pid)"
