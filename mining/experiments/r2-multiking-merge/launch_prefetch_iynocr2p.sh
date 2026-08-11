#!/usr/bin/env bash
# Prefetch queue chal-00490 darius3th/…-iynocr2p (CPU/network only).
# p2026: cache while R2am Talent×sbs-v1 n80#2 gathers; do not merge/serve until
# post-verdict Reason+. Prefer pure-parent screen over Talent skew.
set -euo pipefail
LOG=/root/logs/r2_prefetch_iynocr2p.log
DONE=/root/logs/r2_prefetch_iynocr2p.done
PIDF=/root/logs/r2_prefetch_iynocr2p.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-iynocr2p] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-iynocr2p] already done: $(cat "$DONE")"
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

REPO=${IYNOCR2P_REPO:-darius3th/Affine-5gcl5uxakb-iynocr2p}
REV=${IYNOCR2P_REV:-fe080f2b66b4eb09a815fd67b70c754dd31feb09}
export IYNOCR2P_REPO="$REPO" IYNOCR2P_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["IYNOCR2P_REPO"]
rev = os.environ["IYNOCR2P_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2035 queue chal-00490 prefetch; overlap R2ap pure-h44 n80; Reason unknown until verdict",
    "challenge_id": "chal-00490",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_iynocr2p.json")
print(f"[r2-iynocr2p] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-iynocr2p] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-iynocr2p] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-iynocr2p] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_iynocr2p.done
cp -f /root/affine_data/r2_prefetch_iynocr2p.json /root/logs/r2_prefetch_iynocr2p.json 2>/dev/null || true
echo "[r2-iynocr2p] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
