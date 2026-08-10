#!/usr/bin/env bash
# Prefetch R2c parents (CPU/network only). Safe while R1c trains + R2b α-merges.
# Evidence p1888 pure-Reason recompute vs Tok af10 (lpC_yc_za−lpC_yc_e):
#   chal-00405 Tok af16 → Reason m=+0.0049 z=+0.98 hr≈0.33× (HF download OK)
#   chal-00438 aurora prince → Reason m=+0.0023 z=+0.51 hr≈0.17× (HF download OK)
# Gated for unconst (skip; API metadata 200 ≠ weight access):
#   tojointhecommunity nvidia, diane613 cool/new
# Optional parents must not abort the DONE stamp if ≥1 OK.
set -euo pipefail
LOG=/root/logs/r2c_prefetch_parents.log
DONE=/root/logs/r2c_prefetch_parents.done
PIDF=/root/logs/r2c_prefetch_parents.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1
echo "[r2c-prefetch] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2c-prefetch] already done: $(cat "$DONE")"
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

optional = [
    ("Tok331102/affine-5EqYW8McUc-af16", "5b8faef7807f285271f1b99e17c7faaef018fd0c"),
    ("aurora1001/affine-5cwwlhucdc-prince", "1bacb3edf95ddcfce41cb1a7027b22d4eb25362a"),
]
out = {
    "started_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "note": "R2c parents; pure Reason vs Tok; nvidia/diane gated for unconst",
    "parents": [],
    "skipped": [],
}
Path("/root/affine_data").mkdir(parents=True, exist_ok=True)
meta = Path("/root/affine_data/r2c_prefetch_parents.json")

def pull(repo, rev):
    print(f"[r2c-prefetch] downloading {repo}@{rev[:12]}…", flush=True)
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
        print(f"[r2c-prefetch] SKIP {repo}: {msg}", flush=True)
        out["skipped"].append({"repo": repo, "revision": rev, "error": msg[:500]})
        meta.write_text(json.dumps(out, indent=2) + "\n")
        return
    dt = time.time() - t0
    print(f"[r2c-prefetch] OK {repo} -> {path} ({dt/60:.1f} min)", flush=True)
    out["parents"].append(
        {"repo": repo, "revision": rev, "path": path, "seconds": round(dt, 1)}
    )
    meta.write_text(json.dumps(out, indent=2) + "\n")

for repo, rev in optional:
    pull(repo, rev)
out["finished_at"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
meta.write_text(json.dumps(out, indent=2) + "\n")
if not out["parents"]:
    raise SystemExit("no R2c parents downloaded")
print("[r2c-prefetch] cached ≥1 parent", flush=True)
PY

NOK=$(python -c 'import json;print(len(json.load(open("/root/affine_data/r2c_prefetch_parents.json")).get("parents",[])))')
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) n_ok=$NOK" >"$DONE"
echo "[r2c-prefetch] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
