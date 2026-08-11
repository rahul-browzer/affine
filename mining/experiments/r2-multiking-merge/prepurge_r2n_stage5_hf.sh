#!/usr/bin/env bash
# Pre-purge largest public unconst/Affine-5czsc2fc98-* (≥1 GiB) while R2n n80
# gathers, so a ≥1.5× decision can start upload immediately (p1949 lesson).
# Keeps r1lora / r2v-sft3 / r2n-talent-asdf. No submit. No engine touch.
set -euo pipefail
LOG=/root/logs/prepurge_r2n_stage5_hf.log
DONE=/root/logs/prepurge_r2n_stage5_hf.done
PIDF=/root/logs/prepurge_r2n_stage5_hf.pid
META=${META:-/root/affine_data/r2n_stage5_hf_prepurge_p1960.json}
NEED_GB=${NEED_GB:-75}
KEEP_REPOS=${KEEP_REPOS:-unconst/Affine-5czsc2fc98-r1lora,unconst/Affine-5czsc2fc98-r2v-sft3,unconst/Affine-5czsc2fc98-r2n-talent-asdf}
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2n-prepurge] $(date -u +%Y-%m-%dT%H:%M:%SZ) start need_gb=$NEED_GB"
if [[ -f "$DONE" && -f "$META" ]]; then
  echo "[r2n-prepurge] already done: $(cat "$DONE")"
  exit 0
fi

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
if [[ -z "${HF_TOKEN:-}" ]]; then
  echo "[r2n-prepurge] FATAL HF_TOKEN missing" >&2
  exit 2
fi

export META NEED_GB KEEP_REPOS
python3 - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import HfApi

need_gb = float(os.environ["NEED_GB"])
keep = {x.strip() for x in os.environ["KEEP_REPOS"].split(",") if x.strip()}
api = HfApi(token=os.environ["HF_TOKEN"])
deleted, errors, cands = [], [], []
for m in api.list_models(author="unconst"):
    if not m.id.startswith("unconst/Affine-5czsc2fc98-"):
        continue
    if m.id in keep:
        continue
    try:
        info = api.model_info(m.id, files_metadata=True)
        sz = sum(int(getattr(s, "size", 0) or 0) for s in (info.siblings or []))
    except Exception as e:
        errors.append({"id": m.id, "error": f"info: {e}"})
        continue
    if sz >= int(1e9):
        cands.append((sz, m))
cands.sort(key=lambda x: x[0], reverse=True)
freed = 0
for sz, m in cands:
    if freed / 1e9 >= need_gb:
        break
    try:
        api.delete_repo(m.id, repo_type="model")
        deleted.append({"id": m.id, "bytes": sz})
        freed += sz
        print(f"[r2n-prepurge] deleted {m.id} ({sz/1e9:.1f}G)", flush=True)
    except Exception as e:
        errors.append({"id": m.id, "error": str(e)})
        print(f"[r2n-prepurge] err {m.id}: {e}", flush=True)

meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "pass": 1960,
    "need_gb": need_gb,
    "freed_bytes": freed,
    "freed_gb": freed / 1e9,
    "n_deleted": len(deleted),
    "deleted": deleted,
    "errors": errors,
    "keep": sorted(keep),
    "note": "pre-purge during R2n n80 so Stage-5 HF push can start immediately on ≥1.5×",
}
Path(os.environ["META"]).write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2), flush=True)
print("[r2n-prepurge] DONE", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) freed=$(python3 -c "import json;print(round(json.load(open('$META'))['freed_gb'],1))")G" | tee "$DONE"
