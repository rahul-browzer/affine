#!/usr/bin/env bash
# mine-h52-1: Radiant28/m7 download → H52 train; bg teacher+TalentPigs king; arm prewarm+post-train.
set -euo pipefail

LOG=/root/logs/bootstrap_h52.log
mkdir -p /root/logs /root/hf /root/affine_data /root/mining_src /root/h52
exec > >(tee -a "$LOG") 2>&1

echo "[bootstrap-h52] $(date -u +%Y-%m-%dT%H:%M:%SZ) start host=$(hostname)"

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
  echo "[bootstrap-h52] FATAL: HF_TOKEN missing in /root/mine.env"
  exit 1
fi

nvidia-smi -L || true
NGPU=$(nvidia-smi -L | wc -l)
echo "[bootstrap-h52] GPU_COUNT=$NGPU"
test "$NGPU" -ge 8
test -s /root/h52/winner_za_high_l1.jsonl
test -f /root/mining_src/s4-h1v2-sft/train_lora.py
test -f /root/mining_src/s4-h1-sft/merge_lora.py
test -x /root/mining_src/s4-h52-m7-winner-za-lr6e6/start_h52.sh
test -x /root/mining_src/s4-h52-m7-winner-za-lr6e6/post_train_pipeline.sh

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
  2>&1 | tee /root/logs/pip_h52.log | tail -40

python - <<'PY'
import torch, transformers, vllm, peft, accelerate
print("[bootstrap-h52] VERSIONS",
      "torch", torch.__version__,
      "transformers", transformers.__version__,
      "vllm", vllm.__version__,
      "peft", peft.__version__,
      "accelerate", accelerate.__version__)
assert vllm.__version__.startswith("0.22.1"), vllm.__version__
assert transformers.__version__.startswith("5.14"), transformers.__version__
PY

# Patch vllm client timeouts before any sim.
python3 - <<'PY'
from pathlib import Path
p = Path("/root/mining_src/affine_pkg/evalsrv/vllm_client.py")
if not p.is_file():
    print("[bootstrap-h52] no vllm_client to patch", flush=True)
else:
    txt = p.read_text()
    orig = txt
    txt = txt.replace("httpx.Timeout(180.0, connect=10.0)", "httpx.Timeout(480.0, connect=10.0)")
    txt = txt.replace("httpx.Timeout(360.0, connect=10.0)", "httpx.Timeout(480.0, connect=10.0)")
    txt = txt.replace("for attempt in range(3):", "for attempt in range(5):")
    txt = txt.replace("if attempt == 2:", "if attempt == 4:")
    if txt != orig:
        p.write_text(txt)
        print("[bootstrap-h52] patched vllm_client timeout=480 retries=5", flush=True)
    else:
        print("[bootstrap-h52] vllm_client already patched or pattern miss", flush=True)
PY

# Train init = m7 (must finish before start_h52).
python - <<'PY'
import os
from huggingface_hub import snapshot_download

token = os.environ["HF_TOKEN"]
repo = "Radiant28/5eqdtdzqle-ckpt1000-m7"
rev = "f766293ee878efef5f068a4053d6974017f11f26"
print("[bootstrap-h52] DOWNLOAD m7 start", repo, rev, flush=True)
path = snapshot_download(repo, revision=rev, token=token)
print(f"[bootstrap-h52] DOWNLOAD m7 done -> {path}", flush=True)
open("/root/logs/m7.done", "w").write(path + "\n")
# Convenience stamp used by start_h52 default BASE path check.
assert path.endswith(rev) or rev in path, path
PY

echo "[bootstrap-h52] $(date -u +%Y-%m-%dT%H:%M:%SZ) launching H52 train"
bash /root/mining_src/s4-h52-m7-winner-za-lr6e6/start_h52.sh
touch /root/logs/h52_train_launched.stamp

# Teacher + TalentPigs king + corpus in background for prewarm/n80.
nohup bash -lc '
  set -euo pipefail
  set -a; source /root/mine.env; set +a
  source /root/venv/bin/activate
  export HF_HOME=/root/hf HF_TOKEN
  python - <<PY
import os
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
print("[bootstrap-h52] DOWNLOAD teacher start", flush=True)
path = snapshot_download("zai-org/GLM-4.5-Air-FP8", token=token)
print(f"[bootstrap-h52] DOWNLOAD teacher done -> {path}", flush=True)
open("/root/logs/teacher.done", "w").write(path + "\n")
print("[bootstrap-h52] DOWNLOAD talentpigs king start", flush=True)
kpath = snapshot_download(
    "TalentPigs/affine-5ekxlcg3fx-abc",
    revision="dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4",
    token=token,
)
print(f"[bootstrap-h52] DOWNLOAD talentpigs done -> {kpath}", flush=True)
open("/root/logs/talentpigs.done", "w").write(kpath + "\n")
PY
  bash /root/mining_src/s3-duel-sim/sync_corpus.sh || true
' >/root/logs/h52_extra_dl.nohup 2>&1 &
echo $! >/root/logs/h52_extra_dl.pid

# Prewarm teacher+king once both ready; post-train waits on train.done.
nohup bash -lc '
  set -euo pipefail
  for i in $(seq 1 240); do
    [[ -f /root/logs/teacher.done && -f /root/logs/talentpigs.done ]] && break
    sleep 30
  done
  test -f /root/logs/teacher.done
  test -f /root/logs/talentpigs.done
  bash /root/mining_src/s4-h52-m7-winner-za-lr6e6/prewarm_engines.sh
' >/root/logs/h52_prewarm.nohup 2>&1 &
echo $! >/root/logs/h52_prewarm.pid

nohup bash /root/mining_src/s4-h52-m7-winner-za-lr6e6/post_train_pipeline.sh \
  >/root/logs/h52_post_train.nohup 2>&1 &
echo $! >/root/logs/h52_post_train.pid

echo "[bootstrap-h52] $(date -u +%Y-%m-%dT%H:%M:%SZ) BOOTSTRAP_DONE train=$(cat /root/logs/h52_train.pid) post=$(cat /root/logs/h52_post_train.pid)"
