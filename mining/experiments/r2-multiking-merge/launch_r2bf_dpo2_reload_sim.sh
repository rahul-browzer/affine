#!/usr/bin/env bash
# R2bf: after R2be hope12 n80 resolves below bar / UNSERVABLE, serve pure
# trangd/...-dpo2 (queue chal-00511) as chall -> fresh n80 vs Tok.
# Prefer HF-id serve. Wait R2be terminal + dpo2 full-shard prefetch.
# Kill chall by PID file only. Never touch teacher/king.
set -euo pipefail
LOG=/root/logs/r2bf_dpo2_reload.log
DONE=/root/logs/r2bf_dpo2_reload.done
PIDF=/root/logs/r2bf_dpo2_reload.pid
HOLDING=${HOLDING:-/root/logs/r2bf_dpo2_holding.stamp}
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2bf-dpo2] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2bf-dpo2] already done: $(cat "$DONE")"
  exit 0
fi

HEADROOM_BAR=${HEADROOM_BAR:-1.5}
DPO2_REPO=${DPO2_REPO:-trangd/affine-5dvha3y7cd-dpo2}
DPO2_REV=${DPO2_REV:-90ea78ff67c4e86632d907349ceba3342700e646}
DPO2_SNAP=${DPO2_SNAP:-/root/hf/hub/models--trangd--affine-5dvha3y7cd-dpo2/snapshots/${DPO2_REV}}
CHALL_DIR=${CHALL_DIR:-/root/r2_out/dpo2_chall}
LINK=${LINK:-/tmp/r2bf_dpo2}
BOARD_REASON=${BOARD_REASON:-/root/affine_data/chal00511_reason.json}
WARM=${WARM_DONE:-/root/logs/warm_stack_ready.done}
PREFETCH_DONE=${PREFETCH_DONE:-/root/logs/r2_prefetch_dpo2.done}
R2BE_PRIOR_DEC=${R2BE_PRIOR_DEC:-/root/affine_data/r2be_hope12_decision.json}
R2BE_PRIOR_DONE=${R2BE_PRIOR_DONE:-/root/logs/r2be_hope12_reload.done}
STAGE5_R2BE=${STAGE5_R2BE:-/root/affine_data/r2be_stage5_ready.json}
N_SHARDS_EXPECT=${N_SHARDS_EXPECT:-16}

headroom_ok() {
  local f="$1"
  python - <<PY
import json
from pathlib import Path
p=Path("$f")
if not p.is_file():
    raise SystemExit(1)
d=json.loads(p.read_text())
h=d.get("headroom_vs_3se")
raise SystemExit(0 if h is not None and float(h)>=float("$HEADROOM_BAR") else 1)
PY
}

# 0) Wait warm TKC stack.
echo "[r2bf-dpo2] waiting for warm_stack_ready"
for i in $(seq 1 2880); do
  if [[ -f "$WARM" ]]; then
    echo "[r2bf-dpo2] warm ready at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2bf-dpo2] wait-warm iter=$i"
  fi
  if (( i == 2880 )); then
    echo "[r2bf-dpo2] TIMEOUT waiting warm_stack_ready" >&2
    exit 2
  fi
  sleep 10
done

# 1) Wait R2be terminal. Skip if R2be already clears Stage-5 / ≥1.5×.
echo "[r2bf-dpo2] waiting for R2be terminal (pure dpo2 next)"
for i in $(seq 1 2880); do
  if [[ -f "$STAGE5_R2BE" ]]; then
    echo "SKIP_R2BF_R2BE_STAGE5 $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2BE_PRIOR_DEC" ]] && headroom_ok "$R2BE_PRIOR_DEC"; then
    echo "SKIP_R2BF_R2BE_CLEARS file=$R2BE_PRIOR_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2BE_PRIOR_DONE" || -f "$R2BE_PRIOR_DEC" ]]; then
    echo "[r2bf-dpo2] R2be terminal at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(python3 -c "from pathlib import Path;p=Path('/root/affine_data/r2be_hope12_reason_progress.json');
print(p.read_text().strip() if p.is_file() else 'no-progress')" 2>/dev/null || echo none)
    echo "[r2bf-dpo2] wait-r2be iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "[r2bf-dpo2] TIMEOUT waiting R2be" >&2
    exit 2
  fi
  sleep 10
done

