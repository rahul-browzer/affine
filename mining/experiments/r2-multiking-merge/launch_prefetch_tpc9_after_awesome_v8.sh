#!/usr/bin/env bash
# Prefetch queue chal-00463 llorite/…-tpc9 after awesome-v8 DONE (one-at-a-time).
# Index probe (p1953): weights_ok @dba3b6f31b30… (4 safetensors, ~70.2 GiB).
# CPU/network only. Do not merge until post-verdict Reason+.
set -euo pipefail
LOG=/root/logs/r2_prefetch_tpc9.log
DONE=/root/logs/r2_prefetch_tpc9.done
PIDF=/root/logs/r2_prefetch_tpc9.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-tpc9] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-tpc9] already done: $(cat "$DONE")"
  exit 0
fi

PRIOR=/root/logs/r2_prefetch_awesome_v8.done
echo "[r2-tpc9] waiting for $PRIOR"
for i in $(seq 1 720); do
  if [[ -f "$PRIOR" ]]; then
    echo "[r2-tpc9] prior ready: $(cat "$PRIOR")"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2-tpc9] wait-prior iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  fi
  sleep 10
  if (( i == 720 )); then
    echo "[r2-tpc9] TIMEOUT waiting for awesome-v8 prefetch"
    exit 2
  fi
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

REPO=${TPC9_REPO:-llorite/affine-5cjfxpsxn8-tpc9}
REV=${TPC9_REV:-dba3b6f31b3078cda332434b962c8343ea2aa7d4}
export TPC9_REPO="$REPO" TPC9_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["TPC9_REPO"]
rev = os.environ["TPC9_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p1953 queue chal-00463 prefetch after awesome-v8; Reason unknown until verdict",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_tpc9.json")
print(f"[r2-tpc9] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-tpc9] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-tpc9] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-tpc9] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_tpc9.done
cp -f /root/affine_data/r2_prefetch_tpc9.json /root/logs/r2_prefetch_tpc9.json 2>/dev/null || true
echo "[r2-tpc9] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
