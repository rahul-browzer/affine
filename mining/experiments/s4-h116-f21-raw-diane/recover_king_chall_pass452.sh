#!/usr/bin/env bash
# Pass 452: F21 king+chall both dead after NCCL/TimeoutError zombies.
# Teacher :8000=200 on GPUs 0,1 — leave alone.
# King :8001 EngineDead@02:51 (TimeoutError); Chall :8002 NCCL timeout;
# orphan VLLM::Worker ppid=1 on GPUs 4,5 (~135/48 GiB). GPUs 2,3 free.
# Reap 2–5; seed isolated TCACHEs from bare chall n_so≥16; util=0.72 both;
# quarantine partial n80; rearms via existing watch_n80_retry (d203first).
set -euo pipefail
# shellcheck disable=SC1091
source /root/venv/bin/activate
set -a
# shellcheck disable=SC1091
[ -f /root/mine.env ] && source /root/mine.env
set +a
export HF_HOME=${HF_HOME:-/root/hf}
export VLLM_USE_FLASHINFER_SAMPLER=0
export VLLM_ALLREDUCE_USE_FLASHINFER=0
export VLLM_USE_FLASHINFER_MOE_FP16=0
export VLLM_USE_FLASHINFER_MOE_FP8=0
export VLLM_USE_FLASHINFER_MOE_FP4=0
export VLLM_DEEP_GEMM=0
export VLLM_USE_DEEP_GEMM=0
export VLLM_MOE_USE_DEEP_GEMM=0

_SITE=$(python - <<'PY'
import site
print(site.getsitepackages()[0])
PY
)
_CU13="${_SITE}/nvidia/cu13"
if [[ -x "${_CU13}/bin/nvcc" ]]; then
  export CUDA_HOME=${CUDA_HOME:-$_CU13}
  export CUDA_PATH=$CUDA_HOME
  export PATH="${CUDA_HOME}/bin:${PATH}"
  export LD_LIBRARY_PATH="${CUDA_HOME}/lib:${CUDA_HOME}/lib64:${LD_LIBRARY_PATH:-}"
fi

LOGN=/root/logs/h116_recover_pass452.nohup
mkdir -p /root/logs /root/affine_data /root/.triton/isolated
log() { echo "[recover452-h116] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOGN"; }

log "START king+chall recover (teacher left; n80 watcher already armed)"

# Quarantine partial n80 artifacts (FALSE_PROBE path; not a verdict).
ts=$(date -u +%Y%m%dT%H%M%SZ)
QDIR=/root/affine_data/false_probes
mkdir -p "$QDIR"
for f in h116_decision.json h116_sim_result.json h116_sim_result_artifact.json \
         h116_sim_progress.json; do
  if [[ -f "/root/affine_data/$f" ]]; then
    mv "/root/affine_data/$f" "$QDIR/${f%.json}_pass452_${ts}.json"
    log "quarantine $f → $QDIR"
  fi
done
rm -f /root/logs/h116_chall_serve.done /root/logs/h116_n80.done \
  /root/logs/h116_sim_n80.done /root/logs/h116_king_recover_pass332.done \
  /root/logs/h116_king_recover_pass452.done /root/logs/h116_chall_recover_pass452.done

# Kill stale APIServers by pidfile / port match (never broad pkill -f).
for role_pidf in /root/logs/vllm_king.pid /root/logs/vllm_chall.pid; do
  if [[ -f "$role_pidf" ]]; then
    old=$(cat "$role_pidf" || true)
    if [[ -n "${old:-}" ]] && kill -0 "$old" 2>/dev/null; then
      log "kill stale api $role_pidf pid=$old"
      kill "$old" 2>/dev/null || true
      sleep 2
      kill -9 "$old" 2>/dev/null || true
    fi
    rm -f "$role_pidf"
  fi
