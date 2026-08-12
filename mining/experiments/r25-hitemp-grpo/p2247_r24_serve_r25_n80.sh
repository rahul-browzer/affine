#!/usr/bin/env bash
# p2247: on mine-r3 (R24 warm TKC) — swap chall to R25 merge, warm, n80 vs guass.
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

MERGE=${MERGE:-/root/r25_from_hf}
GPUS=${GPUS:-4,5}
UTIL=${UTIL:-0.72}
PIDF=/root/logs/vllm_chall.pid
CHALL_LOG=/root/logs/vllm_chall.log
TCACHE=/root/.triton/cache/chall
KING_REPO=${KING_REPO:-ttttxxxxsada/Affine-5guassq3tu}
KING_REV=${KING_REV:-e86758f5080d1e373e5fbbd7b4fbf6af327aeb44}
SIM=/root/affine_data/r25_sim_result.json
DEC=/root/affine_data/r25_decision.json
PROG=/root/affine_data/r25_sim_progress.json

log(){ echo "[p2247-r24r25] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

test -f "$MERGE/config.json"
# require full 16-shard merge (p2248: premature serve on partial HF pull killed chall)
miss=0
for k in $(seq 1 16); do
  f=$(printf "$MERGE/model-%05d-of-00016.safetensors" "$k")
  [[ -s "$f" ]] || miss=$((miss+1))
done
[[ "$miss" -eq 0 ]] || { log "ABORT incomplete merge miss=$miss"; exit 1; }

for p in 8000 8001; do
  c=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://127.0.0.1:$p/v1/models || true)
  [[ "$c" == "200" ]] || { log "ABORT :$p=$c"; exit 1; }
done

# kill existing chall on GPUs 4,5
if [[ -f "$PIDF" ]]; then
  old=$(cat "$PIDF" || true)
  if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
    log "stop chall pid=$old"
    kill "$old" 2>/dev/null || true
    for j in $(seq 1 40); do kill -0 "$old" 2>/dev/null || break; sleep 1; done
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
print(f"[p2247-r24r25] reap workers={sorted(pids)} parents={sorted(parents)}")
PY
rm -f "$PIDF"
for i in $(seq 1 40); do
  free_ok=$(nvidia-smi --query-gpu=index,memory.used --format=csv,noheader,nounits \
    | awk -F',' -v g="$GPUS" 'BEGIN{split(g,a,",");for(i in a)w[a[i]+0]=1}
      {gsub(/ /,"",$1);gsub(/ /,"",$2);if(($1+0) in w && ($2+0)<500)n++}END{print n+0}')
  [[ "$free_ok" -ge 2 ]] && { log "gpus free"; break; }
  sleep 2
done

# point /tmp/r3_merged at R25 for model id continuity optional — serve path directly
chmod -R u+w "$TCACHE" 2>/dev/null || true
mkdir -p "$TCACHE"
before=$(find "$TCACHE" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
for src in /root/.triton/cache/king /root/.triton/cache/teacher; do
  [[ -d "$src" ]] && cp -a "$src"/. "$TCACHE"/ || true
done
after=$(find "$TCACHE" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
log "triton seed $before → $after"
chmod -R u+w "$TCACHE"

: >"$CHALL_LOG"
# B300 R24: try without enforce-eager first (B300 OK); fall back handled by operator
log "launch chall merge=$MERGE"
CUDA_VISIBLE_DEVICES=$GPUS TRITON_CACHE_DIR=$TCACHE \
  nohup /root/venv/bin/vllm serve "$MERGE" \
    --port 8002 --tensor-parallel-size 2 --max-model-len 65536 \
    --gpu-memory-utilization "$UTIL" --max-num-batched-tokens 8192 \
    --attention-backend FLASH_ATTN --attention-config.use_trtllm_attention 0 \
    --compilation-config.pass_config.fuse_allreduce_rms false \
    --moe-backend triton --additional-config '{"gdn_prefill_backend": "triton"}' \
    >"$CHALL_LOG" 2>&1 &
echo $! >"$PIDF"
CHALL_PID=$(cat "$PIDF")
log "chall_pid=$CHALL_PID"

ready=0
for i in $(seq 1 90); do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://127.0.0.1:8002/v1/models || true)
  if [[ "$code" == "200" ]]; then ready=1; log "health=200 poll=$i"; break; fi
  kill -0 "$CHALL_PID" 2>/dev/null || { log "chall died"; tail -n 50 "$CHALL_LOG"; exit 1; }
  sleep 10
done
[[ "$ready" == "1" ]] || { log "NOT READY"; tail -n 50 "$CHALL_LOG"; exit 2; }

_comp(){
  local label=$1 prompt=$2 max_tok=$3 mid code
  mid=$(curl -s --max-time 5 http://127.0.0.1:8002/v1/models \
    | python3 -c 'import sys,json;d=json.load(sys.stdin);print(d["data"][0]["id"] if d.get("data") else "")' 2>/dev/null || true)
  [[ -n "$mid" ]] || return 1
  code=$(PROMPT="$prompt" MAXTOK="$max_tok" MID="$mid" LABEL="$label" python3 - <<'PY'
import json,os,urllib.request
req=urllib.request.Request(
  "http://127.0.0.1:8002/v1/completions",
  data=json.dumps({"model":os.environ["MID"],"prompt":os.environ["PROMPT"],
                   "max_tokens":int(os.environ["MAXTOK"]),"temperature":0}).encode(),
  headers={"Content-Type":"application/json"}, method="POST")
try:
  with urllib.request.urlopen(req, timeout=180) as r:
    open(f"/tmp/r25mig_warmup_{os.environ['LABEL']}.json","wb").write(r.read()); print(r.status)
except Exception as e:
  open(f"/tmp/r25mig_warmup_{os.environ['LABEL']}.err","w").write(repr(e)); print("000")
PY
)
  log "comp $label code=$code"
  [[ "$code" == "200" ]]
}

_comp d1 "warmup short r25mig" 4 || log "WARN warm d1"
chmod -R a-w "$TCACHE" || true
_comp f1 "warmup post-freeze" 4 || log "WARN warm f1"

# quarantine any stale r25 artifacts; keep R24's r3_* alone
mkdir -p /root/affine_data/false_probes
ts=$(date -u +%Y%m%dT%H%M%SZ)
for f in "$DEC" "$SIM" "$PROG" /root/affine_data/r25_sim_result_artifact.json; do
  [[ -f "$f" ]] && mv "$f" "/root/affine_data/false_probes/$(basename "$f" .json)_p2247_${ts}.json" || true
done

# form-dec watcher for R25 paths
if ! kill -0 "$(cat /root/logs/r25_form_decision.pid 2>/dev/null || echo 0)" 2>/dev/null; then
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh r25 \
    "$SIM" "$DEC" /root/logs/r25_form_decision.nohup \
    >>/root/logs/r25_form_decision.launch.out 2>&1 &
  echo $! >/root/logs/r25_form_decision.pid
  log "form_dec pid=$(cat /root/logs/r25_form_decision.pid)"
fi

bh=a203000000000000000000000000000000000000000000000000000000000003
log "launch n80 R25-on-R24 vs guass"
nohup bash -c "
  set -a; source /root/mine.env; set +a
  source /root/venv/bin/activate
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
if ps -eo pid,cmd | awk '/python/ && /[r]un_sim_duel\.py/ && /local-r25/ {found=1} END{exit !found}'; then
  log "n80 gather LIVE"
else
  log "WARN n80 start — see launch log"
  tail -n 40 /root/logs/r25_sim_launch.nohup || true
fi
for p in 8000 8001 8002; do
  echo -n ":$p "; curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://127.0.0.1:$p/v1/models; echo
done
log "DONE"
