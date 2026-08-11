#!/usr/bin/env bash
# Prefetch queue chal-00508 Shatoria/…-hope12 (CPU/network only).
# Armed p2118 after R2bd UNSERVABLE (ckp55 HF-id weight-init).
set -euo pipefail
LOG=/root/logs/r2_prefetch_hope12.log
DONE=/root/logs/r2_prefetch_hope12.done
PIDF=/root/logs/r2_prefetch_hope12.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-hope12] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-hope12] already done: $(cat "$DONE")"
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

REPO=${HOPE12_REPO:-Shatoria/Affine-5ghntktyzq-hope12}
REV=${HOPE12_REV:-fea71676f4245ef1d3924f84aec01f22bc0fc7e9}
export HOPE12_REPO="$REPO" HOPE12_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["HOPE12_REPO"]
rev = os.environ["HOPE12_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2118 queue chal-00508 prefetch; R2be pure board parent after R2bd UNSERVABLE",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_hope12.json")
print(f"[r2-hope12] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-hope12] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-hope12] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-hope12] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_hope12.done
cp -f /root/affine_data/r2_prefetch_hope12.json /root/logs/r2_prefetch_hope12.json 2>/dev/null || true
echo "[r2-hope12] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
