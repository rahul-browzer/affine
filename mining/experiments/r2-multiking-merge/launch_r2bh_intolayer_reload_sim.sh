#!/usr/bin/env bash
# R2bh: after R2bg cp1266 n80 resolves below bar, serve pure
# IntoLayer/...-v1 (queue chal-00516) as chall -> fresh n80 vs Tok.
# Prefer HF-id serve. Wait R2bg terminal + IntoLayer full-shard prefetch.
# Kill chall by PID file only. Never touch teacher/king.
set -euo pipefail
LOG=/root/logs/r2bh_intolayer_reload.log
DONE=/root/logs/r2bh_intolayer_reload.done
PIDF=/root/logs/r2bh_intolayer_reload.pid
HOLDING=${HOLDING:-/root/logs/r2bh_intolayer_holding.stamp}
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2bh-intolayer] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" ]]; then
  echo "[r2bh-intolayer] already done: $(cat "$DONE")"
  exit 0
fi

HEADROOM_BAR=${HEADROOM_BAR:-1.5}
INTOLAYER_REPO=${INTOLAYER_REPO:-IntoLayer/Affine-5g94ihdxwu-v1}
INTOLAYER_REV=${INTOLAYER_REV:-9b6bc52c8aee3ebbeb409f34114ef343c9a0d0b7}
INTOLAYER_SNAP=${INTOLAYER_SNAP:-/root/hf/hub/models--IntoLayer--Affine-5g94ihdxwu-v1/snapshots/${INTOLAYER_REV}}
CHALL_DIR=${CHALL_DIR:-/root/r2_out/intolayer_v1_chall}
LINK=${LINK:-/tmp/r2bh_intolayer}
BOARD_REASON=${BOARD_REASON:-/root/affine_data/chal00516_reason.json}
WARM=${WARM_DONE:-/root/logs/warm_stack_ready.done}
PREFETCH_DONE=${PREFETCH_DONE:-/root/logs/r2_prefetch_intolayer_v1.done}
R2BG_PRIOR_DEC=${R2BG_PRIOR_DEC:-/root/affine_data/r2bg_cp1266_decision.json}
R2BG_PRIOR_DONE=${R2BG_PRIOR_DONE:-/root/logs/r2bg_cp1266_reload.done}
STAGE5_R2BG=${STAGE5_R2BG:-/root/affine_data/r2bg_stage5_ready.json}
N_SHARDS_EXPECT=${N_SHARDS_EXPECT:-2}

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
echo "[r2bh-intolayer] waiting for warm_stack_ready"
for i in $(seq 1 2880); do
  if [[ -f "$WARM" ]]; then
    echo "[r2bh-intolayer] warm ready at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    echo "[r2bh-intolayer] wait-warm iter=$i"
  fi
  if (( i == 2880 )); then
    echo "[r2bh-intolayer] TIMEOUT waiting warm_stack_ready" >&2
    exit 2
  fi
  sleep 10
done

# 1) Wait R2bg terminal. Skip if R2bg already clears Stage-5 / ≥1.5×.
echo "[r2bh-intolayer] waiting for R2bg terminal (pure IntoLayer next)"
for i in $(seq 1 2880); do
  if [[ -f "$STAGE5_R2BG" ]]; then
    echo "SKIP_R2BH_R2BG_STAGE5 $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2BG_PRIOR_DEC" ]] && headroom_ok "$R2BG_PRIOR_DEC"; then
    echo "SKIP_R2BH_R2BG_CLEARS file=$R2BG_PRIOR_DEC $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 0
  fi
  if [[ -f "$R2BG_PRIOR_DONE" || -f "$R2BG_PRIOR_DEC" ]]; then
    echo "[r2bh-intolayer] R2bg terminal at iter=$i $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(python3 -c "from pathlib import Path;p=Path('/root/affine_data/r2bg_cp1266_reason_progress.json');
