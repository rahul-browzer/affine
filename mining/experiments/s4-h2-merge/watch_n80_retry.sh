#!/usr/bin/env bash
# Sidecar: when live start_*_n80.sh dies without a decision, launch retry_*_n80.sh.
# Do NOT edit the live start_*.sh (bash-by-offset LESSON). Args: <hyp> <retry_script>
set -euo pipefail

HYP=${1:?hyp id e.g. h10}
RETRY=${2:?path to retry_*_n80.sh}
HOTKEY="local-${HYP}"
DEC="/root/affine_data/${HYP}_decision.json"
SIM="/root/affine_data/${HYP}_sim_result.json"
LOG="/root/logs/${HYP}_watch_retry.nohup"
POLL=${POLL_S:-30}

log() { echo "[${HYP}-watch-retry] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

mkdir -p /root/logs /root/affine_data
log "armed hyp=$HYP retry=$RETRY"

_is_false_probe() {
  local f=$1
  [[ -f "$f" ]] || return 1
  python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); sys.exit(0 if d.get("false_probe") else 1)' "$f" 2>/dev/null
}

while true; do
  if [[ -f "$DEC" ]]; then
    if _is_false_probe "$DEC"; then
      # FALSE_PROBE ≠ REFUTE — quarantine and keep watching (pass205).
      ts=$(date -u +%Y%m%dT%H%M%SZ)
      mkdir -p /root/affine_data/false_probes
      mv "$DEC" "/root/affine_data/false_probes/${HYP}_decision_watchQ_${ts}.json"
      [[ -f "$SIM" ]] && mv "$SIM" "/root/affine_data/false_probes/${HYP}_sim_watchQ_${ts}.json"
      rm -f "/root/logs/${HYP}_n80.done"
      log "false_probe decision quarantined — continue"
    else
      log "decision present — exit"
      exit 0
    fi
  fi
  if [[ -f "$SIM" ]] && ! _is_false_probe "$SIM"; then
    # Skip writing decision from a false-probe sim (rejection_reason in result).
    if python3 -c 'import json,sys; d=json.load(open(sys.argv[1])); sys.exit(0 if (d.get("false_probe") or "unpromptable" in str(d.get("rejection_reason","")) or "ConnectError" in str(d.get("rejection_reason",""))) else 1)' "$SIM" 2>/dev/null; then
      ts=$(date -u +%Y%m%dT%H%M%SZ)
      mkdir -p /root/affine_data/false_probes
      mv "$SIM" "/root/affine_data/false_probes/${HYP}_sim_watchQ_${ts}.json"
      log "false_probe sim quarantined — continue"
    else
      log "sim result present without decision — write decision"
      # shellcheck disable=SC1091
      source /root/venv/bin/activate
      python3 /root/mining_src/s4-h2-merge/write_merge_decision.py \
        --hyp "$HYP" --sim-result "$SIM" --out "$DEC"
      date -u +%Y-%m-%dT%H:%M:%SZ > "/root/logs/${HYP}_n80.done"
      exit 0
    fi
  fi
  # Require python — pgrep -f matches its own argv / SSH (pass205).
  if ps -eo pid,cmd | awk -v hk="$HOTKEY" '
      /python/ && /[r]un_sim_duel\.py/ && $0 ~ hk { found=1 }
      END { exit !found }
    '; then
    sleep "$POLL"
    continue
  fi
  # Wait out a real start/retry process. Do NOT use pgrep -f on the script
  # path: this watcher's own argv embeds retry_*.sh and would match forever
  # (H32 pass198 deadlock after pipeline abort).
  # Match retry_${hyp}_n80.sh AND variants (…_longwait.sh, …_b203first.sh).
  # Exact `retry_X_n80\.sh` missed longwait → watcher respawned every POLL,
  # resetting engine-wait counters (F4 p392: 4 concurrent longwaits @ poll=0).
  if ps -eo pid,cmd | awk -v hyp="$HYP" '
      /watch_n80_retry/ { next }
      $0 ~ ("bash[[:space:]].*/retry_" hyp "_n80") { found=1 }
      $0 ~ ("bash[[:space:]].*/start_" hyp "_n80") { found=1 }
      END { exit !found }
    '; then
    sleep "$POLL"
    continue
  fi
  log "no sim / no decision — launching retry"
  # Do not exec: retry abort would kill this sidecar (H37/H38 pass203).
  nohup bash "$RETRY" >>"/root/logs/${HYP}_n80_retry.nohup" 2>&1 &
  echo $! >"/root/logs/${HYP}_n80_retry.pid"
  # Wait for retry to either finish or spawn sim before looping again.
  sleep "$POLL"
done
