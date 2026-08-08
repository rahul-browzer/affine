#!/usr/bin/env bash
# Pass 279: live king changed to Tok331102/affine-5EqYW8McUc-af10 @ eb8bf9a…
# Download new king, patch n80 KING pins, swap :8001 after chall_serve.done
# (do not touch king during post_train health check → would ABORT pipeline).
set -euo pipefail
# shellcheck disable=SC1091
source /root/venv/bin/activate
set -a
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

NEW_REPO=${NEW_KING_REPO:-Tok331102/affine-5EqYW8McUc-af10}
NEW_REV=${NEW_KING_REV:-eb8bf9a356a254f71faaa439e8abc3cfba572c53}
LOGN=/root/logs/h70_retarget_king_pass279.nohup
log() { echo "[retarget279-h70] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOGN"; }

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

log "START new_king=$NEW_REPO@$NEW_REV"

# 1) Patch KING defaults so retry/n80 args match served model.
# NEVER sed-patch a running post_train_pipeline.sh (p282: bash offset → rc=127
# after merge DONE). Skip post_train if that process is alive; retry/prewarm OK.
_post_alive=0
if ps -eo args | awk '/[p]ost_train_pipeline\.sh/ {found=1} END{exit !found}'; then
  _post_alive=1
  log "SKIP patch post_train_pipeline.sh (process alive — p282 lesson)"
fi
for f in \
  /root/mining_src/s4-h70-m7-winner-za-lr501e6/retry_h70_n80.sh \
  /root/mining_src/s4-h70-m7-winner-za-lr501e6/prewarm_engines.sh
do
  [[ -f "$f" ]] || continue
  sed -i \
    -e "s|KING_REPO=\${KING_REPO:-TalentPigs/affine-5ekxlcg3fx-abc}|KING_REPO=\${KING_REPO:-${NEW_REPO}}|" \
    -e "s|KING_REV=\${KING_REV:-dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4}|KING_REV=\${KING_REV:-${NEW_REV}}|" \
    "$f"
  log "patched $f"
done
if [[ "$_post_alive" -eq 0 ]]; then
  f=/root/mining_src/s4-h70-m7-winner-za-lr501e6/post_train_pipeline.sh
  if [[ -f "$f" ]]; then
    sed -i \
      -e "s|KING_REPO=\${KING_REPO:-TalentPigs/affine-5ekxlcg3fx-abc}|KING_REPO=\${KING_REPO:-${NEW_REPO}}|" \
      -e "s|KING_REV=\${KING_REV:-dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4}|KING_REV=\${KING_REV:-${NEW_REV}}|" \
      "$f"
    log "patched $f"
  fi
fi

# 2) Download new king (CPU/disk; merge uses GPUs 6,7).
log "huggingface_hub snapshot_download $NEW_REPO@$NEW_REV"
python - <<PY
from huggingface_hub import snapshot_download
import os
repo = os.environ.get("NEW_KING_REPO", "$NEW_REPO")
rev = os.environ.get("NEW_KING_REV", "$NEW_REV")
# hardcoded from script defaults if env unset
repo = "$NEW_REPO"
rev = "$NEW_REV"
path = snapshot_download(repo_id=repo, revision=rev, local_dir_use_symlinks=False)
print(f"[retarget279] downloaded -> {path}")
open("/root/logs/h70_new_king_local.path", "w").write(path + "\n")
PY
log "download done path=$(cat /root/logs/h70_new_king_local.path)"

# 3) Wait for chall_serve.done so we do not race post_train's king health check.
log "wait for /root/logs/h70_chall_serve.done (max ~90m)"
for i in $(seq 1 540); do
  if [[ -f /root/logs/h70_chall_serve.done ]]; then
    log "chall_serve.done present at poll=$i"
    break
  fi
  (( i % 12 == 0 )) && log "still waiting chall_serve poll=$i/540"
  sleep 10
done
if [[ ! -f /root/logs/h70_chall_serve.done ]]; then
  log "ABORT: chall_serve.done never appeared"
  exit 1
fi

# Brief settle so chall APIServer finishes binding.
sleep 15

