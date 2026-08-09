#!/usr/bin/env bash
# mine-watch-1: restore warm duel stack (teacher+king+H64 chall) from snapshot.
# Triton tar + serve argv: experiments/warm-stack/{warm_stack_triton_cache_p539.tar.gz,serve_commands.md}
set -euo pipefail

LOG=/root/logs/restore_warm_stack.log
mkdir -p /root/logs /root/hf /root/.triton /tmp
exec > >(tee -a "$LOG") 2>&1

echo "[restore] $(date -u +%Y-%m-%dT%H:%M:%SZ) start host=$(hostname)"

if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export HF_HOME=${HF_HOME:-/root/hf}
export HF_HUB_ENABLE_HF_TRANSFER=${HF_HUB_ENABLE_HF_TRANSFER:-1}
export HF_XET_HIGH_PERFORMANCE=${HF_XET_HIGH_PERFORMANCE:-1}
export PATH="$HOME/.local/bin:$PATH"
export HF_TOKEN
export VLLM_USE_DEEP_GEMM=0
export VLLM_USE_FLASHINFER_SAMPLER=0
export VLLM_ALLREDUCE_USE_FLASHINFER=0
export VLLM_MOE_USE_DEEP_GEMM=0
export VLLM_USE_FLASHINFER_MOE_FP16=0
export VLLM_USE_FLASHINFER_MOE_FP4=0
export VLLM_USE_FLASHINFER_MOE_FP8=0
export CUDA_HOME=${CUDA_HOME:-/root/venv/lib/python3.12/site-packages/nvidia/cu13}
export CUDA_PATH=$CUDA_HOME

if [[ -z "${HF_TOKEN:-}" ]]; then
  echo "[restore] FATAL: HF_TOKEN missing in /root/mine.env"
  exit 1
fi

NGPU=$(nvidia-smi -L | wc -l)
echo "[restore] GPU_COUNT=$NGPU"
test "$NGPU" -ge 8

TAR=/root/warm_stack_triton_cache_p539.tar.gz
test -s "$TAR"

if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

if [[ ! -d /root/venv ]]; then
  uv venv /root/venv --python 3.12
fi
# shellcheck disable=SC1091
source /root/venv/bin/activate

if [[ ! -x /root/venv/bin/vllm ]]; then
  uv pip install \
    "torch==2.11.0" \
    "transformers==5.14.1" \
    "vllm==0.22.1" \
    "httpx" \
    "huggingface_hub[hf_transfer]" \
    "hf_transfer" \
    "safetensors" \
    "numpy" \
    "scipy" \
    2>&1 | tee /root/logs/pip_restore.log | tail -40
fi

python - <<'PY'
import torch, transformers, vllm
print("[restore] VERSIONS", torch.__version__, transformers.__version__, vllm.__version__)
assert vllm.__version__.startswith("0.22.1"), vllm.__version__
assert transformers.__version__.startswith("5.14"), transformers.__version__
PY

# Triton caches (expensive part) — restore before serve
if [[ ! -d /root/.triton/cache/chall ]]; then
  echo "[restore] extracting Triton tar"
  tar -C /root/.triton -xzf "$TAR"
fi
echo "[restore] triton n_so teacher=$(find /root/.triton/cache/teacher -name '*.so' 2>/dev/null | wc -l) king=$(find /root/.triton/cache/king -name '*.so' 2>/dev/null | wc -l) chall=$(find /root/.triton/cache/chall -name '*.so' 2>/dev/null | wc -l)"

# Downloads (parallel where safe)
python - <<'PY'
import os
from concurrent.futures import ThreadPoolExecutor, as_completed
from huggingface_hub import snapshot_download

token = os.environ["HF_TOKEN"]
jobs = [
    ("teacher", "zai-org/GLM-4.5-Air-FP8", None, "/root/logs/teacher.done"),
    ("king", "Tok331102/affine-5EqYW8McUc-af10",
     "eb8bf9a356a254f71faaa439e8abc3cfba572c53", "/root/logs/tok331102.done"),
    ("h64", "unconst/Affine-5czsc2fc98-h64-merged", "4ebe10443f7f",
     "/root/logs/h64_dl.done"),
]

def one(name, repo, rev, stamp):
    if os.path.isfile(stamp) and os.path.getsize(stamp) > 0:
        print(f"[restore] skip {name} (stamp exists)", flush=True)
        return name, open(stamp).read().strip()
    kw = dict(repo_id=repo, token=token)
    if rev:
        kw["revision"] = rev
    print(f"[restore] DOWNLOAD {name} start {repo} rev={rev}", flush=True)
    path = snapshot_download(**kw)
    open(stamp, "w").write(path + "\n")
    print(f"[restore] DOWNLOAD {name} done -> {path}", flush=True)
    return name, path

with ThreadPoolExecutor(max_workers=3) as ex:
    futs = [ex.submit(one, *j) for j in jobs]
    for f in as_completed(futs):
        print("[restore] finished", f.result()[0], flush=True)
PY

# Materialize H64 at /tmp/h64_merged (symlink to HF cache snapshot)
H64_SRC=$(cat /root/logs/h64_dl.done)
if [[ ! -e /tmp/h64_merged ]]; then
  ln -sfn "$H64_SRC" /tmp/h64_merged
fi
ls -la /tmp/h64_merged | head -3
echo "[restore] h64_merged -> $(readlink -f /tmp/h64_merged)"

COMMON=(
  --tensor-parallel-size 2
  --max-model-len 32768
  --max-num-batched-tokens 8192
  --attention-backend FLASH_ATTN
  --attention-config.use_trtllm_attention 0
  --compilation-config.pass_config.fuse_allreduce_rms false
  --moe-backend triton
  --additional-config '{"gdn_prefill_backend": "triton"}'
)

serve_one() {
  local role=$1 port=$2 gpus=$3 util=$4 model=$5
  shift 5
  local extra=("$@")
  local log=/root/logs/vllm_${role}.log
  if curl -sf --max-time 3 "http://127.0.0.1:${port}/v1/models" >/dev/null 2>&1; then
    echo "[restore] ${role} :${port} already up"
    return 0
  fi
  echo "[restore] launching ${role} :${port} gpus=${gpus} util=${util}"
  CUDA_VISIBLE_DEVICES=$gpus TRITON_CACHE_DIR=/root/.triton/cache/${role} \
    nohup /root/venv/bin/vllm serve "$model" \
      --port "$port" --gpu-memory-utilization "$util" \
      "${COMMON[@]}" "${extra[@]}" \
      >"$log" 2>&1 &
  echo $! >"/root/logs/vllm_${role}.pid"
}

serve_one teacher 8000 0,1 0.80 zai-org/GLM-4.5-Air-FP8
serve_one king 8001 2,3 0.80 Tok331102/affine-5EqYW8McUc-af10 \
  --revision eb8bf9a356a254f71faaa439e8abc3cfba572c53
serve_one chall 8002 4,5 0.72 /tmp/h64_merged

echo "[restore] waiting for engines 200/200/200 (up to ~40m)"
for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[restore] PROMPTABLE engines 200/200/200 at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    curl -s http://127.0.0.1:8002/v1/models | head -c 400; echo
    touch /root/logs/warm_stack_ready.done
    echo READY > /root/logs/warm_stack_ready.done
    exit 0
  fi
  if (( i % 12 == 0 )); then
    echo "[restore] wait iter=$i codes=${c0}/${c1}/${c2} $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  fi
  sleep 5
done

echo "[restore] TIMEOUT waiting for engines; see /root/logs/vllm_*.log"
exit 2
