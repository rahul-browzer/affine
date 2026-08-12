#!/usr/bin/env bash
# Prefetch queue chal-00521 ttttxxxxsada/Affine-5guassq3tu (CPU/network only).
# Armed p2168 while R9 trains; R2bm pure screen vs ckp333.
set -euo pipefail
LOG=/root/logs/r2_prefetch_tttt_guass.log
DONE=/root/logs/r2_prefetch_tttt_guass.done
PIDF=/root/logs/r2_prefetch_tttt_guass.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-tttt-guass] $(date -u +%Y-%m-%dT%H:%M:%SZ) start p2168"
if [[ -f "$DONE" ]]; then
  echo "[r2-tttt-guass] already done: $(cat "$DONE")"
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

REPO=${TTTT_REPO:-ttttxxxxsada/Affine-5guassq3tu}
REV=${TTTT_REV:-e86758f5080d1e373e5fbbd7b4fbf6af327aeb44}
export TTTT_REPO="$REPO" TTTT_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["TTTT_REPO"]
rev = os.environ["TTTT_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2168 queue chal-00521 prefetch; R2bm pure tttt-guass vs ckp333",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_tttt_guass.json")
print(f"[r2-tttt-guass] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-tttt-guass] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-tttt-guass] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-tttt-guass] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_tttt_guass.done
cp -f /root/affine_data/r2_prefetch_tttt_guass.json /root/logs/r2_prefetch_tttt_guass.json 2>/dev/null || true
echo "[r2-tttt-guass] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
