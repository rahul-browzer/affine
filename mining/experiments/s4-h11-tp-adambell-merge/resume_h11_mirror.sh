#!/usr/bin/env bash
# Resume H11 after adambell/Affine-5dvha3y7cd-ckpt450-H6 404'd.
# Uses public mirror 0pentensor/5dvha3y7cd-ckpt450-H6 @ same rev af20efc1…
# TalentPigs already on disk. Do NOT edit while live.
set -euo pipefail

LOG=/root/logs/bootstrap_h11.log
mkdir -p /root/logs /root/hf /root/affine_data /root/merges
exec >>"$LOG" 2>&1

echo "[bootstrap-h11] $(date -u +%Y-%m-%dT%H:%M:%SZ) RESUME via 0pentensor mirror"

if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export HF_HOME=${HF_HOME:-/root/hf}
export HF_HUB_ENABLE_HF_TRANSFER=${HF_HUB_ENABLE_HF_TRANSFER:-1}
export HF_XET_HIGH_PERFORMANCE=${HF_XET_HIGH_PERFORMANCE:-1}
export PATH="$HOME/.local/bin:$PATH"
export HF_TOKEN
# shellcheck disable=SC1091
source /root/venv/bin/activate

B_REPO=0pentensor/5dvha3y7cd-ckpt450-H6
B_REV=af20efc1f06ba8ae15f26c03d005c0836039c103

python - <<PY
import os
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
jobs = [
    ("TalentPigs/affine-5ekxlcg3fx-abc",
     "dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4", "talentpigs"),
    ("$B_REPO", "$B_REV", "adambell"),
    ("zai-org/GLM-4.5-Air-FP8", None, "teacher"),
]
for repo, rev, label in jobs:
    done = f"/root/logs/{label}.done"
    if label != "adambell" and os.path.isfile(done):
        print(f"[bootstrap-h11] SKIP {label} (have {done})", flush=True)
        continue
    print(f"[bootstrap-h11] DOWNLOAD start {label} {repo} rev={rev}", flush=True)
    path = snapshot_download(repo, revision=rev, token=token)
    print(f"[bootstrap-h11] DOWNLOAD done {label} -> {path}", flush=True)
    open(done, "w").write(path + "\n")
print("[bootstrap-h11] ALL_DOWNLOADS_OK", flush=True)
PY

export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
bash /root/mining_src/s3-duel-sim/sync_corpus.sh

ALPHA=0.75
OUT=/root/merges/h11-tp75
rm -rf "$OUT"
python /root/mining_src/s4-h2-merge/merge_linear.py \
  --a-repo TalentPigs/affine-5ekxlcg3fx-abc \
  --a-rev dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4 \
  --b-repo "$B_REPO" \
  --b-rev "$B_REV" \
  --alpha "$ALPHA" \
  --out "$OUT" \
  --hf-home "$HF_HOME" \
  2>&1 | tee /root/logs/h11_merge.log

date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h11_merge.done
echo "[bootstrap-h11] MERGE_DONE alpha=$ALPHA out=$OUT b=$B_REPO@$B_REV"

export TEACHER_REPO=zai-org/GLM-4.5-Air-FP8
export TEACHER_REV=
export KING_REPO=TalentPigs/affine-5ekxlcg3fx-abc
export KING_REV=dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4
export CHALL_REPO=/root/merges/h11-tp75
export CHALL_REV=
bash /root/mining_src/s3-duel-sim/serve_three.sh

touch /root/logs/bootstrap_h11.done
echo "[bootstrap-h11] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE — engines launching; next: wait_ready + n80"
