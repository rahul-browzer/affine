#!/usr/bin/env bash
# Prefetch queue chal-00484 thompsville/…-cgpb9 (CPU/network only).
# p2024: cache while R2am Talent×sbs-v1 n80 gathers; do not merge/serve until
# post-verdict Reason+ (cgpb8 was SKIP_BOARD / unservable — v9 is a new parent).
# Prefer pure-parent screen (R2ao) over Talent skew — skew family keeps REFUTING.
set -euo pipefail
LOG=/root/logs/r2_prefetch_cgpb9.log
DONE=/root/logs/r2_prefetch_cgpb9.done
PIDF=/root/logs/r2_prefetch_cgpb9.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-cgpb9] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-cgpb9] already done: $(cat "$DONE")"
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

REPO=${CGPB9_REPO:-thompsville/affine-5dvegrgnsg-cgpb9}
REV=${CGPB9_REV:-59e1a06ab667c671292fbd551eac4a14a8ee0043}
export CGPB9_REPO="$REPO" CGPB9_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["CGPB9_REPO"]
rev = os.environ["CGPB9_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2024 queue chal-00484 prefetch; overlap R2am n80; Reason unknown until verdict",
    "challenge_id": "chal-00484",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_cgpb9.json")
print(f"[r2-cgpb9] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-cgpb9] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-cgpb9] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-cgpb9] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_cgpb9.done
cp -f /root/affine_data/r2_prefetch_cgpb9.json /root/logs/r2_prefetch_cgpb9.json 2>/dev/null || true
echo "[r2-cgpb9] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
