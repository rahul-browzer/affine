#!/usr/bin/env bash
# p2246: B200 chall shm hang → enforce-eager; Triton ENOENT → diverse warm+freeze; re-arm n80 vs guass.
set -euo pipefail
source /root/venv/bin/activate
set -a; [[ -f /root/mine.env ]] && source /root/mine.env; set +a

export HF_HOME=${HF_HOME:-/root/hf}
export VLLM_USE_FLASHINFER_SAMPLER=0
export VLLM_ALLREDUCE_USE_FLASHINFER=0
export VLLM_USE_FLASHINFER_MOE_FP16=0
export VLLM_USE_FLASHINFER_MOE_FP8=0
export VLLM_USE_FLASHINFER_MOE_FP4=0
export VLLM_USE_DEEP_GEMM=0
export VLLM_MOE_USE_DEEP_GEMM=0
_SITE=$(python -c 'import site; print(site.getsitepackages()[0])')
export CUDA_HOME="${_SITE}/nvidia/cu13"
export CUDA_PATH=$CUDA_HOME

MERGE=${MERGE:-/tmp/r3_merged}
GPUS=${GPUS:-4,5}
UTIL=${UTIL:-0.72}
PIDF=/root/logs/vllm_chall.pid
CHALL_LOG=/root/logs/vllm_chall.log
TCACHE=/root/.triton/cache/chall
HYP=r3
KING_REPO=${KING_REPO:-ttttxxxxsada/Affine-5guassq3tu}
KING_REV=${KING_REV:-e86758f5080d1e373e5fbbd7b4fbf6af327aeb44}
SIM=/root/affine_data/r3_sim_result.json
DEC=/root/affine_data/r3_decision.json
PROG=/root/affine_data/r3_sim_progress.json

