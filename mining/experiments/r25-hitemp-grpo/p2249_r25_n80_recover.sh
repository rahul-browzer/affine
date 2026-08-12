#!/usr/bin/env bash
# p2249: if p2247 serve script times out (~15m) while chall still loads, finish warm+n80.
set -euo pipefail
ROOT=/home/const/subnet120/mining
LOG=$ROOT/experiments/r25-hitemp-grpo/artifacts/p2249_r25_n80_recover.log
mkdir -p "$(dirname "$LOG")"
exec >>"$LOG" 2>&1
log(){ echo "[p2249-r25rec] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }
HOST=204.9.206.245; PORT=40051
ssh_r(){ ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=12 -o BatchMode=yes -p "$PORT" "root@$HOST" "$@"; }
log "start"
for i in $(seq 1 240); do
  st=$(ssh_r 'bash -s' <<'EOS' || echo SSH_FAIL
DEC=/root/affine_data/r25_decision.json
SIM=/root/affine_data/r25_sim_result.json
PROG=/root/affine_data/r25_sim_progress.json
if [[ -f "$DEC" ]]; then echo DECISION; exit 0; fi
if ps -eo pid,cmd | awk '/python/ && /[r]un_sim_duel\.py/ && /local-r25/ {found=1} END{exit !found}'; then
  if [[ -f "$PROG" ]]; then
    python3 -c 'import json;d=json.load(open("/root/affine_data/r25_sim_progress.json"));print("PROG",d.get("done"),"/",d.get("n"))' 2>/dev/null || echo PROG
  else
    echo N80_LIVE
  fi
  exit 0
fi
code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || echo 000)
chall_alive=0
kill -0 "$(cat /root/logs/vllm_chall.pid 2>/dev/null || echo 0)" 2>/dev/null && chall_alive=1
serve_alive=0
kill -0 "$(cat /root/logs/p2247_r24_serve_r25.pid 2>/dev/null || echo 0)" 2>/dev/null && serve_alive=1
if [[ "$code" == "200" && "$serve_alive" == "0" ]]; then
  echo RECOVER_NEEDED code=$code
elif [[ "$code" == "200" ]]; then
  echo WAIT_SERVE code=$code serve=$serve_alive
elif [[ "$chall_alive" == "1" ]]; then
  echo LOADING code=$code
else
  echo DEAD code=$code
fi
EOS
)
  log "poll=$i $st"
  case "$st" in
    DECISION*|PROG*|N80_LIVE*) log "ok $st"; exit 0 ;;
    DEAD*) log "FATAL chall dead"; exit 1 ;;
    RECOVER_NEEDED*)
      log "recovering n80 after serve timeout"
      ssh_r 'bash -s' <<'EOS'
set -euo pipefail
source /root/venv/bin/activate
set -a; [[ -f /root/mine.env ]] && source /root/mine.env; set +a
MERGE=/root/r25_from_hf
TCACHE=/root/.triton/cache/chall
SIM=/root/affine_data/r25_sim_result.json
DEC=/root/affine_data/r25_decision.json
PROG=/root/affine_data/r25_sim_progress.json
KING_REPO=ttttxxxxsada/Affine-5guassq3tu
KING_REV=e86758f5080d1e373e5fbbd7b4fbf6af327aeb44
log(){ echo "[p2249-r25rec-pod] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }
# short warm + freeze
mid=$(curl -s --max-time 5 http://127.0.0.1:8002/v1/models \
  | python3 -c 'import sys,json;d=json.load(sys.stdin);print(d["data"][0]["id"] if d.get("data") else "")')
python3 - <<PY
import json,urllib.request,os
mid=os.environ.get("MID","")
PY
PROMPT="warmup short r25mig" MAXTOK=4 MID="$mid" python3 - <<'PY' || true
import json,os,urllib.request
req=urllib.request.Request(
  "http://127.0.0.1:8002/v1/completions",
  data=json.dumps({"model":os.environ["MID"],"prompt":os.environ["PROMPT"],
                   "max_tokens":int(os.environ["MAXTOK"]),"temperature":0}).encode(),
  headers={"Content-Type":"application/json"}, method="POST")
with urllib.request.urlopen(req, timeout=180) as r:
  open("/tmp/r25mig_warmup_d1.json","wb").write(r.read())
print("warm_ok")
PY
chmod -R a-w "$TCACHE" || true
mkdir -p /root/affine_data/false_probes
ts=$(date -u +%Y%m%dT%H%M%SZ)
for f in "$DEC" "$SIM" "$PROG"; do
  [[ -f "$f" ]] && mv "$f" "/root/affine_data/false_probes/$(basename "$f" .json)_p2249_${ts}.json" || true
done
if ! kill -0 "$(cat /root/logs/r25_form_decision.pid 2>/dev/null || echo 0)" 2>/dev/null; then
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh r25 \
    "$SIM" "$DEC" /root/logs/r25_form_decision.nohup \
    >>/root/logs/r25_form_decision.launch.out 2>&1 &
  echo $! >/root/logs/r25_form_decision.pid
fi
bh=a203000000000000000000000000000000000000000000000000000000000003
nohup bash -c "
  set -a; source /root/mine.env; set +a
  source /root/venv/bin/activate
  export PYTHONPATH=/root/mining_src/affine_pkg:${PYTHONPATH:-}
  python /root/mining_src/s4-h2-merge/run_sim_duel.py \
    --king-repo '$KING_REPO' --king-rev '$KING_REV' \
    --chall-repo '$MERGE' --chall-rev local \
    --n-turns 80 --hotkey local-r25 \
    --block-hash '$bh' \
    --out '$SIM' --progress-out '$PROG' --save-artifact \
    2>&1 | tee -a /root/logs/r25_sim.nohup
" >/root/logs/r25_sim_launch.nohup 2>&1 &
echo $! >/root/logs/r25_sim_launch.pid
sleep 4
ps -eo pid,cmd | awk '/python/ && /[r]un_sim_duel\.py/ && /local-r25/ {print "n80_live",$1}'
log DONE
EOS
      log "recover ssh done; sleep then expect N80_LIVE"
      sleep 8
      ;;
  esac
  sleep 30
done
log "FATAL timeout"; exit 1
