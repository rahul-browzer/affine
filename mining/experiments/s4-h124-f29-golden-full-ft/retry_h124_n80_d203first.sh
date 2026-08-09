#!/usr/bin/env bash
# Restart H124 n80 after crash. Engines must already be up.
# p409: preemptively drop a203+c203 (H32 overflow on F7 p408 c203@~7/80;
# a203 known-bad). d203-first + longwait polls (360/120). MAX=6.
# 3× retry (LESSON: dual-side n80 can stall teacher sample even at 480s×5).
set -euo pipefail

# Wait for bootstrap venv (H60: watch_n80_retry raced pip; activate ENOENT)
for _ in $(seq 1 120); do
  [[ -f /root/venv/bin/activate ]] && break
  sleep 5
done
# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
export HF_HOME=${HF_HOME:-/root/hf}

KING_REPO=${KING_REPO:-Tok331102/affine-5EqYW8McUc-af10}
KING_REV=${KING_REV:-eb8bf9a356a254f71faaa439e8abc3cfba572c53}
MERGED=${MERGED:-/root/h124/merged}
SIM=/root/affine_data/h124_sim_result.json
PROG=/root/affine_data/h124_sim_progress.json
DEC=/root/affine_data/h124_decision.json
LOG=/root/logs/h124_n80_retry.nohup
MAX_ATTEMPTS=${MAX_ATTEMPTS:-6}

log() { echo "[h124-n80-retry] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

_promptable() {
  # health=200 ≠ alive (H30/H100 Triton __triton_launcher.so → ConnectError false REFUTE)
  local port=$1 mid code
  mid=$(curl -s --max-time 5 "http://127.0.0.1:${port}/v1/models" \
    | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d["data"][0]["id"] if d.get("data") else "")' 2>/dev/null || true)
  [[ -n "$mid" ]] || return 1
  code=$(curl -s -o /tmp/_probe_${port}.json -w "%{http_code}" --max-time 60 \
    "http://127.0.0.1:${port}/v1/completions" \
    -H 'Content-Type: application/json' \
    -d "{\"model\":\"${mid}\",\"prompt\":\"hi\",\"max_tokens\":2}" || true)
  [[ "$code" == "200" ]]
}

_engines_ok() {
  local t k c
  t=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/health || true)
  k=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/health || true)
  c=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/health || true)
  [[ "$t" == "200" && "$k" == "200" && "$c" == "200" ]] || return 1
  _promptable 8002
}

# MoE chall load is 10–20m; abort-immediately → watcher spam every 30s (pass205).
# Wait for health+completions before starting n80 (LESSON: ≥120×15s MoE wait).
_wait_engines() {
  local max=${1:-360} i=0
  while (( i < max )); do
    if _engines_ok; then
      # Double-probe: first completions can EngineDead on missing
      # __triton_launcher.so (H100/H38 p204/p205). Confirm again after settle.
      log "first promptable at poll=$i — settle 20s + re-probe"
      sleep 20
      if _engines_ok; then
        log "engines double-promptable after ${i} polls"
        rm -f /root/logs/h124_n80_retry.aborted
        return 0
      fi
      log "WARN re-probe failed after settle — keep waiting"
    fi
    (( i % 4 == 0 )) && log "wait engines poll=$i/$max (need health200 + chall completions200×2)"
    sleep 15
    i=$((i + 1))
  done
  return 1
}

mkdir -p /root/logs /root/affine_data

if [[ -f "$DEC" ]]; then
  if python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); sys.exit(0 if d.get("false_probe") else 1)' "$DEC" 2>/dev/null; then
    ts=$(date -u +%Y%m%dT%H%M%SZ)
    mkdir -p /root/affine_data/false_probes
    mv "$DEC" "/root/affine_data/false_probes/h124_decision_retryQ_${ts}.json"
    [[ -f "$SIM" ]] && mv "$SIM" "/root/affine_data/false_probes/h124_sim_retryQ_${ts}.json"
    rm -f /root/logs/h124_n80.done
    log "false_probe decision quarantined — continue to n80"
  else
    log "decision already present — noop"
    exit 0
  fi
fi
if [[ -f "$SIM" ]]; then
  if python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); sys.exit(0 if (d.get("false_probe") or "unpromptable" in str(d.get("rejection_reason","")) or "ConnectError" in str(d.get("rejection_reason",""))) else 1)' "$SIM" 2>/dev/null; then
    ts=$(date -u +%Y%m%dT%H%M%SZ)
    mkdir -p /root/affine_data/false_probes
    mv "$SIM" "/root/affine_data/false_probes/h124_sim_retryQ_${ts}.json"
    log "false_probe sim quarantined — continue to n80"
  else
    log "sim result present — writing decision only"
    python3 /root/mining_src/s4-h2-merge/write_merge_decision.py \
      --hyp h124 --sim-result "$SIM" --out "$DEC"
    date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h124_n80.done
    exit 0
  fi
