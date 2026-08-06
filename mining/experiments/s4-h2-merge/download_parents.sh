#!/usr/bin/env bash
# Download H2 parent weights into pod HF cache. Run on mine-sim-1 only.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

export HF_HOME=${HF_HOME:-/root/hf}
# Standard hub layout is $HF_HOME/hub/models--*. Do NOT pass cache_dir=$HF_HOME
# to snapshot_download — that lands files at $HF_HOME/models--* and breaks
# merge_linear / vLLM paths that expect the hub/ prefix.
export HF_HUB_ENABLE_HF_TRANSFER=${HF_HUB_ENABLE_HF_TRANSFER:-1}
export HF_XET_HIGH_PERFORMANCE=${HF_XET_HIGH_PERFORMANCE:-1}

export KEVIN_REPO=${KEVIN_REPO:-kevin954/Affine-5dfqbbh8ev-sft}
export KEVIN_REV=${KEVIN_REV:-6a5815fad8f4e34c983b1933c1fae5762fe25220}
export PANDORA_REPO=${PANDORA_REPO:-pandora-box/Affine-5eqdtdzqle-ckpt300-m4}
export PANDORA_REV=${PANDORA_REV:-5218b1383952ff7a8d49b1d7b82acfe5e1bd448d}

DONE=/root/logs/h2_download.done
LOG=/root/logs/h2_download.log
mkdir -p /root/logs /root/merges
rm -f "$DONE"

echo "[h2-dl] $(date -u +%Y-%m-%dT%H:%M:%SZ) start kevin=$KEVIN_REPO@$KEVIN_REV pandora=$PANDORA_REPO@$PANDORA_REV" | tee -a "$LOG"

python - <<'PY'
import os, time
from huggingface_hub import snapshot_download

# Rely on HF_HOME → $HF_HOME/hub/… (do not set cache_dir).
pairs = [
    (os.environ["KEVIN_REPO"], os.environ["KEVIN_REV"], "kevin"),
    (os.environ["PANDORA_REPO"], os.environ["PANDORA_REV"], "pandora"),
]
for repo, rev, label in pairs:
    t0 = time.time()
    print(f"[h2-dl] fetching {label} {repo}@{rev}", flush=True)
    path = snapshot_download(
        repo_id=repo,
        revision=rev,
        local_files_only=False,
    )
    print(f"[h2-dl] {label} ready path={path} elapsed={time.time()-t0:.1f}s", flush=True)
print("[h2-dl] ALL_PARENTS_READY", flush=True)
PY

date -u +%Y-%m-%dT%H:%M:%SZ >"$DONE"
echo "[h2-dl] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE -> $DONE" | tee -a "$LOG"
