#!/usr/bin/env bash
# p2247: pull R25 merge onto R24 warm pod so we can n80 while R25 GPUs 1–2 are dead.
set -euo pipefail
source /root/venv/bin/activate
set -a; [[ -f /root/mine.env ]] && source /root/mine.env; set +a
export HF_HOME=${HF_HOME:-/root/hf}
export HF_HUB_ENABLE_HF_TRANSFER=${HF_HUB_ENABLE_HF_TRANSFER:-1}
export HF_XET_HIGH_PERFORMANCE=${HF_XET_HIGH_PERFORMANCE:-1}

OUT=${OUT:-/root/r25_from_hf}
LOG=${LOG:-/root/logs/r25_hf_dl.nohup}
mkdir -p "$OUT" /root/logs

miss=0
for k in $(seq 1 16); do
  f=$(printf "$OUT/model-%05d-of-00016.safetensors" "$k")
  [[ -s "$f" ]] || miss=$((miss+1))
done
if [[ -f "$OUT/config.json" && "$miss" -eq 0 ]]; then
  echo "[p2247-dl] already present $(du -sh "$OUT" | awk '{print $1}')"
  exit 0
fi

echo "[p2247-dl] $(date -u +%Y-%m-%dT%H:%M:%SZ) snapshot_download → $OUT"
python - <<'PY'
import os
from huggingface_hub import snapshot_download
p = snapshot_download(
    repo_id="unconst/Affine-5czsc2fc98-r25-merged",
    local_dir="/root/r25_from_hf",
    token=os.environ.get("HF_TOKEN"),
)
print("[p2247-dl] DONE", p)
PY
du -sh "$OUT"
ls "$OUT" | wc -l
echo "[p2247-dl] $(date -u +%Y-%m-%dT%H:%M:%SZ) OK"
