#!/usr/bin/env bash
# Prefetch queue chal-00458 marsplan0624/…-whoami (CPU/network only).
# Index probe (p1930): ungated weights_ok @21ad45721ab2… (16 safetensors).
# Repo id shares 5gedzafcvg with gated diane-new (hr≈0.54×) — downloadable
# proxy for that lineage. No Reason verdict yet; cache so post-verdict Reason+
# can merge without idle download after R2i…R2q.
set -euo pipefail
LOG=/root/logs/r2_prefetch_whoami.log
DONE=/root/logs/r2_prefetch_whoami.done
PIDF=/root/logs/r2_prefetch_whoami.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2-whoami] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2-whoami] already done: $(cat "$DONE")"
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

REPO=${WHOAMI_REPO:-marsplan0624/affine-5gedzafcvg-whoami}
REV=${WHOAMI_REV:-21ad45721ab242a6aa0c18d00104045627d68583}
export WHOAMI_REPO="$REPO" WHOAMI_REV="$REV"

python - <<'PY'
import json, os, time
from pathlib import Path
from huggingface_hub import snapshot_download

repo = os.environ["WHOAMI_REPO"]
rev = os.environ["WHOAMI_REV"]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "p1930 queue chal-00458 prefetch; diane-new lineage id 5gedzafcvg; Reason unknown until verdict",
    "parents": [],
    "skipped": [],
}
meta = Path("/root/affine_data/r2_prefetch_whoami.json")
print(f"[r2-whoami] downloading {repo}@{rev}…", flush=True)
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
    print(f"[r2-whoami] FAIL {repo}: {msg}", flush=True)
    out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
    meta.write_text(json.dumps(out, indent=2) + "\n")
    raise
dt = time.time() - t0
print(f"[r2-whoami] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
out["parents"].append({"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)})
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
print("[r2-whoami] cached", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) $REPO@$REV" >"$DONE"
cp -f "$DONE" /root/affine_data/r2_prefetch_whoami.done
cp -f /root/affine_data/r2_prefetch_whoami.json /root/logs/r2_prefetch_whoami.json 2>/dev/null || true
echo "[r2-whoami] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
