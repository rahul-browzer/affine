#!/usr/bin/env bash
# Prefetch reign parents for R2 multi-king merge (CPU/network only; no GPU).
# Safe to run while R1b trains on GPUs 6–7.
set -euo pipefail
LOG=/root/logs/r2_prefetch_parents.log
DONE=/root/logs/r2_prefetch_parents.done
mkdir -p /root/logs /root/r2_out
exec > >(tee -a "$LOG") 2>&1
echo "[r2-prefetch] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-prefetch] already done: $(cat "$DONE")"
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

# Live reign parents (snapshot 2026-08-10) excluding current king Tok af10 (already cached).
PARENTS=(
  "TalentPigs/affine-5ekxlcg3fx-abc@dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4"
  "kevin954/Affine-5dfqbbh8ev-sft@6a5815fad8f4e34c983b1933c1fae5762fe25220"
)

meta=/root/affine_data/r2_prefetch_parents.json
python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

parents = [
    ("TalentPigs/affine-5ekxlcg3fx-abc", "dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4"),
    ("kevin954/Affine-5dfqbbh8ev-sft", "6a5815fad8f4e34c983b1933c1fae5762fe25220"),
]
out = {"started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()), "parents": []}
Path("/root/affine_data").mkdir(parents=True, exist_ok=True)
for repo, rev in parents:
    print(f"[r2-prefetch] downloading {repo}@{rev[:12]}…", flush=True)
    t0 = time.time()
    path = snapshot_download(
        repo_id=repo,
        revision=rev,
        token=os.environ.get("HF_TOKEN"),
        max_workers=8,
    )
    dt = time.time() - t0
    print(f"[r2-prefetch] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
    out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
    Path("/root/affine_data/r2_prefetch_parents.json").write_text(json.dumps(out, indent=2) + "\n")
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
Path("/root/affine_data/r2_prefetch_parents.json").write_text(json.dumps(out, indent=2) + "\n")
print("[r2-prefetch] all parents cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" > "$DONE"
echo "[r2-prefetch] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
