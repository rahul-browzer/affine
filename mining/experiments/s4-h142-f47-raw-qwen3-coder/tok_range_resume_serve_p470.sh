#!/usr/bin/env bash
# Pass 470: Range-resume frozen Tok king shards on mine-f47-1, then serve_three + n80 path.
# huggingface_hub≥1.27 never resumes .incomplete (opens fresh "wb"); use HTTP Range.
set -euo pipefail

LOG=/root/logs/h142_tok_range_p470.nohup
mkdir -p /root/logs
exec > >(tee -a "$LOG") 2>&1
log() { echo "[p470-range] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export HF_HOME=${HF_HOME:-/root/hf}
export HF_TOKEN
# shellcheck disable=SC1091
source /root/venv/bin/activate

REPO=Tok331102/affine-5EqYW8McUc-af10
REV=eb8bf9a356a254f71faaa439e8abc3cfba572c53
BLOB_DIR=/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/blobs
SNAP=/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/${REV}
DONE=/root/logs/tok331102.done

# lfs_sha256 → filename, expected size
declare -A FNAME=(
  [3e0bd3310b597a826ed50503e7bcfa7d019462a15c335adbaac082c3a4cbb582]=model-00001-of-00002.safetensors
  [da0b5fc3bc074ae0cda8599d4e1b96cfed5817518b87f82dc18393398123d9aa]=model-00002-of-00002.safetensors
)
declare -A EXPECT=(
  [3e0bd3310b597a826ed50503e7bcfa7d019462a15c335adbaac082c3a4cbb582]=35101763136
  [da0b5fc3bc074ae0cda8599d4e1b96cfed5817518b87f82dc18393398123d9aa]=35112732728
)

log "START kill hung snapshot_download if any"
# Kill only the bootstrap python child holding Tok incompletes — not unrelated pythons.
for pid in $(pgrep -f 'bash /root/mining_src/s4-h142-f47-raw-qwen3-coder/bootstrap_h142.sh' || true); do
  # children
  for c in $(pgrep -P "$pid" || true); do
    cmd=$(tr '\0' ' ' <"/proc/$c/cmdline" 2>/dev/null || true)
    if [[ "$cmd" == python* ]]; then
      log "kill bootstrap python pid=$c"
      kill "$c" 2>/dev/null || true
    fi
  done
  log "kill bootstrap bash pid=$pid (set -e already exiting)"
  kill "$pid" 2>/dev/null || true
done
sleep 2

# Adopt hub uuid incompletes → {sha}.range.incomplete
for sha in "${!FNAME[@]}"; do
  final="$BLOB_DIR/$sha"
  range_inc="$BLOB_DIR/${sha}.range.incomplete"
  if [[ -f "$final" ]]; then
    sz=$(stat -c%s "$final")
    exp=${EXPECT[$sha]}
    if (( sz >= exp )); then
      log "blob $sha already complete sz=$sz"
      continue
    fi
  fi
  # largest matching uuid incomplete for this sha
  best=$(ls -1 "$BLOB_DIR/${sha}".*.incomplete 2>/dev/null | while read -r f; do
    # skip our own range file
    [[ "$f" == *.range.incomplete ]] && continue
    echo "$(stat -c%s "$f") $f"
  done | sort -nr | head -1 | awk '{print $2}')
  if [[ -n "${best:-}" && -f "$best" ]]; then
    if [[ -f "$range_inc" ]]; then
      bsz=$(stat -c%s "$best")
      rsz=$(stat -c%s "$range_inc")
      if (( bsz > rsz )); then
        log "adopt hub incomplete $best ($bsz) over range ($rsz)"
        mv -f "$best" "$range_inc"
      else
        log "keep range incomplete ($rsz) ≥ hub ($bsz); rm hub"
        rm -f "$best"
      fi
    else
      log "adopt hub incomplete → range: $best"
      mv -f "$best" "$range_inc"
    fi
  fi
  # drop other uuid incompletes for this sha
  for f in "$BLOB_DIR/${sha}".*.incomplete; do
    [[ -f "$f" ]] || continue
    [[ "$f" == "$range_inc" ]] && continue
    log "rm leftover $f"
    rm -f "$f"
  done
done

log "Range-resume both shards (parallel)"
python3 - <<'PY'
import os, sys, time, threading
from pathlib import Path
import urllib.request

token = os.environ["HF_TOKEN"]
repo = "Tok331102/affine-5EqYW8McUc-af10"
rev = "eb8bf9a356a254f71faaa439e8abc3cfba572c53"
blob_dir = Path("/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/blobs")
snap = Path(f"/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/{rev}")

shards = [
    ("3e0bd3310b597a826ed50503e7bcfa7d019462a15c335adbaac082c3a4cbb582",
     "model-00001-of-00002.safetensors", 35101763136),
    ("da0b5fc3bc074ae0cda8599d4e1b96cfed5817518b87f82dc18393398123d9aa",
     "model-00002-of-00002.safetensors", 35112732728),
]

errors = []

def resume(sha, fname, expect):
    final = blob_dir / sha
    inc = blob_dir / f"{sha}.range.incomplete"
    url = f"https://huggingface.co/{repo}/resolve/{rev}/{fname}"
    if final.is_file() and final.stat().st_size >= expect:
        print(f"[p470-range] SKIP {fname} already final {final.stat().st_size}", flush=True)
        return
    have = inc.stat().st_size if inc.is_file() else 0
    if have >= expect:
        print(f"[p470-range] finalize {fname} have={have}", flush=True)
        inc.replace(final)
        return
    print(f"[p470-range] RESUME {fname} have={have}/{expect} ({100*have/expect:.1f}%)", flush=True)
    headers = {
        "Authorization": f"Bearer {token}",
        "User-Agent": "affine-mine-p470-range/1.0",
    }
    if have > 0:
        headers["Range"] = f"bytes={have}-"
    req = urllib.request.Request(url, headers=headers)
    # follow redirects manually to preserve Range on CDN
    opener = urllib.request.build_opener(urllib.request.HTTPRedirectHandler)
    try:
        resp = opener.open(req, timeout=600)
    except Exception as e:
        # some CDNs 416 if have==size; treat as done
        errors.append((fname, e))
        print(f"[p470-range] ERROR open {fname}: {e}", flush=True)
        return
    code = getattr(resp, "status", None) or resp.getcode()
    print(f"[p470-range] HTTP {code} {fname}", flush=True)
    mode = "ab" if have > 0 and code == 206 else "wb"
    if mode == "wb" and have > 0 and code == 200:
        print(f"[p470-range] WARN server ignored Range (200); restarting from 0 for {fname}", flush=True)
        have = 0
    wrote = 0
    t0 = time.time()
    last_log = t0
    with open(inc if mode == "ab" or have == 0 else inc, mode) as out:
        if mode == "wb":
            pass  # truncated
        while True:
            chunk = resp.read(8 * 1024 * 1024)
            if not chunk:
                break
            out.write(chunk)
            wrote += len(chunk)
            now = time.time()
            if now - last_log >= 30:
                cur = inc.stat().st_size
                rate = wrote / max(now - t0, 1) / 1e6
                print(f"[p470-range] {fname} now={cur}/{expect} ({100*cur/expect:.1f}%) +{wrote/1e9:.2f}GB @{rate:.1f} MB/s", flush=True)
                last_log = now
    cur = inc.stat().st_size
    if cur < expect:
        errors.append((fname, f"short file {cur}<{expect}"))
        print(f"[p470-range] SHORT {fname} {cur}<{expect}", flush=True)
        return
    inc.replace(final)
    print(f"[p470-range] DONE {fname} -> {final} sz={final.stat().st_size}", flush=True)

threads = [threading.Thread(target=resume, args=s, daemon=True) for s in shards]
for t in threads:
    t.start()
for t in threads:
    t.join()

if errors:
    print("[p470-range] FAILURES:", errors, flush=True)
    sys.exit(1)

# symlink into snapshot
for sha, fname, expect in shards:
    final = blob_dir / sha
    assert final.is_file() and final.stat().st_size >= expect, (fname, final)
    link = snap / fname
    if link.is_symlink() or link.exists():
        link.unlink()
    link.symlink_to(f"../../blobs/{sha}")
    print(f"[p470-range] link {fname} -> blobs/{sha}", flush=True)

done = Path("/root/logs/tok331102.done")
done.write_text(str(snap) + "\n")
print(f"[p470-range] stamped {done}", flush=True)
PY

log "sync_corpus + serve_three"
bash /root/mining_src/s3-duel-sim/sync_corpus.sh || true

export TEACHER_REPO=zai-org/GLM-4.5-Air-FP8
export KING_REPO=Tok331102/affine-5EqYW8McUc-af10
export KING_REV=eb8bf9a356a254f71faaa439e8abc3cfba572c53
export CHALL_REPO=/root/h142/chall
export CHALL_REV=
export CHALL_GPUUTIL=0.72
export GPUUTIL=0.72
bash /root/mining_src/s3-duel-sim/serve_three.sh

for i in $(seq 1 360); do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  kcode=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  tcode=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  if (( i % 12 == 0 )); then
    log "serve poll=$i teacher=$tcode king=$kcode chall=$code"
  fi
  if [[ "$code" == "200" && "$kcode" == "200" && "$tcode" == "200" ]]; then
    echo "chall_serve_ok poll=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee /root/logs/h142_chall_serve.done
    break
  fi
  sleep 15
done
test -f /root/logs/h142_chall_serve.done

# Clear stale n80 abort so watch_n80_retry can fire
rm -f /root/logs/h142_n80_retry.aborted /root/affine_data/h142_N80_DONE /root/logs/h142_N80_DONE 2>/dev/null || true
touch /root/logs/bootstrap_h142.done
log "DONE — engines up; n80 watcher owns screen"
