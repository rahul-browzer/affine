#!/usr/bin/env bash
# Parallel path: download teacher + prewarm engines while DPO trains on 6,7.
set -euo pipefail
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
# shellcheck disable=SC1091
source /root/venv/bin/activate
export HF_HOME=/root/hf
export HF_TOKEN
export PYTHONPATH=/root/mining_src/affine_pkg:${PYTHONPATH:-}

python - <<'PY'
import os
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
print("[h138-teacher] DOWNLOAD teacher start", flush=True)
tpath = snapshot_download("zai-org/GLM-4.5-Air-FP8", token=token)
print(f"[h138-teacher] DOWNLOAD teacher done -> {tpath}", flush=True)
open("/root/logs/teacher.done", "w").write(tpath + "\n")
PY

bash /root/mining_src/s4-h138-f43-tok-dpo-l2/prewarm_engines.sh \
  >/root/logs/h138_prewarm.nohup 2>&1
echo "[h138-teacher] prewarm launched/finished rc=$?"