done
while read -r pid; do
  [[ -n "${pid:-}" ]] || continue
  log "kill stale serve pid=$pid"
  kill "$pid" 2>/dev/null || true
  sleep 1
  kill -9 "$pid" 2>/dev/null || true
done < <(ps -eo pid,args | awk '/[v]llm serve .*--port 800[12]/ {print $1}')

# Reap GPU holders on 2,3,4,5 (teacher 0,1 untouched).
python - <<'PY' | tee -a "$LOGN"
import os, signal, subprocess, time
want = {2, 3, 4, 5}
out = subprocess.check_output(
    ["nvidia-smi", "--query-gpu=index,uuid", "--format=csv,noheader,nounits"],
    text=True,
)
idx_to_uuid = {}
for line in out.strip().splitlines():
    parts = [p.strip() for p in line.split(",")]
    if len(parts) >= 2:
        idx_to_uuid[int(parts[0])] = parts[1]
uuids = {idx_to_uuid[i] for i in want if i in idx_to_uuid}
apps = subprocess.check_output(
    ["nvidia-smi", "--query-compute-apps=gpu_uuid,pid", "--format=csv,noheader,nounits"],
    text=True,
)
pids = set()
for line in apps.strip().splitlines():
    if not line.strip():
        continue
    parts = [p.strip() for p in line.split(",")]
    if len(parts) >= 2 and parts[0] in uuids:
        try:
            pids.add(int(parts[1]))
        except ValueError:
            pass
parents = set()
grandparents = set()
for pid in list(pids):
    try:
        with open(f"/proc/{pid}/stat") as f:
            body = f.read()
        rparen = body.rfind(")")
        fields = body[rparen + 2 :].split()
        ppid = int(fields[1])
        if ppid > 1:
            parents.add(ppid)
            try:
                with open(f"/proc/{ppid}/stat") as f:
                    body2 = f.read()
                r2 = body2.rfind(")")
                gppid = int(body2[r2 + 2 :].split()[1])
                if gppid > 1:
                    grandparents.add(gppid)
            except Exception:
                pass
    except Exception:
        pass
# Never kill teacher APIServer/EngineCore (port 8000 / GPUs 0,1).
kill_set = set()
for pid in pids | parents | grandparents:
    try:
        with open(f"/proc/{pid}/cmdline", "rb") as f:
            cmd = f.read().replace(b"\0", b" ").decode("utf-8", "replace")
    except Exception:
        cmd = ""
    if "--port 8000" in cmd or "GLM-4.5-Air-FP8" in cmd:
        print(f"[recover452] SKIP teacher-related pid={pid}")
        continue
    kill_set.add(pid)
print(f"[recover452] reap gpus2-5 workers={sorted(pids)} parents={sorted(parents)} gp={sorted(grandparents)} kill={sorted(kill_set)}")
for pid in kill_set:
    try:
        os.kill(pid, signal.SIGTERM)
    except ProcessLookupError:
        pass
time.sleep(2)
for pid in kill_set:
    try:
        os.kill(pid, signal.SIGKILL)
    except ProcessLookupError:
        pass
PY

for i in 1 2 3 4 5 6 7 8 9 10 12 15; do
  free_ok=$(nvidia-smi --query-gpu=index,memory.used --format=csv,noheader,nounits \
    | awk -F',' '$1+0>=2 && $1+0<=5 && $2+0<500 {n++} END{print n+0}')
  log "free-check gpus2-5 used<500MiB count=$free_ok/4 try=$i"
  if [[ "$free_ok" -ge 4 ]]; then
    break
  fi
  sleep 2
done
[[ "$free_ok" -ge 4 ]] || { log "ABORT: gpus 2-5 not free"; exit 1; }

# Seed from bare chall cache (n_so≥16) before wiping role caches.
SEED=""
if [[ -d /root/.triton/cache/chall ]]; then
  n=$(find /root/.triton/cache/chall -name '__triton_launcher*.so' 2>/dev/null | wc -l)
  if [[ "$n" -ge 16 ]]; then
    SEED=/root/.triton/cache/chall
  fi
