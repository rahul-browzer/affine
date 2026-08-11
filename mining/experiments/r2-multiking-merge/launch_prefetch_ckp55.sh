#!/usr/bin/env bash
# Prefetch queue chal-00504 nerojimmy/…-ckp55 (CPU/network only).
# Armed p2117 after R2bc UNSERVABLE (ec08 weight-init both local+HF).
set -euo pipefail
LOG=/root/logs/r2_prefetch_ckp55.log
DONE=/root/logs/r2_prefetch_ckp55.done
PIDF=/root/logs/r2_prefetch_ckp55.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-ckp55] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-ckp55] already done: $(cat "$DONE")"
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

REPO=${CKP55_REPO:-nerojimmy/Affine-5fqbxvz29b-ckp55}
REV=${CKP55_REV:-bf4d01359355df32cdcd1332a9cc587eb8835f7d}
export CKP55_REPO="$REPO" CKP55_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["CKP55_REPO"]
rev = os.environ["CKP55_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2117 queue chal-00504 prefetch; R2bd pure board parent after R2bc UNSERVABLE",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_ckp55.json")
print(f"[r2-ckp55] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-ckp55] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-ckp55] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-ckp55] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_ckp55.done
cp -f /root/affine_data/r2_prefetch_ckp55.json /root/logs/r2_prefetch_ckp55.json 2>/dev/null || true
echo "[r2-ckp55] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
