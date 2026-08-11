#!/usr/bin/env bash
# Prefetch queue chal-00501 tolegend/…-ckp333 (CPU/network only).
# Hub probe p2103: ungated Qwen3_5MoeForConditionalGeneration @24c137e8…
# 16×safetensors. Cache while R2bb reload waits; do not merge.
set -euo pipefail
LOG=/root/logs/r2_prefetch_ckp333.log
DONE=/root/logs/r2_prefetch_ckp333.done
PIDF=/root/logs/r2_prefetch_ckp333.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-ckp333] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-ckp333] already done: $(cat "$DONE")"
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

REPO=${CKP333_REPO:-tolegend/Affine-5fqbxvz29b-ckp333}
REV=${CKP333_REV:-24c137e8a978aea1e2b4abeec594fb6ca943f03c}
export CKP333_REPO="$REPO" CKP333_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["CKP333_REPO"]
rev = os.environ["CKP333_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2103 queue chal-00501 prefetch; R2bb pure board parent; Reason unknown until n80",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_ckp333.json")
print(f"[r2-ckp333] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-ckp333] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-ckp333] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-ckp333] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_ckp333.done
cp -f /root/affine_data/r2_prefetch_ckp333.json /root/logs/r2_prefetch_ckp333.json 2>/dev/null || true
echo "[r2-ckp333] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
