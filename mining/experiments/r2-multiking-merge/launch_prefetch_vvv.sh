#!/usr/bin/env bash
# Prefetch queue chal-00497 vera6/…-vvv (CPU/network only).
# p2066: cache while R2ax/R2ay run; pure-parent screen after R2ay.
# No GPU. No chall kill.
set -euo pipefail
LOG=/root/logs/r2_prefetch_vvv.log
DONE=/root/logs/r2_prefetch_vvv.done
PIDF=/root/logs/r2_prefetch_vvv.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-vvv] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-vvv] already done: $(cat "$DONE")"
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

REPO=${VVV_REPO:-vera6/affine-5g4yy75zuz-vvv}
REV=${VVV_REV:-464761496a109a8140021e6232b2083f4268dc13}
export VVV_REPO="$REPO" VVV_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["VVV_REPO"]
rev = os.environ["VVV_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2066 queue chal-00497 prefetch; after R2ay sbs-v2; Reason unknown until verdict",
    "challenge_id": "chal-00497",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_vvv.json")
print(f"[r2-vvv] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-vvv] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-vvv] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-vvv] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_vvv.done
cp -f /root/affine_data/r2_prefetch_vvv.json /root/logs/r2_prefetch_vvv.json 2>/dev/null || true
echo "[r2-vvv] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