fi
if [[ -z "$SEED" && -d /root/.triton/cache/king ]]; then
  n=$(find /root/.triton/cache/king -name '__triton_launcher*.so' 2>/dev/null | wc -l)
  if [[ "$n" -ge 16 ]]; then
    SEED=/root/.triton/cache/king
  fi
fi
[[ -n "$SEED" && -d "$SEED" ]] || { log "ABORT: no seed TCACHE n_so≥16"; exit 4; }
seed_n=$(find "$SEED" -name '__triton_launcher*.so' 2>/dev/null | wc -l)
log "SEED=$SEED n_so=$seed_n"

stamp=$(date +%s)
KING_TC="/root/.triton/isolated/h116_king_p452_${stamp}_$$"
CHALL_TC="/root/.triton/isolated/h116_chall_p452_${stamp}_$$"
mkdir -p "$KING_TC" "$CHALL_TC"
cp -a "$SEED"/. "$KING_TC/"
cp -a "$SEED"/. "$CHALL_TC/"
chmod -R u+w "$KING_TC" "$CHALL_TC" || true
echo "$KING_TC" >/root/logs/h116_king_tcache_pass332.path
echo "$KING_TC" >/root/logs/h116_king_tcache_pass452.path
echo "$CHALL_TC" >/root/logs/h116_chall_tcache_pass452.path
kn=$(find "$KING_TC" -name '__triton_launcher*.so' | wc -l)
cn=$(find "$CHALL_TC" -name '__triton_launcher*.so' | wc -l)
log "isolated king TCACHE=$KING_TC n_so=$kn"
log "isolated chall TCACHE=$CHALL_TC n_so=$cn"
[[ "$kn" -ge 16 && "$cn" -ge 16 ]] || { log "ABORT: isolated n_so too low"; exit 6; }

# Wipe bare role caches so nothing falls back to zombie hashes.
rm -rf /root/.triton/cache/king /root/.triton/cache/chall
mkdir -p /root/.triton/cache/king /root/.triton/cache/chall

python3 - <<PY
import glob,sys
bad=0
for root in ("$KING_TC", "$CHALL_TC"):
  for p in glob.glob(root + "/**/__triton_launcher*.so", recursive=True):
    try:
      with open(p,"rb") as f: f.read(64)
    except OSError as e:
      print("GHOST",p,e); bad+=1
print(f"[recover452] launcher ghosts={bad}")
sys.exit(1 if bad else 0)
PY

log "settle 20s"
sleep 20

REPO_K=Tok331102/affine-5EqYW8McUc-af10
REV_K=eb8bf9a356a254f71faaa439e8abc3cfba572c53
MERGE_DIR=${MERGE_DIR:-/root/h116/chall}
UTIL=0.72

: >/root/logs/vllm_king.log
: >/root/logs/vllm_chall.log

log "launch king port=8001 gpus=2,3 util=$UTIL TCACHE=$KING_TC"
CUDA_VISIBLE_DEVICES=2,3 TRITON_CACHE_DIR=$KING_TC \
  nohup vllm serve "$REPO_K" \
  --port 8001 \
  --revision "$REV_K" \
  --tensor-parallel-size 2 \
  --max-model-len 32768 \
  --gpu-memory-utilization "$UTIL" \
  --max-num-batched-tokens 8192 \
  --attention-backend FLASH_ATTN \
  --attention-config.use_trtllm_attention 0 \
  --compilation-config.pass_config.fuse_allreduce_rms false \
  --moe-backend triton \
  --additional-config '{"gdn_prefill_backend": "triton"}' \
  >/root/logs/vllm_king.log 2>&1 &
echo $! >/root/logs/vllm_king.pid
log "king_pid=$(cat /root/logs/vllm_king.pid)"

