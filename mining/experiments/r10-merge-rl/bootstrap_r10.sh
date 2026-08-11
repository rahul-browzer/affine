#!/usr/bin/env bash
# mine-r10-merge-rl-1: DL Tok+sbs-v2+teacher → α-merge → serve teacher → GRPO on merge.
# R10: merge+RL hybrid Reason — ≠ R3 Tok-init GRPO, ≠ R2 merge→n80.
set -euo pipefail

LOG=/root/logs/bootstrap_r10.log
mkdir -p /root/logs /root/hf /root/affine_data /root/mining_src /root/r10
exec > >(tee -a "$LOG") 2>&1

echo "[bootstrap-r10] $(date -u +%Y-%m-%dT%H:%M:%SZ) start host=$(hostname)"

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
  echo "[bootstrap-r10] FATAL: HF_TOKEN missing in /root/mine.env"
  exit 1
fi

nvidia-smi -L || true
NGPU=$(nvidia-smi -L | wc -l)
echo "[bootstrap-r10] GPU_COUNT=$NGPU"
test "$NGPU" -ge 8
test -s /root/r10/winner_za_high_l1.jsonl
test -f /root/mining_src/r10-merge-rl/train_reason_grpo.py
test -f /root/mining_src/r10-merge-rl/merge_alpha.py
test -f /root/mining_src/s4-h1-sft/merge_lora.py
test -x /root/mining_src/r10-merge-rl/start_r10.sh
test -x /root/mining_src/r10-merge-rl/post_train_pipeline.sh
# Prove overlay is R10 merge+RL, not stock R3.
grep -q "R10: merge+RL" /root/mining_src/r10-merge-rl/start_r10.sh

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
  2>&1 | tee /root/logs/pip_r10.log | tail -40

python - <<'PY'
import torch, transformers, vllm, peft, accelerate, httpx, pandas, pyarrow
print("[bootstrap-r10] VERSIONS",
      "torch", torch.__version__,
      "transformers", transformers.__version__,
      "vllm", vllm.__version__,
      "peft", peft.__version__)
assert vllm.__version__.startswith("0.22.1"), vllm.__version__
assert transformers.__version__.startswith("5.14"), transformers.__version__
PY

if [[ -x /root/mining_src/s3-duel-sim/patch_b300_sm103_flash_attn.sh ]]; then
  bash /root/mining_src/s3-duel-sim/patch_b300_sm103_flash_attn.sh
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
        print("[bootstrap-r10] patched vllm_client timeout=600 retries=5", flush=True)
    else:
        print("[bootstrap-r10] vllm_client already patched or pattern miss", flush=True)
PY

# Blocking DL: Tok (layout/king) + sbs-v2 (merge parent) + teacher.
python - <<'PY'
import os
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
tok_repo = "Tok331102/affine-5EqYW8McUc-af10"
tok_rev = "eb8bf9a356a254f71faaa439e8abc3cfba572c53"
print("[bootstrap-r10] DOWNLOAD tok-init start", tok_repo, tok_rev, flush=True)
tok = snapshot_download(tok_repo, revision=tok_rev, token=token)
print(f"[bootstrap-r10] DOWNLOAD tok-init done -> {tok}", flush=True)
open("/root/logs/tok_init.done", "w").write(tok + "\n")
open("/root/logs/tok331102.done", "w").write(tok + "\n")

sbs_repo = "ammazon/Affine-5dvqtektxx-sbs-v2"
sbs_rev = "6f1b8e682aea94a00d8387f4ab9bdef6da153944"
print("[bootstrap-r10] DOWNLOAD sbs-v2 start", sbs_repo, sbs_rev, flush=True)
sbs = snapshot_download(sbs_repo, revision=sbs_rev, token=token)
print(f"[bootstrap-r10] DOWNLOAD sbs-v2 done -> {sbs}", flush=True)
open("/root/logs/sbs_v2.done", "w").write(sbs + "\n")

