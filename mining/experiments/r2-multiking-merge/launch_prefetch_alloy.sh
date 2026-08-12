#!/usr/bin/env bash
# Prefetch queue chal-00525 athena2634/Affine-5h3msswruf-alloy (CPU/network only).
# Armed p2179 while R9 trains; R2bn pure screen vs ckp333.
# Note: Hub lacks preprocessor_config.json — derive from processor_config.json (Tok pattern).
set -euo pipefail
LOG=/root/logs/r2_prefetch_alloy.log
DONE=/root/logs/r2_prefetch_alloy.done
PIDF=/root/logs/r2_prefetch_alloy.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-alloy] $(date -u +%Y-%m-%dT%H:%M:%SZ) start p2179"
if [[ -f "$DONE" ]]; then
  echo "[r2-alloy] already done: $(cat "$DONE")"
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

REPO=${ALLOY_REPO:-athena2634/Affine-5h3msswruf-alloy}
REV=${ALLOY_REV:-74a6ac4d57beda2a9dff604c0d9799959aa676dc}
export ALLOY_REPO="$REPO" ALLOY_REV="$REV"

python - <<'PY'
import json, os, shutil, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["ALLOY_REPO"]
rev = os.environ["ALLOY_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2179 queue chal-00525 prefetch; R2bn pure athena alloy vs ckp333",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_alloy.json")
print(f"[r2-alloy] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-alloy] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-alloy] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
root = Path(path)
pre = root / "preprocessor_config.json"
proc = root / "processor_config.json"
derived = False
if not pre.exists() and proc.exists():
    shutil.copyfile(proc, pre)
    derived = True
    print("[r2-alloy] derived preprocessor_config.json from processor_config.json", flush=True)
out["parents"].append(
    {
        "repo": repo,
        "revision": rev,
        "path": path,
        "seconds": round(dt, 1),
        "preprocessor_derived": derived,
    }
)
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-alloy] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_alloy.done
cp -f /root/affine_data/r2_prefetch_alloy.json /root/logs/r2_prefetch_alloy.json 2>/dev/null || true
echo "[r2-alloy] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
