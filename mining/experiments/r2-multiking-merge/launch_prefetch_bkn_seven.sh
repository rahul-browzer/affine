#!/usr/bin/env bash
# Prefetch queue chal-00432 BKN1890/…-seven (CPU/network only).
# Index probe (p1910): weights_ok for unconst @11821bf3… (~65–70 GiB).
# No Reason verdict yet — cache now so a post-verdict Reason+ parent can merge
# without an idle download after R2h / R2g / R2i resolve.
set -euo pipefail
LOG=/root/logs/r2_prefetch_bkn_seven.log
DONE=/root/logs/r2_prefetch_bkn_seven.done
PIDF=/root/logs/r2_prefetch_bkn_seven.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-bkn7] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-bkn7] already done: $(cat "$DONE")"
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

REPO=${BKN7_REPO:-BKN1890/Affine-5ghvq9a9g9-seven}
REV=${BKN7_REV:-11821bf3164ae9e35955012e2f88223e8734ab6f}
export BKN7_REPO="$REPO" BKN7_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["BKN7_REPO"]
rev = os.environ["BKN7_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p1910 queue chal-00432 prefetch while R2h n80; Reason unknown until verdict",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_bkn_seven.json")
print(f"[r2-bkn7] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-bkn7] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-bkn7] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-bkn7] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
echo "[r2-bkn7] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
