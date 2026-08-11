#!/usr/bin/env bash
# Prefetch queue chal-00514 afgod1079/…-cp1266 (CPU/network only).
# Armed p2133 after R2bf dpo2 REFUTE — next pure board parent.
set -euo pipefail
LOG=/root/logs/r2_prefetch_cp1266.log
DONE=/root/logs/r2_prefetch_cp1266.done
PIDF=/root/logs/r2_prefetch_cp1266.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-cp1266] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-cp1266] already done: $(cat "$DONE")"
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

REPO=${CP1266_REPO:-afgod1079/Affine-5hgjp6jaqp-cp1266}
REV=${CP1266_REV:-68d1daa2a846d9f9e7ab9b8acfb304683f719be2}
export CP1266_REPO="$REPO" CP1266_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["CP1266_REPO"]
rev = os.environ["CP1266_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2133 queue chal-00514 prefetch; R2bg pure board parent after R2bf",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_cp1266.json")
print(f"[r2-cp1266] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-cp1266] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-cp1266] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-cp1266] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_cp1266.done
cp -f /root/affine_data/r2_prefetch_cp1266.json /root/logs/r2_prefetch_cp1266.json 2>/dev/null || true
echo "[r2-cp1266] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