log(){ echo "[p2246-r25] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

kill_chall(){
  if [[ -f "$PIDF" ]]; then
    old=$(cat "$PIDF" || true)
    if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
      log "stop chall pid=$old"
      kill "$old" 2>/dev/null || true
      for j in $(seq 1 30); do kill -0 "$old" 2>/dev/null || break; sleep 1; done
      kill -9 "$old" 2>/dev/null || true
    fi
  fi
  export GPUS
  python - <<'PY'
import subprocess, os, signal, time
want={int(x) for x in os.environ.get("GPUS","4,5").split(",") if x.strip()!=""}
out=subprocess.check_output(["nvidia-smi","--query-gpu=index,uuid","--format=csv,noheader,nounits"],text=True)
idx={}
for line in out.strip().splitlines():
  a=[p.strip() for p in line.split(",")]
  if len(a)>=2: idx[int(a[0])]=a[1]
uuids={idx[i] for i in want if i in idx}
apps=subprocess.check_output(["nvidia-smi","--query-compute-apps=gpu_uuid,pid","--format=csv,noheader,nounits"],text=True)
pids=set()
for line in apps.strip().splitlines():
  if not line.strip(): continue
  a=[p.strip() for p in line.split(",")]
  if len(a)>=2 and a[0] in uuids:
    try: pids.add(int(a[1]))
    except: pass
parents=set()
for pid in list(pids):
  try:
    body=open(f"/proc/{pid}/stat").read(); r=body.rfind(")"); ppid=int(body[r+2:].split()[1])
    if ppid>1: parents.add(ppid)
  except: pass
for pid in pids|parents:
  try: os.kill(pid, signal.SIGTERM)
  except ProcessLookupError: pass
time.sleep(2)
for pid in pids|parents:
  try: os.kill(pid, signal.SIGKILL)
  except ProcessLookupError: pass
print(f"[p2246-r25] reap workers={sorted(pids)} parents={sorted(parents)}")
PY
  rm -f "$PIDF"
  for i in $(seq 1 30); do
    free_ok=$(nvidia-smi --query-gpu=index,memory.used --format=csv,noheader,nounits \
      | awk -F',' -v g="$GPUS" 'BEGIN{split(g,a,",");for(i in a)w[a[i]+0]=1}
        {gsub(/ /,"",$1);gsub(/ /,"",$2);if(($1+0) in w && ($2+0)<500)n++}END{print n+0}')
    [[ "$free_ok" -ge 2 ]] && { log "gpus free"; return 0; }
    sleep 2
  done
  log "WARN gpus not fully free"; return 0
}

_comp(){
  local label=$1 prompt=${2:-"warmup $1"} max_tok=${3:-4} mid code
  mid=$(curl -s --max-time 5 http://127.0.0.1:8002/v1/models \
    | python3 -c 'import sys,json;d=json.load(sys.stdin);print(d["data"][0]["id"] if d.get("data") else "")' 2>/dev/null || true)
  [[ -n "$mid" ]] || { log "FAIL $label no model id"; return 1; }
  code=$(PROMPT="$prompt" MAXTOK="$max_tok" MID="$mid" LABEL="$label" python3 - <<'PY'
import json,os,urllib.request
req=urllib.request.Request(
  "http://127.0.0.1:8002/v1/completions",
  data=json.dumps({"model":os.environ["MID"],"prompt":os.environ["PROMPT"],
                   "max_tokens":int(os.environ["MAXTOK"]),"temperature":0}).encode(),
  headers={"Content-Type":"application/json"}, method="POST")
try:
  with urllib.request.urlopen(req, timeout=180) as r:
    open(f"/tmp/r25_warmup_{os.environ['LABEL']}.json","wb").write(r.read()); print(r.status)
except Exception as e:
  open(f"/tmp/r25_warmup_{os.environ['LABEL']}.err","w").write(repr(e)); print("000")
PY
)
  log "comp $label code=$code max_tok=$max_tok"
  [[ "$code" == "200" ]]
}

# --- verify T/K ---
for p in 8000 8001; do
  c=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://127.0.0.1:$p/v1/models || true)
  [[ "$c" == "200" ]] || { log "ABORT :$p=$c"; exit 1; }
done

kill_chall

# seed chall from king+teacher (writable)
chmod -R u+w "$TCACHE" 2>/dev/null || true
mkdir -p "$TCACHE"
before=$(find "$TCACHE" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
for src in /root/.triton/cache/king /root/.triton/cache/teacher; do
  [[ -d "$src" ]] && cp -a "$src"/. "$TCACHE"/ || true
done
after=$(find "$TCACHE" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
log "triton seed launchers $before → $after"
chmod -R u+w "$TCACHE"

: >"$CHALL_LOG"
log "launch chall enforce-eager merge=$MERGE"
CUDA_VISIBLE_DEVICES=$GPUS TRITON_CACHE_DIR=$TCACHE \
  nohup /root/venv/bin/vllm serve "$MERGE" \
    --port 8002 --tensor-parallel-size 2 --max-model-len 65536 \
    --gpu-memory-utilization "$UTIL" --max-num-batched-tokens 8192 \
    --attention-backend FLASH_ATTN --attention-config.use_trtllm_attention 0 \
    --compilation-config.pass_config.fuse_allreduce_rms false \
    --moe-backend triton --additional-config '{"gdn_prefill_backend": "triton"}' \
    --enforce-eager \
    >"$CHALL_LOG" 2>&1 &
echo $! >"$PIDF"
CHALL_PID=$(cat "$PIDF")
log "chall_pid=$CHALL_PID"

ready=0
for i in $(seq 1 60); do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://127.0.0.1:8002/v1/models || true)
  if [[ "$code" == "200" ]]; then ready=1; log "health=200 poll=$i"; break; fi
  kill -0 "$CHALL_PID" 2>/dev/null || { log "chall died"; tail -n 40 "$CHALL_LOG"; exit 1; }
  sleep 10
done
[[ "$ready" == "1" ]] || { log "NOT READY"; exit 2; }

longpad=$(python3 - <<'PY'
print("def solve(x):\n    " + ("# pad\n    " * 80) + "return x\n")
PY
)
log "diverse writable warmups"
_comp d1 "warmup short r25" 4
_comp d2 "Write a Python function that merges two sorted lists into one sorted list and explain briefly." 32
_comp d3 "$longpad" 16
_comp d4 "$(python3 -c "print('x'*4096)")" 8
n_pre=$(find "$TCACHE" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
log "pre-freeze launchers=$n_pre — freezing TCACHE"
chmod -R a-w "$TCACHE"

_comp f1 "warmup post-freeze short" 4
_comp f2 "Write a short bash one-liner to count lines in a file." 16
_comp f3 "$(python3 -c "print('y'*2048)")" 8
n_post=$(find "$TCACHE" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
log "post-freeze warm OK launchers=$n_post"

# quarantine FALSE_PROBE
ts=$(date -u +%Y%m%dT%H%M%SZ)
mkdir -p /root/affine_data/false_probes
for f in "$DEC" "$SIM" "$PROG" /root/affine_data/r3_sim_result_artifact.json; do
  [[ -f "$f" ]] && mv "$f" "/root/affine_data/false_probes/$(basename "$f" .json)_p2246_${ts}.json" || true
done
rm -f /root/logs/r3_sim_n80.done /root/logs/r3_pipeline.aborted
log "quarantined false_probe artifacts ts=$ts"

# re-arm form-dec
if ! kill -0 23089 2>/dev/null; then
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh r3 \
    "$SIM" "$DEC" /root/logs/r25_form_decision.nohup \
    >>/root/logs/r25_form_decision.launch.out 2>&1 &
  echo $! >/root/logs/r25_form_decision.pid
  log "form_dec relaunched pid=$(cat /root/logs/r25_form_decision.pid)"
else
  log "form_dec still alive pid=23089"
fi

# launch n80
bh=a203000000000000000000000000000000000000000000000000000000000002
log "launch n80 vs guass block_hash=${bh:0:16}…"
nohup bash -c "
  set -a; source /root/mine.env; set +a
  source /root/venv/bin/activate
  python /root/mining_src/s4-h2-merge/run_sim_duel.py \
    --king-repo '$KING_REPO' --king-rev '$KING_REV' \
    --chall-repo '$MERGE' --chall-rev local \
    --n-turns 80 --hotkey local-r3 \
    --block-hash '$bh' \
    --out '$SIM' --progress-out '$PROG' --save-artifact \
    2>&1 | tee -a /root/logs/r3_sim.nohup
" >/root/logs/r3_sim_launch.nohup 2>&1 &
echo $! >/root/logs/r3_sim_launch.pid
sleep 3
if ps -eo pid,cmd | awk '/python/ && /[r]un_sim_duel\.py/ && /local-r3/ {found=1} END{exit !found}'; then
  log "n80 gather LIVE"
else
  log "WARN n80 may not have started — see /root/logs/r3_sim_launch.nohup"
  cat /root/logs/r3_sim_launch.nohup | tail -n 30
fi

# status snapshot
for p in 8000 8001 8002; do
  echo -n ":$p "; curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://127.0.0.1:$p/v1/models; echo
done
log "DONE"