# 4) Kill any early n80 that started against old king (retry will relaunch).
python - <<'PY'
import os, signal, subprocess, time
out = subprocess.check_output(["ps", "-eo", "pid,args"], text=True)
killed = []
for line in out.splitlines():
    if "run_sim_duel.py" in line and "local-h70" in line and "python" in line:
        pid = int(line.split(None, 1)[0])
        try:
            os.kill(pid, signal.SIGTERM)
            killed.append(pid)
        except OSError:
            pass
time.sleep(2)
for pid in killed:
    try:
        os.kill(pid, signal.SIGKILL)
    except OSError:
        pass
print(f"[retarget279] killed early n80 pids={killed}")
PY
rm -f /root/affine_data/h70_sim_result.json /root/affine_data/h70_sim_progress.json \
  /root/affine_data/h70_decision.json /root/logs/h70_n80.done

# 5) Reap old king on GPUs 2,3 and relaunch new king.
python - <<'PY'
import os, signal, subprocess, time
want = {2, 3}
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
print(f"[retarget279] reap gpus2,3 pids={sorted(pids)}")
for pid in pids:
    try:
        os.kill(pid, signal.SIGTERM)
    except OSError:
        pass
time.sleep(2)
for pid in pids:
    try:
        os.kill(pid, signal.SIGKILL)
    except OSError:
        pass
PY

if [[ -f /root/logs/vllm_king.pid ]]; then
  old=$(cat /root/logs/vllm_king.pid)
  if kill -0 "$old" 2>/dev/null; then
    log "kill stale king APIServer pid=$old"
    kill "$old" 2>/dev/null || true
    sleep 2
    kill -9 "$old" 2>/dev/null || true
  fi
  rm -f /root/logs/vllm_king.pid
fi

log "wipe king Triton caches"
rm -rf /root/.triton/cache/king /root/.triton/cache/king_* 2>/dev/null || true
mkdir -p /root/.triton/cache/king
log "settle 25s"
sleep 25

TCACHE=/root/.triton/cache/king
LOG=/root/logs/vllm_king.log
: >"$LOG"
log "start $NEW_REPO@$NEW_REV port=8001 gpus=2,3"
CUDA_VISIBLE_DEVICES=2,3 TRITON_CACHE_DIR=$TCACHE \
  nohup vllm serve "$NEW_REPO" \
  --port 8001 \
  --revision "$NEW_REV" \
  --tensor-parallel-size 2 \
  --max-model-len 32768 \
  --gpu-memory-utilization 0.80 \
  --max-num-batched-tokens 8192 \
  --attention-backend FLASH_ATTN \
  --attention-config.use_trtllm_attention 0 \
  --compilation-config.pass_config.fuse_allreduce_rms false \
  --moe-backend triton \
  --additional-config '{"gdn_prefill_backend": "triton"}' \
  >"$LOG" 2>&1 &
echo $! >/root/logs/vllm_king.pid
log "king pid=$(cat /root/logs/vllm_king.pid)"

# 6) Wait promptable on :8001
for i in $(seq 1 180); do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/health || true)
  if [[ "$code" == "200" ]]; then
    mid=$(curl -s --max-time 5 http://127.0.0.1:8001/v1/models \
      | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d["data"][0]["id"] if d.get("data") else "")' 2>/dev/null || true)
    if [[ -n "$mid" ]]; then
      pcode=$(curl -s -o /tmp/_probe_king279.json -w "%{http_code}" --max-time 90 \
        http://127.0.0.1:8001/v1/completions \
        -H 'Content-Type: application/json' \
        -d "{\"model\":\"${mid}\",\"prompt\":\"hi\",\"max_tokens\":2}" || true)
      if [[ "$pcode" == "200" ]]; then
        log "NEW KING PROMPTABLE mid=$mid poll=$i"
        echo "$NEW_REPO $NEW_REV" >/root/logs/h70_king_retargeted_pass279.done
        date -u +%Y-%m-%dT%H:%M:%SZ >>/root/logs/h70_king_retargeted_pass279.done
        # nudge retry: if aborted, clear so watcher can relaunch
        rm -f /root/logs/h70_n80_retry.aborted
        log "DONE"
        exit 0
      fi
    fi
  fi
  (( i % 6 == 0 )) && log "wait king promptable poll=$i/180 health=$code"
  sleep 10
done
log "ABORT: new king never promptable"
exit 1
