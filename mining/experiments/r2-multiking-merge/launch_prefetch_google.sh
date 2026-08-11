#!/usr/bin/env bash
# Prefetch queue chal-00470 tojointhecommunity/…-google (CPU/network only).
# Index probe (p1970): weights_ok @9cb6484f2bb4… (2 safetensors).
# Next after sky. Cache while R2p n80 gathers; do not merge until
# post-verdict Reason+. Disk ~440 GiB free at arm.
set -euo pipefail
LOG=/root/logs/r2_prefetch_google.log
DONE=/root/logs/r2_prefetch_google.done
PIDF=/root/logs/r2_prefetch_google.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-google] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-google] already done: $(cat "$DONE")"
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

REPO=${GOOGLE_REPO:-tojointhecommunity/affine-5efg6cm3yl-google}
REV=${GOOGLE_REV:-9cb6484f2bb4c9d93f10ff94335eef4f0e2ae4e4}
export GOOGLE_REPO="$REPO" GOOGLE_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["GOOGLE_REPO"]
rev = os.environ["GOOGLE_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p1970 queue chal-00470 prefetch; after sky; Reason unknown until verdict",
    "challenge_id": "chal-00470",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_google.json")
print(f"[r2-google] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-google] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-google] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-google] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_google.done
cp -f /root/affine_data/r2_prefetch_google.json /root/logs/r2_prefetch_google.json 2>/dev/null || true
echo "[r2-google] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
