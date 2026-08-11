#!/usr/bin/env bash
# Prefetch queue chal-00471 diceofgod/…-pig (CPU/network only).
# Index probe (p1971): weights_ok @e4889db4… (2 safetensors).
# Next after google. Cache while R2p n80 gathers; do not merge until
# post-verdict Reason+. Disk ~397 GiB free at arm.
set -euo pipefail
LOG=/root/logs/r2_prefetch_pig.log
DONE=/root/logs/r2_prefetch_pig.done
PIDF=/root/logs/r2_prefetch_pig.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-pig] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-pig] already done: $(cat "$DONE")"
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

REPO=${PIG_REPO:-diceofgod/affine-5fjgc5jhxq-pig}
REV=${PIG_REV:-e4889db406e743bc878d75183aed79bc59915463}
export PIG_REPO="$REPO" PIG_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["PIG_REPO"]
rev = os.environ["PIG_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p1971 queue chal-00471 prefetch; after google; Reason unknown until verdict",
    "challenge_id": "chal-00471",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_pig.json")
print(f"[r2-pig] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-pig] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-pig] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-pig] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_pig.done
cp -f /root/affine_data/r2_prefetch_pig.json /root/logs/r2_prefetch_pig.json 2>/dev/null || true
echo "[r2-pig] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