# Stagger chall 30s to avoid concurrent Triton compile storms.
sleep 30
log "launch chall port=8002 gpus=4,5 util=$UTIL TCACHE=$CHALL_TC MERGE=$MERGE_DIR"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=$CHALL_TC \
  nohup vllm serve "$MERGE_DIR" \
  --port 8002 \
  --tensor-parallel-size 2 \
  --max-model-len 32768 \
  --gpu-memory-utilization "$UTIL" \
  --max-num-batched-tokens 8192 \
  --attention-backend FLASH_ATTN \
  --attention-config.use_trtllm_attention 0 \
  --compilation-config.pass_config.fuse_allreduce_rms false \
  --moe-backend triton \
  --additional-config '{"gdn_prefill_backend": "triton"}' \
  >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
log "chall_pid=$(cat /root/logs/vllm_chall.pid)"

king_ok=0
chall_ok=0
for i in $(seq 1 180); do
  for role in king chall; do
    if [[ "$role" == "king" ]]; then port=8001; okvar=king_ok; logf=/root/logs/vllm_king.log
    else port=8002; okvar=chall_ok; logf=/root/logs/vllm_chall.log; fi
    eval cur=\$$okvar
    if [[ "$cur" -eq 1 ]]; then continue; fi
    if grep -q '__triton_launcher.*cannot open shared object file' "$logf" 2>/dev/null \
      || grep -q 'ImportError: .*/__triton_launcher' "$logf" 2>/dev/null; then
      log "ABORT early: Triton ENOENT in $role log at poll=$i"
      exit 2
    fi
    if grep -q 'CUDA out of memory' "$logf" 2>/dev/null; then
      log "ABORT early: CUDA OOM in $role log at poll=$i"
      exit 3
    fi
    code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 "http://127.0.0.1:${port}/health" || true)
    if [[ "$code" == "200" ]]; then
      mid=$(curl -s --max-time 5 "http://127.0.0.1:${port}/v1/models" \
        | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d["data"][0]["id"] if d.get("data") else "")' 2>/dev/null || true)
      if [[ -n "$mid" ]]; then
        pcode=$(curl -s -o "/tmp/_probe_${role}452.json" -w "%{http_code}" --max-time 90 \
          "http://127.0.0.1:${port}/v1/completions" \
          -H 'Content-Type: application/json' \
          -d "{\"model\":\"${mid}\",\"prompt\":\"hi\",\"max_tokens\":2}" || true)
        if [[ "$pcode" == "200" ]]; then
          log "$role PROMPTABLE mid=$mid poll=$i"
          if [[ "$role" == "king" ]]; then
            king_ok=1
            date -u +%Y-%m-%dT%H:%M:%SZ >/root/logs/h116_king_recover_pass452.done
            echo "$REPO_K $REV_K $KING_TC util=0.72" >>/root/logs/h116_king_recover_pass452.done
            cp /root/logs/h116_king_recover_pass452.done /root/logs/h116_king_recover_pass332.done
          else
            chall_ok=1
            date -u +%Y-%m-%dT%H:%M:%SZ >/root/logs/h116_chall_recover_pass452.done
            echo "$MERGE_DIR $CHALL_TC util=0.72" >>/root/logs/h116_chall_recover_pass452.done
            date -u +%Y-%m-%dT%H:%M:%SZ >/root/logs/h116_chall_serve.done
            echo "chall_promptable pass452" >>/root/logs/h116_chall_serve.done
          fi
        fi
      fi
    fi
  done
  if [[ "$king_ok" -eq 1 && "$chall_ok" -eq 1 ]]; then
    tcode=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/health || true)
    log "DONE king+chall promptable teacher_health=$tcode — n80 watcher should proceed"
    exit 0
  fi
  (( i % 6 == 0 )) && log "wait promptable poll=$i/180 king_ok=$king_ok chall_ok=$chall_ok"
  sleep 10
done
log "ABORT: timed out king_ok=$king_ok chall_ok=$chall_ok"
exit 1
