#!/usr/bin/env bash
# R5b: Talent init download → H122-stack full-FT; bg teacher+guass DL; post-train.
# Overlay: upload_and_launch copies this to s4-h122-f27-genesis-full-ft/bootstrap_h122.sh.
set -euo pipefail

LOG=/root/logs/bootstrap_h122.log
mkdir -p /root/logs /root/hf /root/affine_data /root/mining_src /root/h122
exec > >(tee -a "$LOG") 2>&1

echo "[bootstrap-r5b] $(date -u +%Y-%m-%dT%H:%M:%SZ) start host=$(hostname)"

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
  echo "[bootstrap-r5b] FATAL: HF_TOKEN missing in /root/mine.env"
  exit 1
fi

nvidia-smi -L || true
NGPU=$(nvidia-smi -L | wc -l)
echo "[bootstrap-r5b] GPU_COUNT=$NGPU"
test "$NGPU" -ge 8
test -s /root/h122/winner_za_high_l2.jsonl
test -f /root/mining_src/s4-h122-f27-genesis-full-ft/train_full.py
test -f /root/mining_src/s4-h122-f27-genesis-full-ft/finalize_full_ft.py
test -x /root/mining_src/s4-h122-f27-genesis-full-ft/start_h122.sh
test -x /root/mining_src/s4-h122-f27-genesis-full-ft/post_train_pipeline.sh
# Prove overlay is R5b Talent, not stock Genesis H122 / R5.
grep -q "R5b: Talent" /root/mining_src/s4-h122-f27-genesis-full-ft/start_h122.sh

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
  2>&1 | tee /root/logs/pip_h122.log | tail -40

python - <<'PY'
import torch, transformers, vllm, accelerate
print("[bootstrap-r5b] VERSIONS",
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
    print("[bootstrap-r5b] no vllm_client to patch", flush=True)
else:
    txt = p.read_text()
    orig = txt
    txt = txt.replace("httpx.Timeout(180.0, connect=10.0)", "httpx.Timeout(480.0, connect=10.0)")
    txt = txt.replace("httpx.Timeout(360.0, connect=10.0)", "httpx.Timeout(480.0, connect=10.0)")
    txt = txt.replace("for attempt in range(3):", "for attempt in range(5):")
    txt = txt.replace("if attempt == 2:", "if attempt == 4:")
    if txt != orig:
        p.write_text(txt)
        print("[bootstrap-r5b] patched vllm_client timeout=480 retries=5", flush=True)
    else:
        print("[bootstrap-r5b] vllm_client already patched or pattern miss", flush=True)
PY

# Train init = TalentPigs reign-3 (full-FT). Live king guass downloaded in extra_dl.
python - <<'PY'
import os
from huggingface_hub import snapshot_download

token = os.environ["HF_TOKEN"]
repo = "TalentPigs/affine-5ekxlcg3fx-abc"
rev = "dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4"
print("[bootstrap-r5b] DOWNLOAD talent-init start", repo, rev, flush=True)
path = snapshot_download(repo, revision=rev, token=token)
print(f"[bootstrap-r5b] DOWNLOAD talent-init done -> {path}", flush=True)
open("/root/logs/talent_init.done", "w").write(path + "\n")
open("/root/logs/genesis_init.done", "w").write(path + "\n")  # H122 post_train compat name
assert rev in path, path
# Export path for start/post_train via a small stamp env file.
open("/root/h122/r5b_base.path", "w").write(path + "\n")
PY

export BASE=$(cat /root/h122/r5b_base.path)
# Persist for post_train_pipeline (reads mine.env BASE).
if [[ -f /root/mine.env ]]; then
  grep -q '^export BASE=' /root/mine.env \
    && sed -i "s|^export BASE=.*|export BASE=${BASE}|" /root/mine.env \
    || echo "export BASE=${BASE}" >>/root/mine.env
fi

echo "[bootstrap-r5b] $(date -u +%Y-%m-%dT%H:%M:%SZ) launching R5b Talent full-FT train BASE=$BASE"
bash /root/mining_src/s4-h122-f27-genesis-full-ft/start_h122.sh
touch /root/logs/h122_train_launched.stamp
touch /root/logs/r5b_train_launched.stamp

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
print("[bootstrap-r5b] DOWNLOAD teacher start", flush=True)
path = snapshot_download("zai-org/GLM-4.5-Air-FP8", token=token)
print(f"[bootstrap-r5b] DOWNLOAD teacher done -> {path}", flush=True)
open("/root/logs/teacher.done", "w").write(path + "\n")
# Live reign-6 king (p2225): n80 must be vs guass, not retired Tok.
print("[bootstrap-r5b] DOWNLOAD guass-king start", flush=True)
kpath = snapshot_download(
    "ttttxxxxsada/Affine-5guassq3tu",
    revision="e86758f5080d1e373e5fbbd7b4fbf6af327aeb44",
    token=token,
)
print(f"[bootstrap-r5b] DOWNLOAD guass-king done -> {kpath}", flush=True)
open("/root/logs/guass.done", "w").write(kpath + "\n")
# H122 post_train still gates on tok331102.done — stamp with live king path.
open("/root/logs/tok331102.done", "w").write(kpath + "\n")
PY
  bash /root/mining_src/s3-duel-sim/sync_corpus.sh || true
' >/root/logs/h122_extra_dl.nohup 2>&1 &
echo $! >/root/logs/h122_extra_dl.pid

nohup bash /root/mining_src/s4-h122-f27-genesis-full-ft/post_train_pipeline.sh \
  >/root/logs/h122_post_train.nohup 2>&1 &
echo $! >/root/logs/h122_post_train.pid

echo "[bootstrap-r5b] $(date -u +%Y-%m-%dT%H:%M:%SZ) BOOTSTRAP_DONE train=$(cat /root/logs/h122_train.pid) post=$(cat /root/logs/h122_post_train.pid)"
