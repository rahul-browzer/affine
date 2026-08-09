#!/usr/bin/env bash
set -euo pipefail
LOG=/root/logs/h106_extra_dl_p415.nohup
exec > >(tee -a "$LOG") 2>&1
echo "[p415] $(date -u +%Y-%m-%dT%H:%M:%SZ) start corrected teacher+king DL"
set -a
source /root/mine.env
set +a
source /root/venv/bin/activate
export HF_HOME=/root/hf HF_TOKEN
python - <<'PY'
import os
from huggingface_hub import snapshot_download
token = os.environ["HF_TOKEN"]
print("[p415] DOWNLOAD teacher start", flush=True)
path = snapshot_download("zai-org/GLM-4.5-Air-FP8", token=token)
print(f"[p415] DOWNLOAD teacher done -> {path}", flush=True)
open("/root/logs/teacher.done", "w").write(path + "\n")
repo = "Tok331102/affine-5EqYW8McUc-af10"
rev = "eb8bf9a356a254f71faaa439e8abc3cfba572c53"
print("[p415] DOWNLOAD tok king start", repo, rev, flush=True)
kpath = snapshot_download(repo, revision=rev, token=token)
print(f"[p415] DOWNLOAD tok king done -> {kpath}", flush=True)
assert "af10" in kpath, kpath
open("/root/logs/tok331102.done", "w").write(kpath + "\n")
PY
bash /root/mining_src/s3-duel-sim/sync_corpus.sh || true
echo "[p415] EXTRA_DL_OK $(date -u +%Y-%m-%dT%H:%M:%SZ)"
