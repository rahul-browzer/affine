#!/usr/bin/env bash
# R23: diane613-init → Reason-GRPO; n80 king = live guass (p2229).
# Overlay: upload_and_launch copies this to r3-reason-grpo/bootstrap_r3.sh.
# Order: pip → DL diane+teacher+guass → serve teacher → train (6,7) → post_train.
set -euo pipefail

LOG=/root/logs/bootstrap_r3.log
mkdir -p /root/logs /root/hf /root/affine_data /root/mining_src /root/r3 /root/r23
exec > >(tee -a "$LOG") 2>&1

echo "[bootstrap-r23] $(date -u +%Y-%m-%dT%H:%M:%SZ) start host=$(hostname)"

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
  echo "[bootstrap-r23] FATAL: HF_TOKEN missing in /root/mine.env"
  exit 1
fi

nvidia-smi -L || true
NGPU=$(nvidia-smi -L | wc -l)
echo "[bootstrap-r23] GPU_COUNT=$NGPU"
test "$NGPU" -ge 8
test -s /root/r3/winner_za_high_l1.jsonl
test -f /root/mining_src/r3-reason-grpo/train_reason_grpo.py
test -f /root/mining_src/s4-h1-sft/merge_lora.py
test -x /root/mining_src/r3-reason-grpo/start_r3.sh
test -x /root/mining_src/r3-reason-grpo/post_train_pipeline.sh
# Prove overlay is R23, not stock R3 / R16 / R18–R21.
grep -q "R23: Diane-GRPO" /root/mining_src/r3-reason-grpo/start_r3.sh
grep -q "DOWNLOAD diane-init" /root/mining_src/r3-reason-grpo/bootstrap_r3.sh

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
  "pandas" \
  "pyarrow" \
  2>&1 | tee /root/logs/pip_r3.log | tail -40

python - <<'PY'
import torch, transformers, vllm, peft, accelerate, httpx
print("[bootstrap-r23] VERSIONS",
      "torch", torch.__version__,
      "transformers", transformers.__version__,
      "vllm", vllm.__version__,
      "peft", peft.__version__)
assert vllm.__version__.startswith("0.22.1"), vllm.__version__
assert transformers.__version__.startswith("5.14"), transformers.__version__
PY

if [[ -x /root/mining_src/s3-duel-sim/patch_b300_sm103_flash_attn.sh ]]; then
  bash /root/mining_src/s3-duel-sim/patch_b300_sm103_flash_attn.sh || true
  date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/b300_flash_patch.done
fi

python3 - <<'PY'
from pathlib import Path
p = Path("/root/mining_src/affine_pkg/evalsrv/vllm_client.py")
if p.is_file():
    txt = p.read_text()
    orig = txt
    txt = txt.replace("httpx.Timeout(180.0, connect=10.0)", "httpx.Timeout(600.0, connect=10.0)")
    txt = txt.replace("httpx.Timeout(360.0, connect=10.0)", "httpx.Timeout(600.0, connect=10.0)")
    txt = txt.replace("httpx.Timeout(480.0, connect=10.0)", "httpx.Timeout(600.0, connect=10.0)")
    txt = txt.replace("for attempt in range(3):", "for attempt in range(5):")
    txt = txt.replace("if attempt == 2:", "if attempt == 4:")
    if txt != orig:
        p.write_text(txt)
        print("[bootstrap-r23] patched vllm_client timeout=600 retries=5", flush=True)
    else:
        print("[bootstrap-r23] vllm_client already patched or pattern miss", flush=True)
PY

# Blocking DL: diane (train init) + guass (live n80 king) + teacher.
python - <<'PY'
import os
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
diane_repo = "diane613/Affine-5CQLBK7Mmw1vsk7eQcBok9Qn44JNU5YVrfNmZpJHPxLV271B"
diane_rev = "ad0f3f116e44dc5154ca3f72b933faaefc4905fa"
print("[bootstrap-r23] DOWNLOAD diane-init start", diane_repo, diane_rev, flush=True)
diane = snapshot_download(diane_repo, revision=diane_rev, token=token)
print(f"[bootstrap-r23] DOWNLOAD diane-init done -> {diane}", flush=True)
open("/root/logs/diane.done", "w").write(diane + "\n")
open("/root/r23/r23_base.path", "w").write(diane + "\n")
assert diane_rev in diane, diane

