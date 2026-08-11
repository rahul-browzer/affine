#!/usr/bin/env bash
# Prefetch queue chal-00462 0pentensor/…-awesome-v8 (CPU/network only).
# Index probe (p1953): weights_ok @6c04b16d461d… (2 safetensors, ~70.2 GiB).
# awesome-v6 was best DL Reason+ near-miss (hr≈0.92×); v8 is next lineage
# revision on the live board. Cache now while R2l n80 gathers; do not merge
# until post-verdict Reason+. One-at-a-time HF (disk ~558 GiB free).
set -euo pipefail
LOG=/root/logs/r2_prefetch_awesome_v8.log
DONE=/root/logs/r2_prefetch_awesome_v8.done
PIDF=/root/logs/r2_prefetch_awesome_v8.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-awesome-v8] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-awesome-v8] already done: $(cat "$DONE")"
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

REPO=${AWESOME_V8_REPO:-0pentensor/Affine-5dflhtkufw-awesome-v8}
REV=${AWESOME_V8_REV:-6c04b16d461d429f9e288508e92f9e42322baec6}
export AWESOME_V8_REPO="$REPO" AWESOME_V8_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["AWESOME_V8_REPO"]
rev = os.environ["AWESOME_V8_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p1953 queue chal-00462 prefetch; awesome-v6 lineage; Reason unknown until verdict",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_awesome_v8.json")
print(f"[r2-awesome-v8] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-awesome-v8] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-awesome-v8] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-awesome-v8] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_awesome_v8.done
cp -f /root/affine_data/r2_prefetch_awesome_v8.json /root/logs/r2_prefetch_awesome_v8.json 2>/dev/null || true
echo "[r2-awesome-v8] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
