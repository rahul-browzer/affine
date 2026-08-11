#!/usr/bin/env bash
# Prefetch queue chal-00501 tolegend/…-ec08 (CPU/network only).
# Hub tip p2114: ungated arbosfan ec08cldg @24a3a65e…
# Cache while R2bc reload waits; do not merge.
set -euo pipefail
LOG=/root/logs/r2_prefetch_ec08.log
DONE=/root/logs/r2_prefetch_ec08.done
PIDF=/root/logs/r2_prefetch_ec08.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-ec08] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-ec08] already done: $(cat "$DONE")"
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

REPO=${EC08_REPO:-arbosfan/Affine-5eqdtdzqle-ec08cldg}
REV=${EC08_REV:-24a3a65eb68bfc1e412b1169c5d4a8c82491d227}
export EC08_REPO="$REPO" EC08_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["EC08_REPO"]
rev = os.environ["EC08_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2114 queue chal-00502 prefetch; R2bc pure board parent; Reason unknown until n80",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_ec08.json")
print(f"[r2-ec08] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-ec08] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-ec08] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-ec08] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_ec08.done
cp -f /root/affine_data/r2_prefetch_ec08.json /root/logs/r2_prefetch_ec08.json 2>/dev/null || true
echo "[r2-ec08] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