# Live reign-6 king (p2229): n80 must be vs guass, not retired Tok.
king_repo = "ttttxxxxsada/Affine-5guassq3tu"
king_rev = "e86758f5080d1e373e5fbbd7b4fbf6af327aeb44"
print("[bootstrap-r23] DOWNLOAD guass-king start", king_repo, king_rev, flush=True)
kpath = snapshot_download(king_repo, revision=king_rev, token=token)
print(f"[bootstrap-r23] DOWNLOAD guass-king done -> {kpath}", flush=True)
open("/root/logs/guass.done", "w").write(kpath + "\n")
# Compat stamps for older post_train gates that still look for tok*.done.
open("/root/logs/tok_init.done", "w").write(kpath + "\n")
open("/root/logs/tok331102.done", "w").write(kpath + "\n")

print("[bootstrap-r23] DOWNLOAD teacher start", flush=True)
tpath = snapshot_download("zai-org/GLM-4.5-Air-FP8", token=token)
print(f"[bootstrap-r23] DOWNLOAD teacher done -> {tpath}", flush=True)
open("/root/logs/teacher.done", "w").write(tpath + "\n")
print("[bootstrap-r23] ALL_DOWNLOADS_OK", flush=True)
PY

export BASE=$(cat /root/r23/r23_base.path)
if [[ -f /root/mine.env ]]; then
  grep -q '^export BASE=' /root/mine.env \
    && sed -i "s|^export BASE=.*|export BASE=${BASE}|" /root/mine.env \
    || echo "export BASE=${BASE}" >>/root/mine.env
fi

echo "[bootstrap-r23] $(date -u +%Y-%m-%dT%H:%M:%SZ) serving teacher before train BASE=$BASE"
bash /root/mining_src/r3-reason-grpo/prewarm_engines.sh \
  >/root/logs/r3_prewarm.nohup 2>&1 &
echo $! >/root/logs/r3_prewarm.pid
cp -f /root/logs/r3_prewarm.pid /root/logs/r23_prewarm.pid

for i in $(seq 1 240); do
  if curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null 2>&1; then
    echo "[bootstrap-r23] teacher :8000 up at iter=$i"
    break
  fi
  if (( i == 240 )); then
    echo "[bootstrap-r23] FATAL teacher never up"
    tail -80 /root/logs/r3_prewarm.nohup || true
    tail -80 /root/logs/vllm_teacher.log || true
    exit 1
  fi
  sleep 15
done

echo "[bootstrap-r23] $(date -u +%Y-%m-%dT%H:%M:%SZ) launching R23 diane Reason-GRPO train"
BASE="$BASE" bash /root/mining_src/r3-reason-grpo/start_r3.sh
touch /root/logs/r3_train_launched.stamp
touch /root/logs/r23_train_launched.stamp

nohup bash -lc '
  set -euo pipefail
  set -a; source /root/mine.env; set +a
  source /root/venv/bin/activate
  export HF_HOME=/root/hf HF_TOKEN
  bash /root/mining_src/s3-duel-sim/sync_corpus.sh || true
' >/root/logs/r3_extra_dl.nohup 2>&1 &
echo $! >/root/logs/r3_extra_dl.pid
cp -f /root/logs/r3_extra_dl.pid /root/logs/r23_extra_dl.pid

nohup bash /root/mining_src/r3-reason-grpo/post_train_pipeline.sh \
  >/root/logs/r3_post_train.nohup 2>&1 &
echo $! >/root/logs/r3_post_train.pid
cp -f /root/logs/r3_post_train.pid /root/logs/r23_post_train.pid

echo "[bootstrap-r23] $(date -u +%Y-%m-%dT%H:%M:%SZ) BOOTSTRAP_DONE train=$(cat /root/logs/r3_train.pid) post=$(cat /root/logs/r3_post_train.pid)"
