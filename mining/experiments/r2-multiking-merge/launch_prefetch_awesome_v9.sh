#!/usr/bin/env bash
# Prefetch queue chal-00467 0pentensor/…-awesome-v9 (CPU/network only).
# Index probe (p1966): weights_ok @75871c573246… (16 safetensors, ~70.2 GiB).
# Next awesome lineage after v8 (R2x eager already DONE). Cache while R2p n80
# gathers; do not merge until post-verdict Reason+. Disk ~642 GiB free.
set -euo pipefail
LOG=/root/logs/r2_prefetch_awesome_v9.log
DONE=/root/logs/r2_prefetch_awesome_v9.done
PIDF=/root/logs/r2_prefetch_awesome_v9.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-awesome-v9] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-awesome-v9] already done: $(cat "$DONE")"
  exit 0
fi
set -a
# shellcheck disable=SC1091
source /root/mine.env
set +a
# shellcheck disable=SC1091
source /root/venv/bin/activate
export HF_HOME=${HF_HOME:-/root/hf}
export HF_HUB_ENABLE_HF_TRANSFER=${HF_HUB_ENABLE_HF_TRANSFER:-1}
export HF_XET_HIGH_PERFORMANCE=${HF_XET_HIGH_PERFORMANCE:-1}

REPO=${AWESOME_V9_REPO:-0pentensor/Affine-5dflhtkufw-awesome-v9}
REV=${AWESOME_V9_REV:-75871c573246051f0104fbed530e8d000d8a6234}
export AWESOME_V9_REPO="$REPO" AWESOME_V9_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["AWESOME_V9_REPO"]
rev = os.environ["AWESOME_V9_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p1966 queue chal-00467 prefetch; awesome-v8 lineage next; Reason unknown until verdict",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_awesome_v9.json")
print(f"[r2-awesome-v9] downloading {repo}@{rev}…", flush=True)
t0 = time.time()
try:
    path = snapshot_download(
        repo_id=repo,
        revision=rev,
        token=os.environ.get("HF_TOKEN"),
        max_workers=8,
    )
except Exception as e:
    msg = f"{type(e).__name__}: {e}"
    print(f"[r2-awesome-v9] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-awesome-v9] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-awesome-v9] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_awesome_v9.done
cp -f /root/affine_data/r2_prefetch_awesome_v9.json /root/logs/r2_prefetch_awesome_v9.json 2>/dev/null || true
echo "[r2-awesome-v9] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
