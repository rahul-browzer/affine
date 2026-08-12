#!/usr/bin/env bash
# R9 post-train (p2154): after Tok×teacher-z_C LoRA train on crown GPUs 6–7,
# wait R2bj terminal + king retarget→ckp333, merge→chall:8002→n80 vs live king.
# Kill chall by pidfile only. Never touch teacher. Soft/Deadman TTL-relative.
set -euo pipefail

LOG=/root/logs/r9_post_train.nohup
DONE=/root/logs/r9_pipeline.done
ABORT=/root/logs/r9_pipeline.aborted
PIDF=/root/logs/r9_post_train.pid
mkdir -p /root/logs /root/affine_data /root/h99 /tmp
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r9-pipe] $(date -u +%Y-%m-%dT%H:%M:%SZ) start p2154"

# Crown remove_at≈2026-08-12T14:36Z (p2164 +12h) → soft=TTL−1h, deadman=TTL−30m (LESSONS).
SOFT_DEADLINE_UTC=${SOFT_DEADLINE_UTC:-2026-08-12T13:35:59Z}
DEADMAN_UTC=${DEADMAN_UTC:-2026-08-12T14:05:59Z}

TRAIN_DIR=${TRAIN_DIR:-/root/h99/train}
ADAPTER=${ADAPTER:-$TRAIN_DIR/adapter}
CKPT_ROOT=${CKPT_ROOT:-$TRAIN_DIR/checkpoints}
BASE=${BASE:-/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53}
MERGED=${MERGED:-/tmp/r9_merged}
LINK=${LINK:-/tmp/r9_merged_link}
KING_REPO=${KING_REPO:-tolegend/Affine-5fqbxvz29b-ckp333}
KING_REV=${KING_REV:-24c137e8a978aea1e2b4abeec594fb6ca943f03c}
RETARGET_DONE=${RETARGET_DONE:-/root/logs/retarget_king_tolegend_ckp333.done}
R2BJ_DEC=${R2BJ_DEC:-/root/logs/r2bj_saysth_decision.json}
R2BJ_ALT=${R2BJ_ALT:-/root/affine_data/r2bj_saysth_decision.json}
R2BJ_SIM=${R2BJ_SIM:-/root/affine_data/r2bj_saysth_reason_sim.json}
HEADROOM_BAR=${HEADROOM_BAR:-1.5}
SIM_OUT=/root/affine_data/r9_reason_sim.json
SIM_PROG=/root/affine_data/r9_reason_progress.json
SIM_DEC=/root/affine_data/r9_decision.json

_train_alive() {
  if [[ -f /root/logs/h99_train.pid ]]; then
    local tpid
    tpid=$(cat /root/logs/h99_train.pid 2>/dev/null || true)
    if [[ -n "${tpid:-}" ]] && kill -0 "$tpid" 2>/dev/null; then
      return 0
    fi
  fi
  if [[ -f /root/logs/r9_train.pid ]]; then
    local tpid
    tpid=$(cat /root/logs/r9_train.pid 2>/dev/null || true)
    if [[ -n "${tpid:-}" ]] && kill -0 "$tpid" 2>/dev/null; then
      return 0
    fi
  fi
  pgrep -f "python3 /root/mining_src/s4-h1v2-sft/train_lora.py --base" >/dev/null 2>&1
}

_past() {
  local deadline=$1
  local now dead
  now=$(date -u +%s)
  dead=$(date -u -d "$deadline" +%s)
  (( now > dead ))
}

if [[ -f "$DONE" ]]; then
  echo "[r9-pipe] already done: $(cat "$DONE")"
  exit 0
fi
rm -f "$ABORT" /root/logs/r9_merge.done /root/logs/r9_chall_serve.done /root/logs/r9_sim_n80.done

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
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
export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}

