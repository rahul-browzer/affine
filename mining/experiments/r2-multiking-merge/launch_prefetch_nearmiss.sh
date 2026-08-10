#!/usr/bin/env bash
# Prefetch best pure-Reason near-miss vs Tok af10 (CPU/network only; no GPU).
# Safe while R1c trains on GPUs 6–7 and TK engines hold 0–5.
# Evidence (p1885 recompute from pair lpC fields, not published S* margin):
#   chal-00425 0pentensor awesome-v6 → Reason margin +0.0108, z=+2.75, hr≈0.92×
set -euo pipefail
LOG=/root/logs/r2_prefetch_nearmiss.log
DONE=/root/logs/r2_prefetch_nearmiss.done
PIDF=/root/logs/r2_prefetch_nearmiss.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-nearmiss] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-nearmiss] already done: $(cat "$DONE")"
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

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

# Ranked by recomputed Reason headroom vs Tok af10 (p1885).
parents = [
    ("0pentensor/Affine-5dflhtkufw-awesome-v6", "f479a24d452f1ca312d828acd668a4b1d8de0d8f"),
    ("diane613/affine-5gedzafcvg-cool", "d31a456f0fbf2bac40a66d32823ec57b3201a815"),
]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "pure Reason recompute; chal-00425 hr≈0.92×; chal-00415 hr≈0.64×",
    "parents": [],
}
Path("/root/affine_data").mkdir(parents=True, exist_ok=True)
meta = Path("/root/affine_data/r2_prefetch_nearmiss.json")
for repo, rev in parents:
    print(f"[r2-nearmiss] downloading {repo}@{rev[:12]}…", flush=True)
    t0 = time.time()
    path = snapshot_download(
        repo_id=repo,
        revision=rev,
        token=os.environ.get("HF_TOKEN"),
        max_workers=8,
    )
    dt = time.time() - t0
    print(f"[r2-nearmiss] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
    out["parents"].append(
        {"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)}
    )
    meta.write_text(json.dumps(out, indent=2) + "\n")
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-nearmiss] all parents cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
echo "[r2-nearmiss] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
