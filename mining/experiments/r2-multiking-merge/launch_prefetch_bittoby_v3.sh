#!/usr/bin/env bash
# Prefetch queue chal-00520 Bittoby1040/Affine-5cxncav2du-v3 (CPU/network only).
# Armed p2156 while R2bk n80 runs; R2bl pure screen vs ckp333 after R2bk+R9.
set -euo pipefail
LOG=/root/logs/r2_prefetch_bittoby_v3.log
DONE=/root/logs/r2_prefetch_bittoby_v3.done
PIDF=/root/logs/r2_prefetch_bittoby_v3.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-bittoby-v3] $(date -u +%Y-%m-%dT%H:%M:%SZ) start p2156"
if [[ -f "$DONE" ]]; then
  echo "[r2-bittoby-v3] already done: $(cat "$DONE")"
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

REPO=${BITTOBY_REPO:-Bittoby1040/Affine-5cxncav2du-v3}
REV=${BITTOBY_REV:-6901350c17028947c0df82894a0b11b953b560b7}
export BITTOBY_REPO="$REPO" BITTOBY_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["BITTOBY_REPO"]
rev = os.environ["BITTOBY_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2156 queue chal-00520 prefetch; R2bl pure bittoby-v3 after R2bk+R9",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_bittoby_v3.json")
print(f"[r2-bittoby-v3] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-bittoby-v3] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-bittoby-v3] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-bittoby-v3] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_bittoby_v3.done
cp -f /root/affine_data/r2_prefetch_bittoby_v3.json /root/logs/r2_prefetch_bittoby_v3.json 2>/dev/null || true
echo "[r2-bittoby-v3] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