# 2) Board-first skip if chal-00511 already known hr < 1.5×.
if [[ -f "$BOARD_REASON" ]]; then
  hr=$(python3 - <<PY
import json
from pathlib import Path
d=json.loads(Path("$BOARD_REASON").read_text())
h=d.get("headroom_vs_3se")
print("" if h is None else h)
PY
)
  if [[ -n "${hr}" ]]; then
    skip=$(python3 -c "print(1 if float('$hr') < float('$HEADROOM_BAR') else 0)")
    if [[ "$skip" == "1" ]]; then
      echo "SKIP_BOARD_SUB_BAR hr=$hr bar=$HEADROOM_BAR $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
      python3 - <<PY
import json, time
from pathlib import Path
Path("/root/affine_data/r2bf_dpo2_decision.json").write_text(json.dumps({
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hyp": "R2bf",
    "decision": "SKIP_BOARD_FIRST",
    "headroom_vs_3se": float("$hr"),
    "headroom_bar": float("$HEADROOM_BAR"),
    "note": "board chal-00511 hr already known < 1.5x; do not burn pure-dpo2 n80",
    "board_reason": "$BOARD_REASON",
    "dpo2_repo": "$DPO2_REPO",
    "dpo2_rev": "$DPO2_REV",
}, indent=2) + "\n")
PY
      exit 0
    fi
  fi
fi

# 3) Wait dpo2 prefetch COMPLETE (all shards). Index alone is not enough.
dpo2_shards_ready() {
  python3 - <<PY
import json
from pathlib import Path
snap = Path("$DPO2_SNAP")
idx = snap / "model.safetensors.index.json"
if not idx.is_file():
    raise SystemExit(1)
w = json.loads(idx.read_text())["weight_map"]
shards = sorted(set(w.values()))
if len(shards) < int("$N_SHARDS_EXPECT"):
    raise SystemExit(1)
for sh in shards:
    fp = snap / sh
    try:
        real = fp.resolve()
    except Exception:
        raise SystemExit(1)
    if not real.is_file() or real.stat().st_size <= 0:
        raise SystemExit(1)
raise SystemExit(0)
PY
}

echo "[r2bf-dpo2] waiting for dpo2 FULL snapshot (${N_SHARDS_EXPECT} shards) at $DPO2_SNAP"
for i in $(seq 1 1440); do
  if dpo2_shards_ready; then
    echo "[r2bf-dpo2] dpo2 full snapshot ready at iter=$i ($(date -u +%Y-%m-%dT%H:%M:%SZ))"
    break
  fi
  if [[ -f "$PREFETCH_DONE" ]] && ! dpo2_shards_ready; then
    echo "[r2bf-dpo2] FATAL prefetch done but shards incomplete at $DPO2_SNAP" >&2
    exit 2
  fi
  if (( i % 12 == 0 )); then
    n=$(ls -1 "$DPO2_SNAP"/model-*.safetensors 2>/dev/null | wc -l | tr -d ' ')
    crumb=$(tail -n 2 /root/logs/r2_prefetch_dpo2.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2bf-dpo2] wait-prefetch iter=$i shards=${n:-0}/${N_SHARDS_EXPECT} crumb=${crumb:-none}"
  fi
  if (( i == 1440 )); then
    echo "[r2bf-dpo2] TIMEOUT waiting dpo2 full snapshot" >&2
    exit 2
  fi
  sleep 10
done

