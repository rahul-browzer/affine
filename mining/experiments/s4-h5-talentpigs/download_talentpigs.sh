#!/usr/bin/env bash
# Download live king TalentPigs into pod HF cache. Run on mine-sim-1 only.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

export HF_HOME=${HF_HOME:-/root/hf}
export HF_HUB_ENABLE_HF_TRANSFER=${HF_HUB_ENABLE_HF_TRANSFER:-1}
export HF_XET_HIGH_PERFORMANCE=${HF_XET_HIGH_PERFORMANCE:-1}

export KING_REPO=${KING_REPO:-TalentPigs/affine-5ekxlcg3fx-abc}
export KING_REV=${KING_REV:-dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4}

DONE=/root/logs/h5_download.done
LOG=/root/logs/h5_download.log
mkdir -p /root/logs /root/merges
rm -f "$DONE"

echo "[h5-dl] $(date -u +%Y-%m-%dT%H:%M:%SZ) start $KING_REPO@$KING_REV" | tee -a "$LOG"

python - <<'PY'
import os, time
from huggingface_hub import snapshot_download

repo = os.environ["KING_REPO"]
rev = os.environ["KING_REV"]
t0 = time.time()
print(f"[h5-dl] fetching {repo}@{rev}", flush=True)
path = snapshot_download(repo_id=repo, revision=rev, local_files_only=False)
print(f"[h5-dl] ready path={path} elapsed={time.time()-t0:.1f}s", flush=True)
print("[h5-dl] TALENTPIGS_READY", flush=True)
PY

date -u +%Y-%m-%dT%H:%M:%SZ >"$DONE"
echo "[h5-dl] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE -> $DONE" | tee -a "$LOG"
