#!/usr/bin/env bash
# Prefetch queue chal-00516 IntoLayer/Affine-5g94ihdxwu-v1 (CPU/network only).
# Armed p2138 while R2bg cp1266 n80 runs — next pure board parent.
set -euo pipefail
LOG=/root/logs/r2_prefetch_intolayer_v1.log
DONE=/root/logs/r2_prefetch_intolayer_v1.done
PIDF=/root/logs/r2_prefetch_intolayer_v1.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-intolayer] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-intolayer] already done: $(cat "$DONE")"
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

REPO=${INTOLAYER_REPO:-IntoLayer/Affine-5g94ihdxwu-v1}
REV=${INTOLAYER_REV:-9b6bc52c8aee3ebbeb409f34114ef343c9a0d0b7}
export INTOLAYER_REPO="$REPO" INTOLAYER_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["INTOLAYER_REPO"]
rev = os.environ["INTOLAYER_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2138 queue chal-00516 prefetch; R2bh pure board parent after R2bg",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_intolayer_v1.json")
print(f"[r2-intolayer] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-intolayer] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-intolayer] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-intolayer] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_intolayer_v1.done
cp -f /root/affine_data/r2_prefetch_intolayer_v1.json /root/logs/r2_prefetch_intolayer_v1.json 2>/dev/null || true
echo "[r2-intolayer] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
