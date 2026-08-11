#!/usr/bin/env bash
# Prefetch queue chal-00450 syntaxsorcerer1/…-sft3 (CPU/network only).
# Index probe (p1916): weights_ok for unconst @381dbc82… (2 safetensors, ~65–70 GiB).
# No Reason verdict yet — cache now so a post-verdict Reason+ parent can merge
# without an idle download after R2g / R2i / BKN resolve.
set -euo pipefail
LOG=/root/logs/r2_prefetch_sft3.log
DONE=/root/logs/r2_prefetch_sft3.done
PIDF=/root/logs/r2_prefetch_sft3.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-sft3] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-sft3] already done: $(cat "$DONE")"
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

REPO=${SFT3_REPO:-syntaxsorcerer1/Affine-5gbhwtw4zo-sft3}
REV=${SFT3_REV:-381dbc8245e29bccbf39de78fdbc20acbfadec8d}
export SFT3_REPO="$REPO" SFT3_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["SFT3_REPO"]
rev = os.environ["SFT3_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p1916 queue chal-00450 prefetch while R2g n80; Reason unknown until verdict",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_sft3.json")
print(f"[r2-sft3] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-sft3] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-sft3] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-sft3] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_sft3.done
cp -f /root/affine_data/r2_prefetch_sft3.json /root/logs/r2_prefetch_sft3.json 2>/dev/null || true
echo "[r2-sft3] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