_SITE=$(python - <<'PY'
import site
print(site.getsitepackages()[0])
PY
)
_CU13="${_SITE}/nvidia/cu13"
if [[ -x "${_CU13}/bin/nvcc" && -f "${_CU13}/include/cuda_fp16.h" ]]; then
  export CUDA_HOME=${CUDA_HOME:-$_CU13}
  export CUDA_PATH=$CUDA_HOME
  export PATH="${CUDA_HOME}/bin:${PATH}"
  export LD_LIBRARY_PATH="${CUDA_HOME}/lib:${CUDA_HOME}/lib64:${LD_LIBRARY_PATH:-}"
  export LIBRARY_PATH="${CUDA_HOME}/lib:${CUDA_HOME}/lib64:${LIBRARY_PATH:-}"
  echo "[r9-pipe] CUDA_HOME=$CUDA_HOME"
else
  echo "[r9-pipe] FATAL no nvcc under ${_CU13}" >&2
  echo "aborted_no_cuda $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
  exit 2
fi
rm -f /usr/local/cuda

if [[ ! -d "$BASE" ]]; then
  BASE=$(ls -d /root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/* 2>/dev/null | head -1 || true)
fi
if [[ -z "${BASE:-}" || ! -d "$BASE" ]]; then
  echo "[r9-pipe] FATAL missing Tok base" >&2
  echo "aborted_no_base $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
  exit 2
fi
if [[ ! -f /root/mining_src/r1-reason-distill/merge_lora.py ]]; then
  echo "[r9-pipe] FATAL missing merge_lora.py" >&2
  echo "aborted_no_merge_script $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
  exit 2
fi

# 1) Wait train.done / adapter.
echo "[r9-pipe] waiting for $TRAIN_DIR/train.done (or adapter + no train proc)"
_wait_i=0
while true; do
  if [[ -f "$TRAIN_DIR/train.done" ]]; then
    echo "[r9-pipe] train.done present"
    break
  fi
  if [[ -f "$ADAPTER/adapter_config.json" ]] && ! _train_alive; then
    echo "[r9-pipe] adapter present and train proc gone — proceed"
    break
  fi
  if _past "$SOFT_DEADLINE_UTC"; then
    echo "[r9-pipe] WARN: past soft and train not done; abort"
    echo "aborted_no_train $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
    exit 1
  fi
  _wait_i=$((_wait_i + 1))
  if (( _wait_i % 10 == 0 )); then
    crumb=$(tail -n 3 /root/logs/h99_train.nohup 2>/dev/null | tr '\r' '\n' | grep -E "step=|%|" | tail -1 || true)
    echo "[r9-pipe] still waiting train poll=$_wait_i crumb=${crumb:-none}"
  fi
  sleep 30
done

echo "[r9-pipe] waiting for train pid to exit (free GPUs 6,7)"
for _ in $(seq 1 180); do
  if ! _train_alive; then
    echo "[r9-pipe] train proc gone"
    break
  fi
  sleep 5
done
if _train_alive; then
  echo "[r9-pipe] ERROR: train still alive >15m after done; abort"
  echo "aborted_train_stuck $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
  exit 1
fi
sleep 10

if [[ ! -f "$ADAPTER/adapter_config.json" ]]; then
  latest=$(ls -d "$CKPT_ROOT"/checkpoint-* 2>/dev/null | sort -V | tail -1 || true)
  if [[ -n "${latest:-}" && -f "$latest/adapter_config.json" ]]; then
    ADAPTER=$latest
    echo "[r9-pipe] using checkpoint adapter $ADAPTER"
  else
    echo "[r9-pipe] ERROR: no adapter"
    echo "aborted_no_adapter $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
    exit 1
  fi
fi

# 2) Wait R2bj terminal so we do not yank chall:8002 mid-gather.
#    Skip R9 n80 if R2bj already clears Stage-5 headroom (rare but cheap).
echo "[r9-pipe] waiting R2bj terminal"
for i in $(seq 1 2880); do
  for f in "$R2BJ_DEC" "$R2BJ_ALT"; do
    if [[ -f "$f" ]]; then
      hr=$(python3 - <<PY
import json
from pathlib import Path
d=json.loads(Path("$f").read_text())
h=d.get("headroom_vs_3se")
print("" if h is None else h)
PY
)
      echo "[r9-pipe] R2bj decision at $f hr=${hr:-none}"
      if [[ -n "${hr:-}" ]] && python3 -c "import sys; sys.exit(0 if float('$hr') >= float('$HEADROOM_BAR') else 1)"; then
        echo "SKIP_R9_R2BJ_CLEARS file=$f hr=$hr $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
        exit 0
      fi
      break 2
    fi
  done
  if [[ -f "$R2BJ_SIM" ]]; then
    echo "[r9-pipe] R2bj sim json present (decision pending) — proceed to merge wait"
    break
  fi
  # Also proceed once retarget is waiting/done and no sim process remains.
  if ! pgrep -f "run_reason_sim.py .*r2bj-saysth" >/dev/null 2>&1 \
     && [[ -f /root/affine_data/r2bj_saysth_reason_progress.json ]]; then
    n=$(python3 - <<'PY'
import json
from pathlib import Path
p=Path('/root/affine_data/r2bj_saysth_reason_progress.json')
d=json.loads(p.read_text())
print(min(int(d.get('challenger') or 0), int(d.get('king') or 0)))
PY
)
    if (( n >= 80 )); then
      echo "[r9-pipe] R2bj progress ≥80/80 and sim gone — proceed"
      break
    fi
  fi
  if _past "$SOFT_DEADLINE_UTC"; then
    echo "[r9-pipe] past soft waiting R2bj; abort"
    echo "aborted_r2bj_wait $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
    exit 1
  fi
  if (( i % 12 == 0 )); then
    crumb=$(python3 -c "from pathlib import Path;p=Path('/root/affine_data/r2bj_saysth_reason_progress.json');print(p.read_text().strip() if p.is_file() else 'no-progress')" 2>/dev/null || echo none)
    echo "[r9-pipe] wait-r2bj iter=$i crumb=${crumb:-none}"
  fi
  sleep 10
done

# 3) Wait king retarget DONE (live baseline = ckp333).
echo "[r9-pipe] waiting $RETARGET_DONE"
for i in $(seq 1 2880); do
  if [[ -f "$RETARGET_DONE" ]]; then
    echo "[r9-pipe] retarget done: $(cat "$RETARGET_DONE")"
    break
  fi
  if _past "$SOFT_DEADLINE_UTC"; then
    echo "[r9-pipe] past soft waiting retarget; abort"
    echo "aborted_retarget_wait $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
    exit 1
  fi
  if (( i % 12 == 0 )); then
    echo "[r9-pipe] wait-retarget iter=$i"
  fi
  if (( i == 2880 )); then
    echo "[r9-pipe] TIMEOUT retarget" >&2
    echo "aborted_retarget_timeout $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
    exit 2
  fi
  sleep 10
done

# Confirm :8001 is tolegend/ckp333.
kid=$(curl -s --max-time 5 http://127.0.0.1:8001/v1/models | python3 -c 'import sys,json; print(json.load(sys.stdin)["data"][0]["id"])' 2>/dev/null || echo missing)
echo "[r9-pipe] king:8001 id=$kid"
if [[ "$kid" != *ckp333* && "$kid" != *tolegend* ]]; then
  echo "[r9-pipe] FATAL king not ckp333 (id=$kid)" >&2
  echo "aborted_wrong_king id=$kid $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
  exit 2
fi

# 3b) Wait R2bk (saysth vs ckp333) terminal before yanking chall:8002 (p2155).
R2BK_DEC=${R2BK_DEC:-/root/affine_data/r2bk_saysth_ckp333_decision.json}
R2BK_ALT=${R2BK_ALT:-/root/logs/r2bk_saysth_ckp333_decision.json}
echo "[r9-pipe] waiting R2bk terminal (or idle stack)"
for i in $(seq 1 2880); do
  for f in "$R2BK_DEC" "$R2BK_ALT"; do
    if [[ -f "$f" ]]; then
      hr=$(python3 - <<PY
import json
from pathlib import Path
d=json.loads(Path("$f").read_text())
h=d.get("headroom_vs_live_2se")
if h is None:
  h=d.get("headroom_vs_3se")
print("" if h is None else h)
PY
)
      echo "[r9-pipe] R2bk decision at $f hr=${hr:-none}"
      if [[ -n "${hr:-}" ]] && python3 -c "import sys; sys.exit(0 if float('$hr') >= float('$HEADROOM_BAR') else 1)"; then
        echo "SKIP_R9_R2BK_CLEARS file=$f hr=$hr $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
        exit 0
      fi
      break 2
    fi
  done
  # No R2bk armed and no sim → proceed (older pods).
  if ! pgrep -f 'run_reason_sim.py .*r2bk-saysth' >/dev/null 2>&1 \
     && ! pgrep -f 'launch_r2bk_saysth_vs_ckp333' >/dev/null 2>&1 \
     && [[ ! -f /root/logs/r2bk_saysth_ckp333.pid ]]; then
    echo "[r9-pipe] no R2bk armed — proceed"
    break
  fi
  if ! pgrep -f 'run_reason_sim.py .*r2bk-saysth' >/dev/null 2>&1 \
     && [[ -f /root/affine_data/r2bk_saysth_ckp333_reason_progress.json ]]; then
    n=$(python3 - <<'PY'
import json
from pathlib import Path
p=Path('/root/affine_data/r2bk_saysth_ckp333_reason_progress.json')
d=json.loads(p.read_text())
print(min(int(d.get('challenger') or 0), int(d.get('king') or 0)))
PY
)
    if (( n >= 80 )); then
      echo "[r9-pipe] R2bk progress ≥80/80 and sim gone — proceed"
      break
    fi
  fi
  if _past "$SOFT_DEADLINE_UTC"; then
    echo "[r9-pipe] past soft waiting R2bk; abort"
    echo "aborted_r2bk_wait $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
    exit 1
  fi
  if (( i % 12 == 0 )); then
    crumb=$(python3 -c "from pathlib import Path;p=Path('/root/affine_data/r2bk_saysth_ckp333_reason_progress.json');print(p.read_text().strip() if p.is_file() else 'no-progress')" 2>/dev/null || echo none)
    echo "[r9-pipe] wait-r2bk iter=$i crumb=${crumb:-none}"
  fi
  sleep 10
done

# 3c) Wait R2bl (bittoby-v3) if armed — do not yank chall:8002 mid-screen (p2156).
R2BL_DEC=${R2BL_DEC:-/root/affine_data/r2bl_bittoby_v3_decision.json}
R2BL_ALT=${R2BL_ALT:-/root/logs/r2bl_bittoby_v3_decision.json}
R2BL_PIDF=${R2BL_PIDF:-/root/logs/r2bl_bittoby_v3_reload.pid}
R2BL_HOLD=${R2BL_HOLD:-/root/logs/r2bl_bittoby_v3_holding.stamp}
if [[ -f "$R2BL_PIDF" || -f "$R2BL_HOLD" ]] || pgrep -f 'launch_r2bl_bittoby_v3_reload_sim' >/dev/null 2>&1; then
  echo "[r9-pipe] waiting R2bl terminal before merge (chall shared)"
  for i in $(seq 1 2880); do
    for f in "$R2BL_DEC" "$R2BL_ALT"; do
      if [[ -f "$f" ]]; then
        echo "[r9-pipe] R2bl decision at $f"
        break 2
      fi
    done
    if [[ -f /root/logs/r2bl_bittoby_v3_reload.done ]]; then
      echo "[r9-pipe] R2bl reload.done"
      break
    fi
    r2bl_alive=0
    if [[ -f "$R2BL_PIDF" ]]; then
      bp=$(cat "$R2BL_PIDF" 2>/dev/null || true)
      if [[ -n "${bp:-}" ]] && kill -0 "$bp" 2>/dev/null; then
        r2bl_alive=1
      fi
    fi
    if (( r2bl_alive == 0 )) && [[ ! -f "$R2BL_HOLD" ]] \
       && ! pgrep -f 'launch_r2bl_bittoby_v3_reload_sim' >/dev/null 2>&1 \
       && ! pgrep -f 'run_reason_sim.py .*r2bl-bittoby' >/dev/null 2>&1; then
      echo "[r9-pipe] R2bl idle — proceed"
      break
    fi
    if _past "$SOFT_DEADLINE_UTC"; then
      echo "[r9-pipe] past soft waiting R2bl; abort"
      echo "aborted_r2bl_wait $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
      exit 1
    fi
    if (( i % 12 == 0 )); then
      echo "[r9-pipe] wait-r2bl iter=$i"
    fi
    sleep 10
  done
fi

# 4) Merge on GPUs 6,7.
export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:-6,7}
echo "[r9-pipe] merge LoRA → $MERGED"
rm -rf "$MERGED"
python /root/mining_src/r1-reason-distill/merge_lora.py \
  --base "$BASE" \
  --adapter "$ADAPTER" \
  --out "$MERGED"
ln -sfn "$MERGED" "$LINK"
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/r9_merge.done
echo "[r9-pipe] merge done link=$LINK -> $(readlink -f "$LINK")"

# Refuse weight-identical to Tok base.
python3 - <<PY
import hashlib, json, sys
from pathlib import Path
merged, base = Path("$MERGED"), Path("$BASE")

def window_sha(path: Path, offset: int, nbytes: int = 1 << 20) -> str:
    h = hashlib.sha256()
    size = path.stat().st_size
    off = max(0, min(offset, max(0, size - nbytes)))
    with open(path, "rb") as f:
        f.seek(off)
        h.update(f.read(nbytes))
    return h.hexdigest()

def numbered(p: Path):
    shards = sorted(p.glob("model-*-of-*.safetensors"))
    if shards:
        return shards
    return sorted(x for x in p.glob("model-*.safetensors") if "visual" not in x.name)

ms, bs = numbered(merged), numbered(base)
if not ms or not bs:
    raise SystemExit("REFUSE: missing shards for identity probe")
by = {b.name: b for b in bs}
pairs = [(m, by[m.name]) for m in ms if m.name in by] or list(zip(ms, bs))
any_diff = False
for m, b in pairs:
    size = b.stat().st_size
    if any(
        window_sha(b, o) != window_sha(m, o)
        for o in (0, size // 2, max(0, size - (1 << 20)))
    ):
        any_diff = True
        break
payload = {"identical_to_tok_base": (not any_diff), "n_pairs": len(pairs)}
Path("/root/affine_data/r9_identity.json").write_text(json.dumps(payload, indent=2) + "\n")
print(json.dumps(payload), flush=True)
if not any_diff:
    raise SystemExit("REFUSE: merged weight-identical to Tok init base")
print("[r9-pipe] OK_NON_IDENTICAL", flush=True)
PY

# 5) Kill chall by pidfile only; reload merged on :8002.
unset CUDA_VISIBLE_DEVICES
CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r9-pipe] stopping chall pid=$CPID"
    kill "$CPID" || true
    for j in $(seq 1 60); do
      kill -0 "$CPID" 2>/dev/null || break
      sleep 2
    done
    if kill -0 "$CPID" 2>/dev/null; then
      kill -9 "$CPID" || true
    fi
  fi
fi
sleep 3

if [[ ! -d /root/.triton/cache/chall ]] || [[ -z "$(find /root/.triton/cache/chall -name '*.so' 2>/dev/null | head -1)" ]]; then
  if [[ -d /root/.triton/cache/king ]]; then
    echo "[r9-pipe] seeding chall Triton cache from king"
    mkdir -p /root/.triton/cache/chall
    cp -a /root/.triton/cache/king/. /root/.triton/cache/chall/ || true
  fi
fi

COMMON=(
  --tensor-parallel-size 2
  --max-model-len 65536
  --max-num-batched-tokens 8192
  --attention-backend FLASH_ATTN
  --attention-config.use_trtllm_attention 0
  --compilation-config.pass_config.fuse_allreduce_rms false
  --moe-backend triton
  --additional-config '{"gdn_prefill_backend": "triton"}'
)

echo "[r9-pipe] launching chall :8002 on $LINK"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$LINK" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r9-pipe] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r9-pipe] engines 200/200/200 at iter=$i"
    break
  fi
  CPID=$(cat /root/logs/vllm_chall.pid || true)
  if [[ -n "${CPID:-}" ]] && ! kill -0 "$CPID" 2>/dev/null; then
    echo "[r9-pipe] FATAL chall died; tail vllm_chall.log:" >&2
    tail -40 /root/logs/vllm_chall.log >&2 || true
    echo "aborted_chall_dead $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
    exit 2
  fi
  if (( i % 12 == 0 )); then
    echo "[r9-pipe] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r9-pipe] TIMEOUT engines" >&2
    echo "aborted_engines_timeout $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
    exit 2
  fi
  sleep 5
done
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/r9_chall_serve.done

now=$(date -u +%s)
dead=$(date -u -d "$DEADMAN_UTC" +%s)
if (( dead - now < 2400 )); then
  echo "[r9-pipe] ABORT: <40m to deadman; skip n80"
  echo "aborted_no_n80_budget $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
  exit 1
fi

# 6) Fresh n80 vs ckp333.
rm -f "$SIM_OUT" "$SIM_PROG" "$SIM_DEC"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r9-teacher-zc-{time.time_ns()}".encode()).hexdigest())
PY
)
echo "[r9-pipe] launching R9 n80 vs $KING_REPO@$KING_REV block_hash=${BH:0:16}…"
set +e
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r9-teacher-zc-$(date -u +%Y%m%dT%H%M%SZ)" \
  --king-repo "$KING_REPO" \
  --king-rev "$KING_REV" \
  --chall-repo "$LINK" \
  --chall-rev local \
  --out "$SIM_OUT" \
  --progress-out "$SIM_PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r9_reason_sim.log
sim_rc=${PIPESTATUS[0]}
set -e
if [[ "$sim_rc" -ne 0 || ! -f "$SIM_OUT" ]]; then
  echo "[r9-pipe] ERROR n80 failed rc=$sim_rc"
  echo "aborted_n80_failed rc=$sim_rc $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$ABORT"
  exit 1
fi
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/r9_sim_n80.done

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$SIM_OUT" --out "$SIM_DEC" \
  2>&1 | tee -a /root/logs/r9_reason_sim.log

# Relabel decision for R9 hyp id (write_reason_decision hardcodes R1 strings).
python3 - <<PY
import json
from pathlib import Path
p = Path("$SIM_DEC")
d = json.loads(p.read_text())
dec = str(d.get("decision") or "")
dec = dec.replace("R1_H64_BASELINE", "R9").replace("R1", "R9").replace("FALSE_PROBE_R9", "FALSE_PROBE_R9")
if dec.startswith("REFUTE_R9"):
    dec = "REFUTE_R9"
elif "ADVANCE" in dec:
    dec = "ADVANCE_STAGE5_SUBMIT"
elif "SIGNAL_CLEARS" in dec:
    dec = "SIGNAL_CLEARS_KSIGMA_NEED_HEADROOM"
elif "SIGNAL_POS" in dec:
    dec = "SIGNAL_POS_BELOW_KSIGMA"
d["decision"] = dec
d["hyp"] = "R9"
d["king_repo"] = "$KING_REPO"
d["king_rev"] = "$KING_REV"
d["axis"] = "teacher_zc_expanded_tok_lora"
p.write_text(json.dumps(d, indent=2) + "\n")
print(json.dumps(d, indent=2))
PY

# Also stamp /root/logs path used by STATE watchers.
cp -f "$SIM_DEC" /root/logs/r9_decision.json
echo "OK R9 n80 $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
echo "[r9-pipe] PIPELINE_DONE"
cat "$SIM_DEC"
