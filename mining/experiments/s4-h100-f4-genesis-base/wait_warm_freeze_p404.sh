#!/usr/bin/env bash
# Pass 404: cuda403 chall is already loading. Do NOT relaunch.
# Wait for promptable, keep TCACHE writable, run diverse warm (d1–d4),
# then freeze + rearm longwait. Avoids short-only freeze → Triton ENOENT.
set -euo pipefail
source /root/venv/bin/activate
set -a
# shellcheck disable=SC1091
[ -f /root/mine.env ] && source /root/mine.env
set +a

HYP=h100
TCACHE=/root/.triton/isolated/h100_chall_p260_a1_1786227519_63229
LOG=/root/logs/h100_chall_warm_freeze_p404.nohup
CHALL_LOG=/root/logs/vllm_chall.log

log() { echo "[f4-p404] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

[[ -d "$TCACHE" ]] || { log "ABORT no TCACHE $TCACHE"; exit 1; }

# Keep writable for diverse JIT
chmod -R u+w "$TCACHE" 2>/dev/null || true
chmod 755 "$TCACHE" 2>/dev/null || true

_comp() {
  local label=$1 prompt=$2 max_tok=$3
  local mid code
  mid=$(curl -s --max-time 5 http://127.0.0.1:8002/v1/models \
    | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d["data"][0]["id"] if d.get("data") else "")' 2>/dev/null || true)
  [[ -n "$mid" ]] || { log "comp $label no mid"; return 1; }
  code=$(PROMPT="$prompt" MAXTOK="$max_tok" MID="$mid" LABEL="$label" python3 - <<'PY'
import json, os, urllib.request
label = os.environ["LABEL"]
req = urllib.request.Request(
    "http://127.0.0.1:8002/v1/completions",
    data=json.dumps({
        "model": os.environ["MID"],
        "prompt": os.environ["PROMPT"],
        "max_tokens": int(os.environ["MAXTOK"]),
        "temperature": 0,
    }).encode(),
    headers={"Content-Type": "application/json"},
    method="POST",
)
try:
    with urllib.request.urlopen(req, timeout=180) as r:
        open(f"/tmp/h100_p404_warmup_{label}.json", "wb").write(r.read())
        print(r.status)
except Exception as e:
    open(f"/tmp/h100_p404_warmup_{label}.err", "w").write(repr(e))
    print("000")
PY
)
  log "comp $label code=$code max_tok=$max_tok prompt_chars=${#prompt}"
  [[ "$code" == "200" ]]
}

_diverse_warm() {
  local longpad
  longpad=$(python3 - <<'PY'
print("def solve(x):\n    " + ("# pad\n    " * 80) + "return x\n")
PY
)
  log "diverse writable warmups d1–d4 before freeze"
  _comp "d1" "warmup short p404" 4 || return 1
  _comp "d2" "Write a Python function that merges two sorted lists into one sorted list and explain briefly." 32 || return 1
  _comp "d3" "$longpad" 16 || return 1
  _comp "d4" "$(python3 -c "print('x' * 4096)")" 8 || return 1
  return 0
}

log "START wait existing chall :8002 → diverse-warm → freeze → longwait"
log "TCACHE=$TCACHE mode=$(stat -c %a "$TCACHE") n_so=$(find "$TCACHE" -name '__triton_launcher*.so' 2>/dev/null | wc -l)"

for i in $(seq 1 180); do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$code" == "200" ]]; then
    mid=$(curl -s --max-time 5 http://127.0.0.1:8002/v1/models \
      | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d["data"][0]["id"] if d.get("data") else "")' 2>/dev/null || true)
    if [[ -n "$mid" ]]; then
      pcode=$(curl -s -o /tmp/h100_p404_probe.json -w "%{http_code}" --max-time 90 \
        http://127.0.0.1:8002/v1/completions \
        -H 'Content-Type: application/json' \
        -d "{\"model\":\"${mid}\",\"prompt\":\"hi\",\"max_tokens\":2}" || true)
      if [[ "$pcode" == "200" ]]; then
        log "CHALL PROMPTABLE mid=$mid poll=$i — keep TCACHE writable for diverse warm"
        chmod -R u+w "$TCACHE" 2>/dev/null || true
        chmod 755 "$TCACHE" 2>/dev/null || true
        if ! _diverse_warm; then
          log "ABORT diverse warm failed — leave writable, do not freeze"
          exit 5
        fi
        n_so=$(find "$TCACHE" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
        chmod -R a-w "$TCACHE" 2>/dev/null || true
        log "FROZEN after diverse warm n_so=$n_so mode=$(stat -c %a "$TCACHE")"
        date -u +%Y-%m-%dT%H:%M:%SZ >/root/logs/h100_chall_serve.done
        echo "TCACHE=$TCACHE mode=$(stat -c %a "$TCACHE") n_so=$n_so warm_freeze_p404_diverse" \
          >/root/logs/h100_chall_freeze_pass264.done

        while read -r pid; do
          [[ -n "${pid:-}" ]] || continue
          cmd=$(tr '\0' ' ' </proc/"$pid"/cmdline 2>/dev/null || true)
          case "$cmd" in
            *watch_n80_retry.sh*) log "kill watcher $pid"; kill "$pid" 2>/dev/null || true ;;
          esac
        done < <(ps -eo pid,args | awk '/[w]atch_n80_retry\.sh/ && / h100 / {print $1}')
        while read -r pid; do
          [[ -n "${pid:-}" ]] || continue
          arg0=$(tr '\0' '\n' </proc/"$pid"/cmdline 2>/dev/null | head -1 || true)
          case "$arg0" in
            *retry_h100_n80*) log "kill retry $pid ($arg0)"; kill "$pid" 2>/dev/null || true ;;
          esac
        done < <(ps -eo pid,args | awk '/[r]etry_h100_n80/ {print $1}')
        sleep 2
        nohup bash /root/mining_src/s4-h2-merge/watch_n80_retry.sh h100 \
          /root/mining_src/s4-h100-f4-genesis-base/retry_h100_n80_longwait.sh \
          >/root/logs/h100_watch_retry.launch.nohup 2>&1 &
        echo $! >/root/logs/h100_watch_retry.pid
        log "rearmed longwait watcher pid=$(cat /root/logs/h100_watch_retry.pid)"
        log "DONE"
        exit 0
      fi
    fi
  fi
  if grep -q 'CUDA compiler and CUDA toolkit headers are incompatible' "$CHALL_LOG" 2>/dev/null; then
    log "ABORT CCCL CTK mismatch in chall log"
    exit 4
  fi
  if grep -q 'Engine core initialization failed' "$CHALL_LOG" 2>/dev/null; then
    (( i % 6 == 0 )) && log "EngineCore failed seen poll=$i"
  fi
  (( i % 6 == 0 )) && log "wait chall promptable poll=$i/180 health=$code"
  sleep 10
done
log "ABORT chall never promptable"
exit 1
