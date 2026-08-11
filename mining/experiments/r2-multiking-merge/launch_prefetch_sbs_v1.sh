#!/usr/bin/env bash
# Prefetch queue chal-00480 ammazon/…-sbs-v1 (CPU/network only).
# p2011: cache while R2al pig n80 gathers; do not merge until post-verdict
# Reason+ (sbs-v0 was SKIP_BOARD hr0.018× — v1 is a new parent).
# Separate DONE path from r2_prefetch_sbs (v0) so old stamp cannot short-circuit.
set -euo pipefail
LOG=/root/logs/r2_prefetch_sbs_v1.log
DONE=/root/logs/r2_prefetch_sbs_v1.done
PIDF=/root/logs/r2_prefetch_sbs_v1.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-sbs-v1] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-sbs-v1] already done: $(cat "$DONE")"
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

REPO=${SBS_V1_REPO:-ammazon/Affine-5dvqtektxx-sbs-v1}
REV=${SBS_V1_REV:-d88d3bc77638ec65d34c223263223e33965c7d67}
export SBS_V1_REPO="$REPO" SBS_V1_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["SBS_V1_REPO"]
rev = os.environ["SBS_V1_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2011 queue chal-00480 prefetch; overlap R2al pig n80; Reason unknown until verdict",
    "challenge_id": "chal-00480",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_sbs_v1.json")
print(f"[r2-sbs-v1] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-sbs-v1] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-sbs-v1] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-sbs-v1] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_sbs_v1.done
cp -f /root/affine_data/r2_prefetch_sbs_v1.json /root/logs/r2_prefetch_sbs_v1.json 2>/dev/null || true
echo "[r2-sbs-v1] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
