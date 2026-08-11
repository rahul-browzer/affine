#!/usr/bin/env bash
# R16: golden-crown-init → REINFORCE on teacher Reason.
# Overlay: upload_and_launch copies this to s4-h135-f40-kevin-rl-l2/bootstrap_h135.sh.
# Order: pip → DL golden+teacher → serve teacher → train (6,7) → Tok king DL + post_train.
set -euo pipefail

LOG=/root/logs/bootstrap_h135.log
mkdir -p /root/logs /root/hf /root/affine_data /root/mining_src /root/h135 /root/r16
exec > >(tee -a "$LOG") 2>&1

echo "[bootstrap-r16] $(date -u +%Y-%m-%dT%H:%M:%SZ) start host=$(hostname)"

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
  echo "[bootstrap-r16] FATAL: HF_TOKEN missing in /root/mine.env"
  exit 1
fi

nvidia-smi -L || true
NGPU=$(nvidia-smi -L | wc -l)
echo "[bootstrap-r16] GPU_COUNT=$NGPU"
test "$NGPU" -ge 8
test -s /root/h135/winner_za_high_l1.jsonl
test -f /root/mining_src/s4-h135-f40-kevin-rl-l2/train_rl_l2.py
test -f /root/mining_src/s4-h1-sft/merge_lora.py
test -x /root/mining_src/s4-h135-f40-kevin-rl-l2/start_h135.sh
test -x /root/mining_src/s4-h135-f40-kevin-rl-l2/post_train_pipeline.sh
# Prove overlay is R16, not stock H135 / R14/R15.
grep -q "R16: golden-REINFORCE" /root/mining_src/s4-h135-f40-kevin-rl-l2/start_h135.sh
grep -q "DOWNLOAD golden-init" /root/mining_src/s4-h135-f40-kevin-rl-l2/bootstrap_h135.sh

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
  2>&1 | tee /root/logs/pip_h135.log | tail -40

python - <<'PY'
import torch, transformers, vllm, peft, accelerate, httpx
print("[bootstrap-r16] VERSIONS",
      "torch", torch.__version__,
      "transformers", transformers.__version__,
      "vllm", vllm.__version__,
      "peft", peft.__version__)
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
    txt = txt.replace("httpx.Timeout(180.0, connect=10.0)", "httpx.Timeout(600.0, connect=10.0)")
    txt = txt.replace("httpx.Timeout(360.0, connect=10.0)", "httpx.Timeout(600.0, connect=10.0)")
    txt = txt.replace("httpx.Timeout(480.0, connect=10.0)", "httpx.Timeout(600.0, connect=10.0)")
    txt = txt.replace("for attempt in range(3):", "for attempt in range(5):")
    txt = txt.replace("if attempt == 2:", "if attempt == 4:")
    if txt != orig:
        p.write_text(txt)
        print("[bootstrap-r16] patched vllm_client timeout=600 retries=5", flush=True)
    else:
        print("[bootstrap-r16] vllm_client already patched or pattern miss", flush=True)
PY

# Blocking DL: golden-init + teacher (train needs both).
python - <<'PY'
import os
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
repo = "golden-crown/Affine-5EpvnXGu8jUAVc67oPGgJ3brR4JZqjBUSaTKhZuBoNAAzSJF"
rev = "ee37f4f0457df943d957435d7c9c24222a7ca93d"
print("[bootstrap-r16] DOWNLOAD golden-init start", repo, rev, flush=True)
path = snapshot_download(repo, revision=rev, token=token)
print(f"[bootstrap-r16] DOWNLOAD golden-init done -> {path}", flush=True)
open("/root/logs/golden_init.done", "w").write(path + "\n")
open("/root/h135/r16_base.path", "w").write(path + "\n")
assert rev in path, path
print("[bootstrap-r16] DOWNLOAD teacher start", flush=True)
tpath = snapshot_download("zai-org/GLM-4.5-Air-FP8", token=token)
print(f"[bootstrap-r16] DOWNLOAD teacher done -> {tpath}", flush=True)
open("/root/logs/teacher.done", "w").write(tpath + "\n")
PY

export BASE=$(cat /root/h135/r16_base.path)
if [[ -f /root/mine.env ]]; then
  grep -q '^export BASE=' /root/mine.env \
    && sed -i "s|^export BASE=.*|export BASE=${BASE}|" /root/mine.env \
    || echo "export BASE=${BASE}" >>/root/mine.env
fi

echo "[bootstrap-r16] $(date -u +%Y-%m-%dT%H:%M:%SZ) serving teacher before train BASE=$BASE"
bash /root/mining_src/s4-h135-f40-kevin-rl-l2/prewarm_engines.sh \
  >/root/logs/h135_prewarm.nohup 2>&1 &
echo $! >/root/logs/h135_prewarm.pid
cp -f /root/logs/h135_prewarm.pid /root/logs/r16_prewarm.pid

for i in $(seq 1 240); do
  if curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null 2>&1; then
    echo "[bootstrap-r16] teacher :8000 up at iter=$i"
    break
  fi
  if (( i == 240 )); then
    echo "[bootstrap-r16] FATAL teacher never up"
    tail -80 /root/logs/h135_prewarm.nohup || true
    tail -80 /root/logs/vllm_teacher.log || true
    exit 1
  fi
  sleep 15
done

echo "[bootstrap-r16] $(date -u +%Y-%m-%dT%H:%M:%SZ) launching R16 golden-REINFORCE train"
bash /root/mining_src/s4-h135-f40-kevin-rl-l2/start_h135.sh
touch /root/logs/h135_train_launched.stamp
touch /root/logs/r16_train_launched.stamp

nohup bash -lc '
  set -euo pipefail
  set -a; source /root/mine.env; set +a
  source /root/venv/bin/activate
  export HF_HOME=/root/hf HF_TOKEN
  python - <<PY
import os
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
print("[bootstrap-r16] DOWNLOAD tok331102 king start", flush=True)
kpath = snapshot_download(
    "Tok331102/affine-5EqYW8McUc-af10",
    revision="eb8bf9a356a254f71faaa439e8abc3cfba572c53",
    token=token,
)
print(f"[bootstrap-r16] DOWNLOAD tok331102 done -> {kpath}", flush=True)
open("/root/logs/tok331102.done", "w").write(kpath + "\n")
PY
  bash /root/mining_src/s3-duel-sim/sync_corpus.sh || true
' >/root/logs/h135_extra_dl.nohup 2>&1 &
echo $! >/root/logs/h135_extra_dl.pid
cp -f /root/logs/h135_extra_dl.pid /root/logs/r16_extra_dl.pid

nohup bash /root/mining_src/s4-h135-f40-kevin-rl-l2/post_train_pipeline.sh \
  >/root/logs/h135_post_train.nohup 2>&1 &
echo $! >/root/logs/h135_post_train.pid
cp -f /root/logs/h135_post_train.pid /root/logs/r16_post_train.pid

echo "[bootstrap-r16] $(date -u +%Y-%m-%dT%H:%M:%SZ) BOOTSTRAP_DONE train=$(cat /root/logs/h135_train.pid) post=$(cat /root/logs/h135_post_train.pid)"
