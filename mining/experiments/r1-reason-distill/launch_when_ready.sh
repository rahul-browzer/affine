#!/usr/bin/env bash
# Wait for warm-stack PROMPTABLE + corpus, then run Reason n=80 H64 baseline.
set -euo pipefail
LOG=/root/logs/r1_launch_when_ready.log
mkdir -p /root/logs /root/affine_data
exec > >(tee -a "$LOG") 2>&1

echo "[r1-wait] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"

for i in $(seq 1 720); do
  ready=0
  corpus=0
  [[ -f /root/logs/warm_stack_ready.done ]] && ready=1
  [[ -f /root/logs/corpus.done ]] && corpus=1
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ $ready -eq 1 && $corpus -eq 1 && "$c0$c1$c2" == "200200200" ]]; then
    echo "[r1-wait] PROMPTABLE+corpus at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r1-wait] iter=$i ready=$ready corpus=$corpus codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 720 )); then
    echo "[r1-wait] TIMEOUT" >&2
    exit 2
  fi
  sleep 10
done

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi
# Fail closed: schema-v2 sim needs parquet readers before burning GPU time.
python - <<'PY'
import importlib.util as u
missing = [m for m in ("pandas", "pyarrow") if u.find_spec(m) is None]
if missing:
    raise SystemExit(f"[r1-wait] FATAL missing deps {missing} — install pandas pyarrow")
print("[r1-wait] deps ok pandas+pyarrow", flush=True)
PY
export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
export AFFINE_DATA_DIR=${AFFINE_DATA_DIR:-/root/affine_data}

OUT=/root/affine_data/r1_reason_sim.json
DEC=/root/affine_data/r1_decision.json
# Fresh slice seed each launch (not all-zero): wall-clock hex.
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r1-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r1-wait] launching n80 Reason sim block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r1-h64-$(date -u +%Y%m%dT%H%M%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo /tmp/h64_merged \
  --out "$OUT" \
  --progress-out /root/affine_data/r1_reason_progress.json \
  --save-artifact \
  2>&1 | tee /root/logs/r1_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" \
  2>&1 | tee -a /root/logs/r1_reason_sim.log

echo "[r1-wait] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
touch /root/logs/r1_reason_sim.done
