#!/usr/bin/env bash
# Prefetch magicworld7/…-sky @a569e29b… (CPU/network; 2×safetensors ~smaller).
# Live board chal-00469. Wait warm_stack_ready so we do not steal HF bandwidth
# from teacher/king/h64 restore on the fresh crown pod.
set -euo pipefail
LOG=/root/logs/r2_prefetch_sky.log
DONE=/root/logs/r2_prefetch_sky.done
PIDF=/root/logs/r2_prefetch_sky.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-sky] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-sky] already done: $(cat "$DONE")"
  exit 0
fi

WARM=${WARM_DONE:-/root/logs/warm_stack_ready.done}
echo "[r2-sky] waiting for $WARM (avoid contending restore HF DL)"
for i in $(seq 1 2880); do
  if [[ -f "$WARM" ]]; then
    echo "[r2-sky] warm stack ready at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2-sky] wait-warm iter=$i"
  fi
  if (( i == 2880 )); then
    echo "[r2-sky] TIMEOUT waiting warm_stack_ready" >&2
    exit 2
  fi
  sleep 10
done

set -a
# shellcheck disable=SC1091
source /root/mine.env
set +a
# shellcheck disable=SC1091
source /root/venv/bin/activate
export HF_HOME=${HF_HOME:-/root/hf}
export HF_HUB_ENABLE_HF_TRANSFER=${HF_HUB_ENABLE_HF_TRANSFER:-1}
export HF_XET_HIGH_PERFORMANCE=${HF_XET_HIGH_PERFORMANCE:-1}

REPO=${SKY_REPO:-magicworld7/affine-5dtu4gucst-sky}
REV=${SKY_REV:-a569e29bcab3a1f4ed3a99ee9e46c17dc40e8fdf}
export SKY_REPO="$REPO" SKY_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["SKY_REPO"]
rev = os.environ["SKY_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p1996 prefetch sky for R2aj pure-parent n80 after warm-stack restore",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_sky.json")
print(f"[r2-sky] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-sky] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-sky] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-sky] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_sky.done
cp -f /root/affine_data/r2_prefetch_sky.json /root/logs/r2_prefetch_sky.json 2>/dev/null || true
echo "[r2-sky] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
