#!/usr/bin/env bash
# Prefetch queue chal-00499 ammazon/…-sbs-v2 (CPU/network only).
# p2065: cache while R2ax tt n80 gathers; pure-parent screen after R2ax.
# No GPU. No chall kill.
set -euo pipefail
LOG=/root/logs/r2_prefetch_sbs_v2.log
DONE=/root/logs/r2_prefetch_sbs_v2.done
PIDF=/root/logs/r2_prefetch_sbs_v2.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-sbs-v2] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-sbs-v2] already done: $(cat "$DONE")"
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

REPO=${SBS_V2_REPO:-ammazon/Affine-5dvqtektxx-sbs-v2}
REV=${SBS_V2_REV:-6f1b8e682aea94a00d8387f4ab9bdef6da153944}
export SBS_V2_REPO="$REPO" SBS_V2_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["SBS_V2_REPO"]
rev = os.environ["SBS_V2_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2065 queue chal-00499 prefetch; after R2ax tt; Reason unknown until verdict",
    "challenge_id": "chal-00499",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_sbs_v2.json")
print(f"[r2-sbs-v2] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-sbs-v2] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-sbs-v2] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-sbs-v2] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_sbs_v2.done
cp -f /root/affine_data/r2_prefetch_sbs_v2.json /root/logs/r2_prefetch_sbs_v2.json 2>/dev/null || true
echo "[r2-sbs-v2] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
