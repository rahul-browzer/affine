#!/usr/bin/env bash
# R18: pure sbs-v2-init → Reason-GRPO (Tok kept as n80 king only).
# Overlay: upload_and_launch copies this to r3-reason-grpo/bootstrap_r3.sh.
# Order: pip → DL sbs+teacher+Tok → serve teacher → train (6,7) → post_train.
set -euo pipefail

LOG=/root/logs/bootstrap_r3.log
mkdir -p /root/logs /root/hf /root/affine_data /root/mining_src /root/r3 /root/r18
exec > >(tee -a "$LOG") 2>&1

echo "[bootstrap-r18] $(date -u +%Y-%m-%dT%H:%M:%SZ) start host=$(hostname)"

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
  echo "[bootstrap-r18] FATAL: HF_TOKEN missing in /root/mine.env"
  exit 1
fi

nvidia-smi -L || true
NGPU=$(nvidia-smi -L | wc -l)
echo "[bootstrap-r18] GPU_COUNT=$NGPU"
test "$NGPU" -ge 8
test -s /root/r3/winner_za_high_l1.jsonl
test -f /root/mining_src/r3-reason-grpo/train_reason_grpo.py
test -f /root/mining_src/s4-h1-sft/merge_lora.py
test -x /root/mining_src/r3-reason-grpo/start_r3.sh
test -x /root/mining_src/r3-reason-grpo/post_train_pipeline.sh
# Prove overlay is R18, not stock R3 / R3b / R10.
grep -q "R18: sbs-GRPO" /root/mining_src/r3-reason-grpo/start_r3.sh
grep -q "DOWNLOAD sbs-v2-init" /root/mining_src/r3-reason-grpo/bootstrap_r3.sh

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
print("[bootstrap-r18] VERSIONS",
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
        print("[bootstrap-r18] patched vllm_client timeout=600 retries=5", flush=True)
    else:
        print("[bootstrap-r18] vllm_client already patched or pattern miss", flush=True)
PY

# Blocking DL: sbs-v2 (train init) + Tok (n80 king) + teacher.
python - <<'PY'
import os
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
sbs_repo = "ammazon/Affine-5dvqtektxx-sbs-v2"
sbs_rev = "6f1b8e682aea94a00d8387f4ab9bdef6da153944"
print("[bootstrap-r18] DOWNLOAD sbs-v2-init start", sbs_repo, sbs_rev, flush=True)
sbs = snapshot_download(sbs_repo, revision=sbs_rev, token=token)
print(f"[bootstrap-r18] DOWNLOAD sbs-v2-init done -> {sbs}", flush=True)
open("/root/logs/sbs_v2.done", "w").write(sbs + "\n")
open("/root/r18/r18_base.path", "w").write(sbs + "\n")
assert sbs_rev in sbs, sbs

tok_repo = "Tok331102/affine-5EqYW8McUc-af10"
tok_rev = "eb8bf9a356a254f71faaa439e8abc3cfba572c53"
print("[bootstrap-r18] DOWNLOAD tok331102 king start", tok_repo, tok_rev, flush=True)
tok = snapshot_download(tok_repo, revision=tok_rev, token=token)
print(f"[bootstrap-r18] DOWNLOAD tok331102 done -> {tok}", flush=True)
open("/root/logs/tok_init.done", "w").write(tok + "\n")
open("/root/logs/tok331102.done", "w").write(tok + "\n")

print("[bootstrap-r18] DOWNLOAD teacher start", flush=True)
tpath = snapshot_download("zai-org/GLM-4.5-Air-FP8", token=token)
print(f"[bootstrap-r18] DOWNLOAD teacher done -> {tpath}", flush=True)
open("/root/logs/teacher.done", "w").write(tpath + "\n")
print("[bootstrap-r18] ALL_DOWNLOADS_OK", flush=True)
PY

export BASE=$(cat /root/r18/r18_base.path)
if [[ -f /root/mine.env ]]; then
  grep -q '^export BASE=' /root/mine.env \
    && sed -i "s|^export BASE=.*|export BASE=${BASE}|" /root/mine.env \
    || echo "export BASE=${BASE}" >>/root/mine.env
fi

echo "[bootstrap-r18] $(date -u +%Y-%m-%dT%H:%M:%SZ) serving teacher before train BASE=$BASE"
bash /root/mining_src/r3-reason-grpo/prewarm_engines.sh \
  >/root/logs/r3_prewarm.nohup 2>&1 &
echo $! >/root/logs/r3_prewarm.pid
cp -f /root/logs/r3_prewarm.pid /root/logs/r18_prewarm.pid

for i in $(seq 1 240); do
  if curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null 2>&1; then
    echo "[bootstrap-r18] teacher :8000 up at iter=$i"
    break
  fi
  if (( i == 240 )); then
    echo "[bootstrap-r18] FATAL teacher never up"
    tail -80 /root/logs/r3_prewarm.nohup || true
    tail -80 /root/logs/vllm_teacher.log || true
    exit 1
  fi
  sleep 15
done

echo "[bootstrap-r18] $(date -u +%Y-%m-%dT%H:%M:%SZ) launching R18 sbs-v2 Reason-GRPO train"
BASE="$BASE" bash /root/mining_src/r3-reason-grpo/start_r3.sh
touch /root/logs/r3_train_launched.stamp
touch /root/logs/r18_train_launched.stamp

nohup bash -lc '
  set -euo pipefail
  set -a; source /root/mine.env; set +a
  source /root/venv/bin/activate
  export HF_HOME=/root/hf HF_TOKEN
  bash /root/mining_src/s3-duel-sim/sync_corpus.sh || true
' >/root/logs/r3_extra_dl.nohup 2>&1 &
echo $! >/root/logs/r3_extra_dl.pid
cp -f /root/logs/r3_extra_dl.pid /root/logs/r18_extra_dl.pid

nohup bash /root/mining_src/r3-reason-grpo/post_train_pipeline.sh \
  >/root/logs/r3_post_train.nohup 2>&1 &
echo $! >/root/logs/r3_post_train.pid
cp -f /root/logs/r3_post_train.pid /root/logs/r18_post_train.pid

echo "[bootstrap-r18] $(date -u +%Y-%m-%dT%H:%M:%SZ) BOOTSTRAP_DONE train=$(cat /root/logs/r3_train.pid) post=$(cat /root/logs/r3_post_train.pid)"