print("[bootstrap-r10] DOWNLOAD teacher start", flush=True)
tpath = snapshot_download("zai-org/GLM-4.5-Air-FP8", token=token)
print(f"[bootstrap-r10] DOWNLOAD teacher done -> {tpath}", flush=True)
open("/root/logs/teacher.done", "w").write(tpath + "\n")
print("[bootstrap-r10] ALL_DOWNLOADS_OK", flush=True)
PY

TOK=$(cat /root/logs/tok_init.done)
SBS=$(cat /root/logs/sbs_v2.done)
MERGE_OUT=${MERGE_OUT:-/root/r10/merge_base}
echo "[bootstrap-r10] α-merge Tok0.5 × sbs-v2 0.5 → $MERGE_OUT"
rm -rf "$MERGE_OUT"
python3 /root/mining_src/r10-merge-rl/merge_alpha.py \
  --parent "${TOK}:0.5" \
  --parent "${SBS}:0.5" \
  --out "$MERGE_OUT" \
  --device cpu \
  2>&1 | tee /root/logs/r10_merge_alpha.log
test -f "$MERGE_OUT/model.safetensors.index.json"
test -f "$MERGE_OUT/merge_alpha_meta.json" || test -f "$MERGE_OUT/merge_meta.json" || true
# Refuse weight-identical (merge_alpha exits 3); require non-empty out.
ls "$MERGE_OUT" | head
echo "[bootstrap-r10] MERGE_OK out=$MERGE_OUT"

export BASE="$MERGE_OUT"
if [[ -f /root/mine.env ]]; then
  grep -q '^export BASE=' /root/mine.env \
    && sed -i "s|^export BASE=.*|export BASE=${BASE}|" /root/mine.env \
    || echo "export BASE=${BASE}" >>/root/mine.env
fi
echo "$BASE" >/root/r10/merge_base.path

# Serve teacher (+ king) on 0–3; chall placeholder stopped; train on 6,7.
echo "[bootstrap-r10] $(date -u +%Y-%m-%dT%H:%M:%SZ) serving teacher before train"
bash /root/mining_src/r10-merge-rl/prewarm_engines.sh \
  >/root/logs/r10_prewarm.nohup 2>&1 &
echo $! >/root/logs/r10_prewarm.pid

for i in $(seq 1 240); do
  if curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null 2>&1; then
    echo "[bootstrap-r10] teacher :8000 up at iter=$i"
    break
  fi
  if (( i == 240 )); then
    echo "[bootstrap-r10] FATAL teacher never up"
    tail -80 /root/logs/r10_prewarm.nohup || true
    tail -80 /root/logs/vllm_teacher.log || true
    exit 1
  fi
  sleep 15
done

echo "[bootstrap-r10] $(date -u +%Y-%m-%dT%H:%M:%SZ) launching R10 Reason-GRPO on merge-base"
BASE="$BASE" bash /root/mining_src/r10-merge-rl/start_r10.sh
touch /root/logs/r10_train_launched.stamp

nohup bash -lc '
  set -euo pipefail
  set -a; source /root/mine.env; set +a
  source /root/venv/bin/activate
  export HF_HOME=/root/hf HF_TOKEN
  bash /root/mining_src/s3-duel-sim/sync_corpus.sh || true
' >/root/logs/r10_extra_dl.nohup 2>&1 &
echo $! >/root/logs/r10_extra_dl.pid

BASE="$BASE" TRAIN_DIR=/root/r10/train MERGED=/root/r10/merged \
  nohup bash /root/mining_src/r10-merge-rl/post_train_pipeline.sh \
  >/root/logs/r10_post_train.nohup 2>&1 &
echo $! >/root/logs/r10_post_train.pid

echo "[bootstrap-r10] $(date -u +%Y-%m-%dT%H:%M:%SZ) BOOTSTRAP_DONE train=$(cat /root/logs/r10_train.pid) post=$(cat /root/logs/r10_post_train.pid)"
