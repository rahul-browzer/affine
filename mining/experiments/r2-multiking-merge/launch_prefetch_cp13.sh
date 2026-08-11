#!/usr/bin/env bash
# Prefetch live chal-00481 Talucampe037/…-cp13 (CPU/network only).
# p2018: cache while R2ac Talent×google n80 gathers; do not merge until
# post-verdict Reason+ (board hr unknown until chal-00481 finishes).
set -euo pipefail
LOG=/root/logs/r2_prefetch_cp13.log
DONE=/root/logs/r2_prefetch_cp13.done
PIDF=/root/logs/r2_prefetch_cp13.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-cp13] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-cp13] already done: $(cat "$DONE")"
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

REPO=${CP13_REPO:-Talucampe037/Affine-5f6xxabdmp-cp13}
REV=${CP13_REV:-762f3e853ad93d82024de1ce7e2b98ef35a83572}
export CP13_REPO="$REPO" CP13_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["CP13_REPO"]
rev = os.environ["CP13_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2018 live chal-00481 prefetch; overlap R2ac n80; Reason unknown until verdict",
    "challenge_id": "chal-00481",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_cp13.json")
print(f"[r2-cp13] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-cp13] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-cp13] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-cp13] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_cp13.done
cp -f /root/affine_data/r2_prefetch_cp13.json /root/logs/r2_prefetch_cp13.json 2>/dev/null || true
echo "[r2-cp13] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
