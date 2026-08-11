#!/usr/bin/env bash
# Prefetch queue chal-00489 Tok331102/…-af17 (CPU/network only).
# p2028: same-lineage Tok parent just queued; cache after `now` to avoid HF contention.
# Prefer pure-parent screen (Talent0.25 skew keeps REFUTEing). No GPU / no merge yet.
set -euo pipefail
LOG=/root/logs/r2_prefetch_af17.log
DONE=/root/logs/r2_prefetch_af17.done
PIDF=/root/logs/r2_prefetch_af17.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-af17] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-af17] already done: $(cat "$DONE")"
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

REPO=${AF17_REPO:-Tok331102/affine-5EqYW8McUc-af17}
REV=${AF17_REV:-b7fdf6f02ae6d81235d8e6656d67003e198f51c7}
export AF17_REPO="$REPO" AF17_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["AF17_REPO"]
rev = os.environ["AF17_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2028 queue chal-00489 Tok af17 prefetch; overlap R2am n80; Reason unknown until verdict",
    "challenge_id": "chal-00489",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_af17.json")
print(f"[r2-af17] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-af17] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-af17] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-af17] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_af17.done
cp -f /root/affine_data/r2_prefetch_af17.json /root/logs/r2_prefetch_af17.json 2>/dev/null || true
echo "[r2-af17] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
