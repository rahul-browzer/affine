#!/usr/bin/env bash
# Prefetch leary-criste/…-tt (chal-00337 Reason+ n80 board probe).
# p2049: cache while R2as pure-726 n80 gathers; R2ax pure-tt after R2av.
# Ungated. CPU/network only. No GPU. No chall kill.
set -euo pipefail
LOG=/root/logs/r2_prefetch_tt.log
DONE=/root/logs/r2_prefetch_tt.done
PIDF=/root/logs/r2_prefetch_tt.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-tt] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-tt] already done: $(cat "$DONE")"
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

REPO=${TT_REPO:-leary-criste/affine-5g4yy75zuz-tt}
REV=${TT_REV:-93aeaa1765a79d0444b688e2de53864c23a320b9}
export TT_REPO="$REPO" TT_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["TT_REPO"]
rev = os.environ["TT_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2049 chal-00337 prefetch; board was n=80 Reason+ (m+0.0116 z=2.33 hr3=0.775×) — local n80 under Reason v3 after R2av",
    "challenge_id": "chal-00337",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_tt.json")
print(f"[r2-tt] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-tt] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-tt] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-tt] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_tt.done
cp -f /root/affine_data/r2_prefetch_tt.json /root/logs/r2_prefetch_tt.json 2>/dev/null || true
echo "[r2-tt] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
