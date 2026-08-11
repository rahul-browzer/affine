#!/usr/bin/env bash
# Prefetch queue chal-00452 diceofgod/…-zeus (CPU/network only).
# Index probe (p1918): weights_ok @accc9249d879… (2 safetensors, ~65.4 GiB).
# No Reason verdict yet — cache now so a post-verdict Reason+ parent can merge
# without an idle download after R2g / R2i / BKN / sft3 / asdf resolve.
set -euo pipefail
LOG=/root/logs/r2_prefetch_zeus.log
DONE=/root/logs/r2_prefetch_zeus.done
PIDF=/root/logs/r2_prefetch_zeus.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-zeus] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-zeus] already done: $(cat "$DONE")"
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

REPO=${ZEUS_REPO:-diceofgod/affine-5fjgc5jhxq-zeus}
REV=${ZEUS_REV:-accc9249d879861f6d2c4f01c01df5b6e2426353}
export ZEUS_REPO="$REPO" ZEUS_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["ZEUS_REPO"]
rev = os.environ["ZEUS_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p1918 queue chal-00452 prefetch after asdf; Reason unknown until verdict",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_zeus.json")
print(f"[r2-zeus] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-zeus] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-zeus] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-zeus] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_zeus.done
cp -f /root/affine_data/r2_prefetch_zeus.json /root/logs/r2_prefetch_zeus.json 2>/dev/null || true
echo "[r2-zeus] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
