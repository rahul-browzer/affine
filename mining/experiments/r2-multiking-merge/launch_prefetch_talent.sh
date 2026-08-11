#!/usr/bin/env bash
# Prefetch TalentPigs reign-3 parent @dbfbb3e2… (CPU/network only).
# Fresh mine-crown-1 lost /root/hf parents; pure sky/google/pig lanes do not
# need Talent, but R2ab/ac/ad Talent×board skews do. Safe during board-wait.
set -euo pipefail
LOG=/root/logs/r2_prefetch_talent.log
DONE=/root/logs/r2_prefetch_talent.done
PIDF=/root/logs/r2_prefetch_talent.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-talent] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-talent] already done: $(cat "$DONE")"
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

REPO=${TALENT_REPO:-TalentPigs/affine-5ekxlcg3fx-abc}
REV=${TALENT_REV:-dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4}
export TALENT_REPO="$REPO" TALENT_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["TALENT_REPO"]
rev = os.environ["TALENT_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2002 prefetch Talent reign-3 for R2ab/ac/ad after fresh crown restore",
    "parents": [],
}
meta = Path("/root/affine_data/r2_prefetch_talent.json")
print(f"[r2-talent] downloading {repo}@{rev}…", flush=True)
t0 = time.time()
path = snapshot_download(
    repo_id=repo,
    revision=rev,
    token=os.environ.get("HF_TOKEN"),
    max_workers=8,
)
dt = time.time() - t0
print(f"[r2-talent] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) ${REPO}@${REV}" > "$DONE"
echo "[r2-talent] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
