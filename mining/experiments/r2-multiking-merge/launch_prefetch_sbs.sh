#!/usr/bin/env bash
# Prefetch queue chal-00468 ammazon/…-sbs-v0 (CPU/network only).
# Index probe (p1967/p1968): weights_ok @c175fe8b79a6… (16 safetensors, ~70.2 GiB).
# Next after awesome-v9 (prefetch DONE + R2z eager). Cache while R2p n80
# gathers; do not merge until post-verdict Reason+. Disk ~510 GiB free.
set -euo pipefail
LOG=/root/logs/r2_prefetch_sbs.log
DONE=/root/logs/r2_prefetch_sbs.done
PIDF=/root/logs/r2_prefetch_sbs.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-sbs] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-sbs] already done: $(cat "$DONE")"
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

REPO=${SBS_REPO:-ammazon/Affine-5dvqtektxx-sbs-v0}
REV=${SBS_REV:-c175fe8b79a66a8de97953677f1a489cb386261d}
export SBS_REPO="$REPO" SBS_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["SBS_REPO"]
rev = os.environ["SBS_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p1968 queue chal-00468 prefetch; after awesome-v9; Reason unknown until verdict",
    "challenge_id": "chal-00468",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_sbs.json")
print(f"[r2-sbs] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-sbs] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-sbs] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-sbs] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_sbs.done
cp -f /root/affine_data/r2_prefetch_sbs.json /root/logs/r2_prefetch_sbs.json 2>/dev/null || true
echo "[r2-sbs] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
