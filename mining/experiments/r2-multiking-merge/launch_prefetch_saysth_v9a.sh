#!/usr/bin/env bash
# Prefetch history chal-00440 saysth/Affine-5dtnxamt4t-v9a (CPU/network only).
# Armed p2147 after R2bi Glm4Moe UNSERVABLE; R2q never finished n80 on this crown.
set -euo pipefail
LOG=/root/logs/r2_prefetch_saysth_v9a.log
DONE=/root/logs/r2_prefetch_saysth_v9a.done
PIDF=/root/logs/r2_prefetch_saysth_v9a.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-saysth] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-saysth] already done: $(cat "$DONE")"
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

REPO=${SAYSTH_REPO:-saysth/Affine-5dtnxamt4t-v9a}
REV=${SAYSTH_REV:-6e13f365b36000cf631aad2fa9fb05fdabae0044}
export SAYSTH_REPO="$REPO" SAYSTH_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["SAYSTH_REPO"]
rev = os.environ["SAYSTH_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2147 history chal-00440 prefetch; R2bj pure saysth after R2bi",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_saysth_v9a.json")
print(f"[r2-saysth] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-saysth] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-saysth] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-saysth] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_saysth_v9a.done
cp -f /root/affine_data/r2_prefetch_saysth_v9a.json /root/logs/r2_prefetch_saysth_v9a.json 2>/dev/null || true
echo "[r2-saysth] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
