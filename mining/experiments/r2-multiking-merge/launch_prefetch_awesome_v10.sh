#!/usr/bin/env bash
# Prefetch queue chal-00498 0pentensor/…-awesome-v10 (CPU/network only).
# Hub probe p2067: ungated Qwen3_5MoeForConditionalGeneration @07bc3392…
# 16×safetensors ≈70.2 GiB. Cache while R2ax/ay/az chain runs; do not merge
# until post-verdict Reason+ or pure n80 decision.
set -euo pipefail
LOG=/root/logs/r2_prefetch_awesome_v10.log
DONE=/root/logs/r2_prefetch_awesome_v10.done
PIDF=/root/logs/r2_prefetch_awesome_v10.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-awesome-v10] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-awesome-v10] already done: $(cat "$DONE")"
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

REPO=${AWESOME_V10_REPO:-0pentensor/Affine-5dflhtkufw-awesome-v10}
REV=${AWESOME_V10_REV:-07bc3392cfb9616c1284adc0ab939888a0f58715}
export AWESOME_V10_REPO="$REPO" AWESOME_V10_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["AWESOME_V10_REPO"]
rev = os.environ["AWESOME_V10_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2067 queue chal-00498 prefetch; awesome-v9 lineage next; Reason unknown until verdict",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_awesome_v10.json")
print(f"[r2-awesome-v10] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-awesome-v10] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-awesome-v10] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-awesome-v10] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_awesome_v10.done
cp -f /root/affine_data/r2_prefetch_awesome_v10.json /root/logs/r2_prefetch_awesome_v10.json 2>/dev/null || true
echo "[r2-awesome-v10] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
