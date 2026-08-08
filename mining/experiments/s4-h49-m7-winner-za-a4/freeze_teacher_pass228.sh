#!/usr/bin/env bash
# Pass 228: wait for H49 teacher :8000 promptable (2× completions 20s apart),
# then chmod -R a-w its live TRITON_CACHE_DIR so mid-n80 races cannot delete
# __triton_launcher.so (LESSONS H40 p217). Does not touch king/merge/chall.
set -euo pipefail

LOG=/root/logs/h49_teacher_freeze_pass228.log
mkdir -p /root/logs
: >"$LOG"
log() { echo "[freeze228-h49] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

log "START wait teacher promptable → freeze TCACHE"

_probe() {
  curl -sS -m 60 -o /tmp/h49_t_probe.json -w "%{http_code}" \
    http://127.0.0.1:8000/v1/completions \
    -H "Content-Type: application/json" \
    -d '{"model":"zai-org/GLM-4.5-Air-FP8","prompt":"ok","max_tokens":4,"temperature":0}' \
    2>/dev/null || echo "000"
}

ok1=0
for i in $(seq 1 120); do
  code=$(_probe)
  if [[ "$code" == "200" ]]; then
    log "probe1 ok i=$i"
    ok1=1
    break
  fi
  if (( i % 6 == 0 )); then
    log "probe1 waiting i=$i code=$code"
  fi
  # abort if teacher pid died
  if [[ -f /root/logs/vllm_teacher.pid ]]; then
    tpid=$(cat /root/logs/vllm_teacher.pid || true)
    if [[ -n "${tpid:-}" ]] && ! kill -0 "$tpid" 2>/dev/null; then
      log "ABORT teacher pid $tpid dead"
      echo "aborted_teacher_dead $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        >/root/logs/h49_teacher_freeze_pass228.aborted
      exit 1
    fi
  fi
  sleep 10
done
if [[ "$ok1" != "1" ]]; then
  log "ABORT never promptable in 20m"
  echo "aborted_timeout $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    >/root/logs/h49_teacher_freeze_pass228.aborted
  exit 1
fi

log "settle 20s before probe2"
sleep 20
code2=$(_probe)
if [[ "$code2" != "200" ]]; then
  log "ABORT probe2 code=$code2 (Triton race likely)"
  echo "aborted_probe2_$code2 $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    >/root/logs/h49_teacher_freeze_pass228.aborted
  exit 1
fi
log "probe2 ok"

# Resolve live TRITON_CACHE_DIR from teacher environ
tpid=$(cat /root/logs/vllm_teacher.pid 2>/dev/null || true)
TCACHE=""
if [[ -n "${tpid:-}" && -r /proc/$tpid/environ ]]; then
  TCACHE=$(tr '\0' '\n' </proc/$tpid/environ | awk -F= '/^TRITON_CACHE_DIR=/{print $2; exit}')
fi
if [[ -z "${TCACHE:-}" ]]; then
  # fallback: newest teacher_p227_* under /root/.triton/cache
  TCACHE=$(ls -dt /root/.triton/cache/teacher_p227_* 2>/dev/null | head -1 || true)
fi
if [[ -z "${TCACHE:-}" || ! -d "$TCACHE" ]]; then
  log "ABORT cannot resolve TCACHE (pid=$tpid)"
  echo "aborted_no_tcache $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    >/root/logs/h49_teacher_freeze_pass228.aborted
  exit 1
fi

log "FREEZE TCACHE chmod -R a-w $TCACHE"
chmod -R a-w "$TCACHE" || true
mode=$(stat -c '%a' "$TCACHE" 2>/dev/null || echo '?')
log "TCACHE mode=$mode path=$TCACHE"

# one more completion post-freeze to confirm still alive
sleep 5
code3=$(_probe)
log "probe3 post-freeze code=$code3"
if [[ "$code3" != "200" ]]; then
  echo "aborted_postfreeze_$code3 $(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    >/root/logs/h49_teacher_freeze_pass228.aborted
  exit 1
fi

date -u +%Y-%m-%dT%H:%M:%SZ >/root/logs/h49_teacher_freeze_pass228.done
echo "TCACHE=$TCACHE" >>/root/logs/h49_teacher_freeze_pass228.done
log "DONE teacher frozen+promptable"
exit 0
