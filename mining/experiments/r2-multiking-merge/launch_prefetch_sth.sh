#!/usr/bin/env bash
# Prefetch fortunateGambler/…-sth @8d81e782 (CPU/network only, ~70 GiB).
# Board chal-00455 Reason hr≈0.79× (best DL Reason+). p1979 purged the cache;
# p1982 re-fetch for R2ae pure-sth n80 after R2r. Clear stale *.done before relaunch.
set -euo pipefail
LOG=/root/logs/r2_prefetch_sth.log
DONE=/root/logs/r2_prefetch_sth.done
PIDF=/root/logs/r2_prefetch_sth.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-sth] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-sth] already done: $(cat "$DONE")"
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

REPO=${STH_REPO:-fortunateGambler/affine-5cwwlhucdc-sth}
REV=${STH_REV:-8d81e78204c591a927bfe4daeb8fdb6aa163a5d1}
export STH_REPO="$REPO" STH_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["STH_REPO"]
rev = os.environ["STH_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p1982 re-prefetch after p1979 purge; R2ae pure-sth n80 (board hr 0.79×)",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_sth.json")
print(f"[r2-sth] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-sth] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-sth] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-sth] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_sth.done
cp -f /root/affine_data/r2_prefetch_sth.json /root/logs/r2_prefetch_sth.json 2>/dev/null || true
echo "[r2-sth] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
