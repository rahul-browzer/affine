#!/usr/bin/env bash
# Prefetch queue chal-00495 syntaxsorcerer1/…-sft4 (CPU/network only).
# p2041: cache while R2aq n80 gathers; pure-parent screen after R2at hope11 lane.
# No GPU. No chall kill.
set -euo pipefail
LOG=/root/logs/r2_prefetch_sft4.log
DONE=/root/logs/r2_prefetch_sft4.done
PIDF=/root/logs/r2_prefetch_sft4.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-sft4] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-sft4] already done: $(cat "$DONE")"
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

REPO=${SFT4_REPO:-syntaxsorcerer1/Affine-5gbhwtw4zo-sft4}
REV=${SFT4_REV:-df83346c5a1f46d5d63d9d6ccf84ad82e356066b}
export SFT4_REPO="$REPO" SFT4_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["SFT4_REPO"]
rev = os.environ["SFT4_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p2041 queue chal-00495 prefetch; after hope11/R2at; Reason unknown until verdict",
    "challenge_id": "chal-00495",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_sft4.json")
print(f"[r2-sft4] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-sft4] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-sft4] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-sft4] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_sft4.done
cp -f /root/affine_data/r2_prefetch_sft4.json /root/logs/r2_prefetch_sft4.json 2>/dev/null || true
echo "[r2-sft4] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