# 4) Materialize thin chall dir.
mkdir -p "$CHALL_DIR"
for f in "$DPO2_SNAP"/*; do
  base=$(basename "$f")
  [[ "$base" == "." || "$base" == ".." ]] && continue
  ln -sfn "$(readlink -f "$f")" "$CHALL_DIR/$base"
done
if [[ ! -f "$CHALL_DIR/preprocessor_config.json" ]]; then
  if [[ -f "$CHALL_DIR/processor_config.json" ]]; then
    cp -L "$CHALL_DIR/processor_config.json" "$CHALL_DIR/preprocessor_config.json"
    echo "[r2bf-dpo2] derived preprocessor_config.json from processor_config.json"
  else
    KING_PP=/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53/preprocessor_config.json
    if [[ -f "$KING_PP" ]]; then
      cp -L "$KING_PP" "$CHALL_DIR/preprocessor_config.json"
      echo "[r2bf-dpo2] copied preprocessor_config.json from Tok king"
    else
      echo "[r2bf-dpo2] FATAL no processor/preprocessor config" >&2
      exit 2
    fi
  fi
fi
echo "[r2bf-dpo2] chall dir ready: $CHALL_DIR"

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
export AFFINE_DATA_DIR=${AFFINE_DATA_DIR:-/root/affine_data}
export HF_HOME=${HF_HOME:-/root/hf}
export VLLM_USE_DEEP_GEMM=0
export VLLM_USE_FLASHINFER_SAMPLER=0
export VLLM_ALLREDUCE_USE_FLASHINFER=0
export VLLM_MOE_USE_DEEP_GEMM=0
export VLLM_USE_FLASHINFER_MOE_FP16=0
export VLLM_USE_FLASHINFER_MOE_FP4=0
export VLLM_USE_FLASHINFER_MOE_FP8=0

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
fi
if [[ -L /usr/local/cuda ]]; then
  rm -f /usr/local/cuda
fi

ln -sfn "$CHALL_DIR" "$LINK"
echo "[r2bf-dpo2] link $LINK -> $(readlink -f "$LINK")"

echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) claiming chall pure-dpo2" >"$HOLDING"
trap 'rm -f "$HOLDING"' EXIT

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2bf-dpo2] stopping chall pid=$CPID"
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
for op in $(pgrep -f 'VLLM::EngineCore|VLLM::Worker' 2>/dev/null || true); do
  envf="/proc/$op/environ"
  if [[ -r "$envf" ]] && tr '\0' '\n' <"$envf" 2>/dev/null | grep -qx 'CUDA_VISIBLE_DEVICES=4,5'; then
    echo "[r2bf-dpo2] killing leftover chall orphan pid=$op (CUDA 4,5)"
    kill "$op" 2>/dev/null || true
  fi
done
for op in $(pgrep -f 'vllm serve .*--port 8002' 2>/dev/null || true); do
  if [[ "$op" != "$$" ]] && kill -0 "$op" 2>/dev/null; then
    echo "[r2bf-dpo2] killing leftover chall serve pid=$op"
    kill "$op" 2>/dev/null || true
  fi
done
sleep 2

if [[ ! -d /root/.triton/cache/chall ]] || [[ -z "$(find /root/.triton/cache/chall -name '*.so' 2>/dev/null | head -1)" ]]; then
  if [[ -d /root/.triton/cache/king ]]; then
    echo "[r2bf-dpo2] seeding chall Triton cache from king"
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

echo "[r2bf-dpo2] launching chall :8002 on $LINK ($DPO2_REPO@$DPO2_REV)"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$DPO2_REPO" \
    --revision "$DPO2_REV" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2bf-dpo2] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2bf-dpo2] engines 200/200/200 at iter=$i"
    break
  fi
  CPID=$(cat /root/logs/vllm_chall.pid || true)
  if [[ -n "${CPID:-}" ]] && ! kill -0 "$CPID" 2>/dev/null; then
    echo "[r2bf-dpo2] chall died early; stamp UNSERVABLE" >&2
    python3 - <<'PY2'
import json, time
from pathlib import Path
dec={
  "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
  "hyp": "R2bf",
  "decision": "UNSERVABLE_WEIGHT_INIT",
  "serve_mode": "hf_repo_rev",
  "note": "dpo2 HF-id serve failed; next crown parent",
}
Path("/root/affine_data/r2bf_dpo2_decision.json").write_text(json.dumps(dec, indent=2)+"\n")
Path("/root/logs/r2bf_dpo2_reload.done").write_text(f"UNSERVABLE {dec['utc']}\n")
print(json.dumps(dec, indent=2))
PY2
    exit 3
  fi
  if (( i % 12 == 0 )); then
    echo "[r2bf-dpo2] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2bf-dpo2] TIMEOUT engines; see vllm_chall.log" >&2
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2bf_dpo2_reason_sim.json
DEC=/root/affine_data/r2bf_dpo2_decision.json
PROG=/root/affine_data/r2bf_dpo2_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2bf-dpo2-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2bf-dpo2] launching R2bf n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2bf-dpo2-$(date -u +%Y%m%dT%H:%M:%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$DPO2_REPO" \
  --chall-rev "$DPO2_REV" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2bf_dpo2_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2bf \
  2>&1 | tee -a /root/logs/r2bf_dpo2_reason_sim.log

echo "[r2bf-dpo2] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
cp -f "$DEC" /root/logs/r2bf_dpo2_decision.json 2>/dev/null || true
cp -f "$DONE" /root/affine_data/r2bf_dpo2_reload.done 2>/dev/null || true
