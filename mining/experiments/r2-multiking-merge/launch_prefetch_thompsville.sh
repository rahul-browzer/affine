#!/usr/bin/env bash
# Prefetch queue chal-00441 thompsville/…-cgpb8 (CPU/network only).
# Index probe (p1907): weights_ok for unconst (~70 GiB). No Reason verdict yet —
# cache now so a post-verdict Reason+ parent can merge without an idle download
# after R2h / R2g resolve.
set -euo pipefail
LOG=/root/logs/r2_prefetch_thompsville.log
DONE=/root/logs/r2_prefetch_thompsville.done
PIDF=/root/logs/r2_prefetch_thompsville.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-thomp] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-thomp] already done: $(cat "$DONE")"
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

REPO=${THOMP_REPO:-thompsville/affine-5dvegrgnsg-cgpb8}
REV=${THOMP_REV:-1da224590eb2a140dc25907c46958830896680cf}
export THOMP_REPO="$REPO" THOMP_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["THOMP_REPO"]
rev = os.environ["THOMP_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p1907 queue chal-00441 prefetch while R2h n80; Reason unknown until verdict",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_thompsville.json")
print(f"[r2-thomp] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-thomp] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-thomp] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-thomp] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
echo "[r2-thomp] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