print(p.read_text().strip() if p.is_file() else 'no-progress')" 2>/dev/null || echo none)
    echo "[r2bh-intolayer] wait-r2bg iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "[r2bh-intolayer] TIMEOUT waiting R2bg" >&2
    exit 2
  fi
  sleep 10
done

# 2) Board-first skip if chal-00516 already known hr < 1.5×.
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
Path("/root/affine_data/r2bh_intolayer_decision.json").write_text(json.dumps({
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "hyp": "R2bh",
    "decision": "SKIP_BOARD_FIRST",
    "headroom_vs_3se": float("$hr"),
    "headroom_bar": float("$HEADROOM_BAR"),
    "note": "board chal-00516 hr already known < 1.5x; do not burn pure-IntoLayer n80",
    "board_reason": "$BOARD_REASON",
    "intolayer_repo": "$INTOLAYER_REPO",
    "intolayer_rev": "$INTOLAYER_REV",
}, indent=2) + "\n")
PY
      exit 0
    fi
  fi
fi

# 3) Wait IntoLayer prefetch COMPLETE (all shards).
intolayer_shards_ready() {
  python3 - <<PY
import json
from pathlib import Path
snap = Path("$INTOLAYER_SNAP")
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

echo "[r2bh-intolayer] waiting for IntoLayer FULL snapshot (${N_SHARDS_EXPECT} shards) at $INTOLAYER_SNAP"
for i in $(seq 1 1440); do
  if intolayer_shards_ready; then
    echo "[r2bh-intolayer] IntoLayer full snapshot ready at iter=$i ($(date -u +%Y-%m-%dT%H:%M:%SZ))"
    break
  fi
  if [[ -f "$PREFETCH_DONE" ]] && ! intolayer_shards_ready; then
    echo "[r2bh-intolayer] FATAL prefetch done but shards incomplete at $INTOLAYER_SNAP" >&2
    exit 2
  fi
  if (( i % 12 == 0 )); then
    n=$(ls -1 "$INTOLAYER_SNAP"/model-*.safetensors 2>/dev/null | wc -l | tr -d ' ')
    crumb=$(tail -n 2 /root/logs/r2_prefetch_intolayer_v1.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2bh-intolayer] wait-prefetch iter=$i shards=${n:-0}/${N_SHARDS_EXPECT} crumb=${crumb:-none}"
  fi
  if (( i == 1440 )); then
    echo "[r2bh-intolayer] TIMEOUT waiting IntoLayer full snapshot" >&2
    exit 2
  fi
  sleep 10
done

# 4) Materialize thin chall dir.
mkdir -p "$CHALL_DIR"
for f in "$INTOLAYER_SNAP"/*; do
  base=$(basename "$f")
  [[ "$base" == "." || "$base" == ".." ]] && continue
  ln -sfn "$(readlink -f "$f")" "$CHALL_DIR/$base"
done
if [[ ! -f "$CHALL_DIR/preprocessor_config.json" ]]; then
  if [[ -f "$CHALL_DIR/processor_config.json" ]]; then
    cp -L "$CHALL_DIR/processor_config.json" "$CHALL_DIR/preprocessor_config.json"
    echo "[r2bh-intolayer] derived preprocessor_config.json from processor_config.json"
  else
    KING_PP=/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53/preprocessor_config.json
    if [[ -f "$KING_PP" ]]; then
      cp -L "$KING_PP" "$CHALL_DIR/preprocessor_config.json"
      echo "[r2bh-intolayer] copied preprocessor_config.json from Tok king"
    else
      echo "[r2bh-intolayer] FATAL no processor/preprocessor config" >&2
      exit 2
    fi
  fi
fi
echo "[r2bh-intolayer] chall dir ready: $CHALL_DIR"

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
echo "[r2bh-intolayer] link $LINK -> $(readlink -f "$LINK")"

echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) claiming chall pure-intolayer" >"$HOLDING"
trap 'rm -f "$HOLDING"' EXIT

# Do not yank chall while R2bg n80 / reload still holds it.
R2BG_RELOAD_PIDF=/root/logs/r2bg_cp1266_reload.pid
if [[ -f "$R2BG_RELOAD_PIDF" ]]; then
  RP=$(cat "$R2BG_RELOAD_PIDF" || true)
  if [[ -n "${RP:-}" ]] && kill -0 "$RP" 2>/dev/null; then
    echo "[r2bh-intolayer] waiting R2bg reload pid=$RP to exit before chall kill"
    for j in $(seq 1 1440); do
      kill -0 "$RP" 2>/dev/null || break
      if (( j % 12 == 0 )); then
        echo "[r2bh-intolayer] wait-r2bg-pid iter=$j"
      fi
      sleep 10
    done
  fi
fi

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2bh-intolayer] stopping chall pid=$CPID"
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
    echo "[r2bh-intolayer] killing leftover chall orphan pid=$op (CUDA 4,5)"
    kill "$op" 2>/dev/null || true
  fi
done
for op in $(pgrep -f 'vllm serve .*--port 8002' 2>/dev/null || true); do
  if [[ "$op" != "$$" ]] && kill -0 "$op" 2>/dev/null; then
    echo "[r2bh-intolayer] killing leftover chall serve pid=$op"
    kill "$op" 2>/dev/null || true
  fi
done
sleep 2

if [[ ! -d /root/.triton/cache/chall ]] || [[ -z "$(find /root/.triton/cache/chall -name '*.so' 2>/dev/null | head -1)" ]]; then
  if [[ -d /root/.triton/cache/king ]]; then
    echo "[r2bh-intolayer] seeding chall Triton cache from king"
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

echo "[r2bh-intolayer] launching chall :8002 on $LINK ($INTOLAYER_REPO@$INTOLAYER_REV)"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$INTOLAYER_REPO" \
    --revision "$INTOLAYER_REV" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid
echo "[r2bh-intolayer] chall pid=$(cat /root/logs/vllm_chall.pid)"

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    echo "[r2bh-intolayer] engines 200/200/200 at iter=$i"
    break
  fi
  CPID=$(cat /root/logs/vllm_chall.pid || true)
  if [[ -n "${CPID:-}" ]] && ! kill -0 "$CPID" 2>/dev/null; then
    echo "[r2bh-intolayer] chall died early; stamp UNSERVABLE" >&2
    python3 - <<'PY2'
import json, time
from pathlib import Path
dec={
  "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
  "hyp": "R2bh",
  "decision": "UNSERVABLE_WEIGHT_INIT",
  "serve_mode": "hf_repo_rev",
  "note": "IntoLayer HF-id serve failed; next crown parent",
}
Path("/root/affine_data/r2bh_intolayer_decision.json").write_text(json.dumps(dec, indent=2)+"\n")
Path("/root/logs/r2bh_intolayer_reload.done").write_text(f"UNSERVABLE {dec['utc']}\n")
print(json.dumps(dec, indent=2))
PY2
    exit 3
  fi
  if (( i % 12 == 0 )); then
    echo "[r2bh-intolayer] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2bh-intolayer] TIMEOUT engines; see vllm_chall.log" >&2
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2bh_intolayer_reason_sim.json
DEC=/root/affine_data/r2bh_intolayer_decision.json
PROG=/root/affine_data/r2bh_intolayer_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2bh-intolayer-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2bh-intolayer] launching R2bh n80 block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2bh-intolayer-$(date -u +%Y%m%dT%H:%M:%SZ)" \
  --king-repo Tok331102/affine-5EqYW8McUc-af10 \
  --king-rev eb8bf9a356a254f71faaa439e8abc3cfba572c53 \
  --chall-repo "$INTOLAYER_REPO" \
  --chall-rev "$INTOLAYER_REV" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2bh_intolayer_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2bh \
  2>&1 | tee -a /root/logs/r2bh_intolayer_reason_sim.log

echo "[r2bh-intolayer] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
cp -f "$DEC" /root/logs/r2bh_intolayer_decision.json 2>/dev/null || true
cp -f "$DONE" /root/affine_data/r2bh_intolayer_reload.done 2>/dev/null || true
