#!/usr/bin/env bash
# p2206: after reign-6 crown, swap :8001 king ckp333→ttttxxxxsada guass.
# Leave teacher/chall/R17 train alone. Kill king by pidfile only — never pkill -f.
set -euo pipefail
LOG=/root/logs/retarget_king_tttt_guass.log
DONE=/root/logs/retarget_king_tttt_guass.done
PIDF=/root/logs/retarget_king_tttt_guass.pid
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[retarget-king] $(date -u +%Y-%m-%dT%H:%M:%SZ) start p2206 reign-6"
if [[ -f "$DONE" ]]; then
  echo "[retarget-king] already done: $(cat "$DONE")"
  exit 0
fi

# Force live reign-6 king (do NOT inherit stale KING_* from mine.env).
TARGET_KING_REPO=ttttxxxxsada/Affine-5guassq3tu
TARGET_KING_REV=e86758f5080d1e373e5fbbd7b4fbf6af327aeb44
PREFETCH_DONE=${PREFETCH_DONE:-/root/logs/r2_prefetch_tttt_guass.done}
PREFETCH_SH=${PREFETCH_SH:-/root/mining_src/r2-multiking-merge/launch_prefetch_tttt_guass.sh}

# Abort if an n80 gather is live (do not yank :8001 mid-sim).
if pgrep -af 'run_reason_sim\.py' >/dev/null 2>&1; then
  echo "[retarget-king] FATAL active run_reason_sim — defer" >&2
  exit 3
fi

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
# Re-assert after mine.env (it still points at prior king until we patch it).
KING_REPO=$TARGET_KING_REPO
KING_REV=$TARGET_KING_REV
export KING_REPO KING_REV
export HF_HOME=${HF_HOME:-/root/hf}
export HF_HUB_ENABLE_HF_TRANSFER=${HF_HUB_ENABLE_HF_TRANSFER:-1}
export HF_XET_HIGH_PERFORMANCE=${HF_XET_HIGH_PERFORMANCE:-1}
export VLLM_USE_DEEP_GEMM=0
export VLLM_USE_FLASHINFER_SAMPLER=0
export VLLM_ALLREDUCE_USE_FLASHINFER=0
export VLLM_MOE_USE_DEEP_GEMM=0
export VLLM_USE_FLASHINFER_MOE_FP16=0
export VLLM_USE_FLASHINFER_MOE_FP4=0
export VLLM_USE_FLASHINFER_MOE_FP8=0
export CUDA_HOME=/root/venv/lib/python3.12/site-packages/nvidia/cu13
export CUDA_PATH=$CUDA_HOME
export LD_LIBRARY_PATH="${CUDA_HOME}/lib:${CUDA_HOME}/lib64:${LD_LIBRARY_PATH:-}"
rm -f /usr/local/cuda

hub_ok() {
  python3 - <<PY
from pathlib import Path
import os
repo=os.environ.get("KING_REPO","$KING_REPO")
rev=os.environ.get("KING_REV","$KING_REV")
name="models--" + repo.replace("/","--")
snap=Path(os.environ.get("HF_HOME","/root/hf"))/"hub"/name/"snapshots"/rev
idx=snap/"model.safetensors.index.json"
raise SystemExit(0 if idx.is_file() else 1)
PY
}
export KING_REPO KING_REV
if ! hub_ok; then
  echo "[retarget-king] cache miss — force prefetch"
  rm -f "$PREFETCH_DONE" /root/affine_data/r2_prefetch_tttt_guass.done
  if [[ -x "$PREFETCH_SH" ]]; then
    bash "$PREFETCH_SH"
  else
    echo "[retarget-king] FATAL missing $PREFETCH_SH" >&2
    exit 2
  fi
fi
if ! hub_ok; then
  echo "[retarget-king] FATAL still no hub snapshot after prefetch" >&2
  exit 2
fi
echo "[retarget-king] hub OK $KING_REPO@$KING_REV"