fi
# Require python in argv — bare pgrep/awk patterns false-match (pass205).
if ps -eo pid,cmd | awk '/python/ && /[r]un_sim_duel.py/ && /local-h124/ { found=1 } END { exit !found }'; then
  log "sim already running — noop"
  exit 0
fi
if ! _wait_engines "${WAIT_ENGINE_POLLS:-360}"; then
  log "ABORT: engines not promptable after wait"
  echo "aborted_engines_unhealthy $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    >/root/logs/h124_n80_retry.aborted
  exit 1
fi
test -d "$MERGED"
test -f /root/logs/h124_merge.done

# Fresh block_hash per outer retry (H32/H34): default 0*64 slice hits a turn
# with prompt+max_tokens > 32768 → teacher 400 → whole n80 dies.
# p408: a203 known H32 (30977+1792); c203 confirmed same overflow @~7/80.
# Drop both. d203-first with fresh e/f/g + b203 fallback (b203 failed on
# chall FALSE_PROBE, not teacher overflow).
BLOCK_HASHES=(
  "d203000000000000000000000000000000000000000000000000000000000004"
  "e203000000000000000000000000000000000000000000000000000000000005"
  "f203000000000000000000000000000000000000000000000000000000000006"
  "g203000000000000000000000000000000000000000000000000000000000007"
  "b203000000000000000000000000000000000000000000000000000000000002"
)

_is_false_probe_sim() {
  # p431: run_sim_duel nests rejection_reason under verdict — top-level-only
  # check mistook FALSE_PROBE for success → N80_DONE → watcher restarts d203 forever.
  local f=$1
  [[ -f "$f" ]] || return 1
  python3 -c '
import json,sys
d=json.load(open(sys.argv[1]))
v=d.get("verdict") if isinstance(d.get("verdict"), dict) else {}
rr=str(d.get("rejection_reason") or v.get("rejection_reason") or "")
fp=bool(d.get("false_probe") or v.get("false_probe"))
sys.exit(0 if (fp or "unpromptable" in rr or "ConnectError" in rr
               or (d.get("margin") is None and rr)
               or (v and rr and v.get("challenger_wins") is False)) else 1)
' "$f" 2>/dev/null
}

for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
  rm -f "$SIM" "$PROG"
  bh="${BLOCK_HASHES[$(( (attempt - 1) % ${#BLOCK_HASHES[@]} ))]}"
  log "n80 attempt $attempt/$MAX_ATTEMPTS block_hash=${bh:0:16}…"
  set +e
  python /root/mining_src/s4-h2-merge/run_sim_duel.py \
    --king-repo "$KING_REPO" \
    --king-rev "$KING_REV" \
    --chall-repo "$MERGED" \
    --chall-rev local \
    --n-turns 80 \
    --hotkey local-h124 \
    --block-hash "$bh" \
    --out "$SIM" \
    --progress-out "$PROG" \
    --save-artifact \
    2>&1 | tee /root/logs/h124_n80.log
  rc=${PIPESTATUS[0]}
  set -e
  if [[ $rc -eq 0 && -f "$SIM" ]]; then
    # FALSE_PROBE must NOT exit 0 — watcher quarantines + relaunches attempt 1
    # and never reaches later hashes (p389).
    if _is_false_probe_sim "$SIM"; then
      ts=$(date -u +%Y%m%dT%H%M%SZ)
      mkdir -p /root/affine_data/false_probes
      mv "$SIM" "/root/affine_data/false_probes/h124_sim_retryQ_${ts}.json"
      [[ -f "${SIM%.json}_artifact.json" ]] && \
        mv "${SIM%.json}_artifact.json" \
          "/root/affine_data/false_probes/h124_artifact_retryQ_${ts}.json" || true
      log "WARN attempt $attempt FALSE_PROBE — continue to next block_hash"
      rc=42
    else
      python3 /root/mining_src/s4-h2-merge/write_merge_decision.py \
        --hyp h124 --sim-result "$SIM" --out "$DEC"
      date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h124_n80.done
      log "N80_DONE"
      exit 0
    fi
  fi
  log "WARN attempt $attempt failed rc=$rc; wait engines then retry"
  if ! _wait_engines "${WAIT_ENGINE_POLLS_MID:-120}"; then
    log "ABORT: engines unhealthy mid-retry"
    echo "aborted_engines_unhealthy $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
      >/root/logs/h124_n80_retry.aborted
    exit 1
  fi
done

log "ERROR: all $MAX_ATTEMPTS attempts failed"
echo "aborted_n80_retry_failed $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  >/root/logs/h124_n80_retry.aborted
exit 1
