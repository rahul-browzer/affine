#!/usr/bin/env bash
# Sync public turn corpus onto the pod (anonymous, fail-closed).
# Safe to run while HF model downloads continue.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
export AFFINE_DATA_DIR=${AFFINE_DATA_DIR:-/root/affine_data}
mkdir -p "$AFFINE_DATA_DIR" /root/logs

# Concurrent syncers (extra_dl + prewarm) can race on turns.jsonl.tmp→turns.jsonl
# rename (ENOENT). Use flock; if sync still fails but a non-empty turns.jsonl
# already exists, adopt it rather than aborting the whole prewarm.
LOCK=${AFFINE_DATA_DIR}/.corpus_sync.lock
exec 9>"$LOCK"
if ! flock -w 600 9; then
  echo "[corpus] FATAL: could not acquire $LOCK" >&2
  exit 1
fi

echo "[corpus] $(date -u +%Y-%m-%dT%H:%M:%SZ) sync start"
set +e
python -m evalsrv.corpus --sync 2>&1 | tee /root/logs/corpus_sync.log
rc=${PIPESTATUS[0]}
set -e
if [[ $rc -ne 0 ]]; then
  if [[ -s "$AFFINE_DATA_DIR/turns_index.parquet" ]]; then
    echo "[corpus] WARN sync rc=$rc but adopting existing turns_index.parquet (schema v2)"
  elif [[ -s "$AFFINE_DATA_DIR/turns.jsonl" ]]; then
    n=$(wc -l < "$AFFINE_DATA_DIR/turns.jsonl")
    echo "[corpus] WARN sync rc=$rc but adopting existing turns.jsonl lines=$n"
  else
    echo "[corpus] FATAL: sync rc=$rc and no corpus artifacts" >&2
    exit "$rc"
  fi
fi
# schema v2: parquet index; schema v1: flat turns.jsonl
if [[ -s "$AFFINE_DATA_DIR/turns_index.parquet" ]]; then
  python - <<'PY'
from pathlib import Path
import pyarrow.parquet as pq
p = Path("/root/affine_data/turns_index.parquet")
print(f"[corpus] v2 index rows={pq.read_metadata(p).num_rows} path={p}")
PY
elif [[ -s "$AFFINE_DATA_DIR/turns.jsonl" ]]; then
  wc -l "$AFFINE_DATA_DIR/turns.jsonl"
else
  echo "[corpus] FATAL: neither turns_index.parquet nor turns.jsonl present" >&2
  exit 1
fi
echo "[corpus] $(date -u +%Y-%m-%dT%H:%M:%SZ) DONE"
touch /root/logs/corpus.done