# Already serving?
if curl -s --max-time 3 http://127.0.0.1:8001/v1/models 2>/dev/null \
  | python3 -c 'import sys,json; d=json.load(sys.stdin); raise SystemExit(0 if any("guass" in (x.get("id") or "").lower() for x in d.get("data",[])) else 1)' 2>/dev/null; then
  id=$(curl -s --max-time 3 http://127.0.0.1:8001/v1/models | python3 -c 'import sys,json; print(json.load(sys.stdin)["data"][0]["id"])')
  echo "OK already_serving_guass id=$id $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
  exit 0
fi

stop_pidfile() {
  local f=$1 name=$2 pid
  [[ -f "$f" ]] || { echo "[retarget-king] no pidfile $f ($name)"; return 0; }
  pid=$(cat "$f" || true)
  [[ -n "${pid:-}" ]] || return 0
  if kill -0 "$pid" 2>/dev/null; then
    echo "[retarget-king] stop $name pid=$pid"
    kill "$pid" || true
    for j in $(seq 1 40); do
      kill -0 "$pid" 2>/dev/null || break
      sleep 1
    done
    kill -9 "$pid" 2>/dev/null || true
    kill -9 $(pstree -p "$pid" 2>/dev/null | grep -oE '[0-9]+' | tr '\n' ' ') 2>/dev/null || true
  fi
  rm -f "$f"
}
stop_pidfile /root/logs/vllm_king.pid king
sleep 3

COMMON=(
  --tensor-parallel-size 2
  --max-model-len 65536
  --max-num-batched-tokens 8192
  --attention-backend FLASH_ATTN
  --attention-config.use_trtllm_attention 0
  --compilation-config.pass_config.fuse_allreduce_rms false
  --moe-backend triton
  --additional-config '{"gdn_prefill_backend": "triton"}'
  # p2216 R25 B200: FULL cudagraph capture deadlocks TP0=R/TP1=S at 0% for
  # minutes (shm_broadcast stalls). enforce-eager skips capture; R3 B300 OK without.
  --enforce-eager
)
echo "[retarget-king] launch $KING_REPO@$KING_REV :8001 (enforce-eager)"
CUDA_VISIBLE_DEVICES=2,3 TRITON_CACHE_DIR=/root/.triton/cache/king \
  nohup /root/venv/bin/vllm serve "$KING_REPO" \
    --port 8001 --gpu-memory-utilization 0.80 \
    "${COMMON[@]}" --revision "$KING_REV" \
    >/root/logs/vllm_king.log 2>&1 &
echo $! >/root/logs/vllm_king.pid
echo "[retarget-king] king pid=$(cat /root/logs/vllm_king.pid)"

# Patch mine.env KING_* so post-train sims pick the live baseline.
if [[ -f /root/mine.env ]]; then
  python3 - <<'PY'
from pathlib import Path
p = Path("/root/mine.env")
text = p.read_text()
repo = "ttttxxxxsada/Affine-5guassq3tu"
rev = "e86758f5080d1e373e5fbbd7b4fbf6af327aeb44"
local = f"/root/hf/hub/models--ttttxxxxsada--Affine-5guassq3tu/snapshots/{rev}"
repl = {
    "KING_REPO": repo,
    "KING_REV": rev,
    "KING_LOCAL": local,
}
out = []
seen = set()
for line in text.splitlines():
    if line.startswith("export KING_REPO="):
        out.append(f'export KING_REPO={repo}'); seen.add("KING_REPO"); continue
    if line.startswith("export KING_REV="):
        out.append(f'export KING_REV={rev}'); seen.add("KING_REV"); continue
    if line.startswith("export KING_LOCAL="):
        out.append(f'export KING_LOCAL={local}'); seen.add("KING_LOCAL"); continue
    out.append(line)
for k, v in repl.items():
    if k not in seen:
        out.append(f"export {k}={v}")
p.write_text("\n".join(out) + "\n")
print("[retarget-king] mine.env KING_* patched")
PY
fi

for i in $(seq 1 480); do
  code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  if [[ "$code" == "200" ]]; then
    id=$(curl -s --max-time 3 http://127.0.0.1:8001/v1/models | python3 -c 'import sys,json; print(json.load(sys.stdin)["data"][0]["id"])')
    echo "[retarget-king] :8001 ready id=$id iter=$i"
    if [[ "$id" != *guass* && "$id" != *ttttxxxxsada* ]]; then
      echo "[retarget-king] WARN unexpected model id=$id" >&2
    fi
    meta=/root/affine_data/retarget_king_tttt_guass.json
    python3 - <<PY
import json, time
from pathlib import Path
Path("$meta").write_text(json.dumps({
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "pass": 2206,
    "king_repo": "$KING_REPO",
    "king_rev": "$KING_REV",
    "served_id": "$id",
    "note": "reign-6 live king on crown :8001; R17/R20/R24 n80s must use this baseline",
}, indent=2) + "\n")
PY
    echo "OK $KING_REPO@$KING_REV id=$id $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if grep -aEq 'Could not find nvcc|headers are incompatible|Error|Traceback' /root/logs/vllm_king.log 2>/dev/null \
     && ! kill -0 "$(cat /root/logs/vllm_king.pid)" 2>/dev/null; then
    echo "[retarget-king] FATAL king died; tail:" >&2
    tail -40 /root/logs/vllm_king.log >&2 || true
    exit 2
  fi
  if (( i % 12 == 0 )); then
    echo "[retarget-king] wait-ready iter=$i code=$code"
  fi
  sleep 5
done
echo "[retarget-king] TIMEOUT waiting :8001" >&2
exit 2
