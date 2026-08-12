#!/usr/bin/env bash
# R2bn: after R2bm (tttt guass REFUTE) + R9 still in train-wait, serve pure
# athena2634/Affine-5h3msswruf-alloy (queue chal-00525; Qwen3_5Moe, 9 shards)
# as chall → n80 vs ckp333. Prefer HF-id serve. Wait full snapshot.
# If host hist stamps Reason− (hr≤0), SKIP without burning n80.
# Kill chall by PID file only. Never touch teacher/king.
# Pre-reg: ADVANCE iff margin ≥ 1.5×(k_sigma·SE), live kσ=2.
set -euo pipefail
LOG=/root/logs/r2bn_alloy_reload.log
DONE=/root/logs/r2bn_alloy_reload.done
PIDF=/root/logs/r2bn_alloy_reload.pid
HOLDING=${HOLDING:-/root/logs/r2bn_alloy_holding.stamp}
mkdir -p /root/logs /root/affine_data /root/r2_out
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2bn-alloy] $(date -u +%Y-%m-%dT%H:%M:%SZ) start p2180"
if [[ -f "$DONE" ]]; then
  echo "[r2bn-alloy] already done: $(cat "$DONE")"
  exit 0
fi

HEADROOM_BAR=${HEADROOM_BAR:-1.5}
ALLOY_REPO=${ALLOY_REPO:-athena2634/Affine-5h3msswruf-alloy}
ALLOY_REV=${ALLOY_REV:-74a6ac4d57beda2a9dff604c0d9799959aa676dc}
ALLOY_SNAP=${ALLOY_SNAP:-/root/hf/hub/models--athena2634--Affine-5h3msswruf-alloy/snapshots/${ALLOY_REV}}
CHALL_DIR=${CHALL_DIR:-/root/r2_out/alloy_chall}
LINK=${LINK:-/tmp/r2bn_alloy}
WARM=${WARM_DONE:-/root/logs/warm_stack_ready.done}
PREFETCH_DONE=${PREFETCH_DONE:-/root/logs/r2_prefetch_alloy.done}
R2BM_DEC=${R2BM_DEC:-/root/affine_data/r2bm_tttt_guass_decision.json}
R2BM_ALT=${R2BM_ALT:-/root/logs/r2bm_tttt_guass_decision.json}
REASON_STAMP=${REASON_STAMP:-/root/affine_data/chal00525_reason.json}
KING_REPO=${KING_REPO:-tolegend/Affine-5fqbxvz29b-ckp333}
KING_REV=${KING_REV:-24c137e8a978aea1e2b4abeec594fb6ca943f03c}
N_SHARDS_EXPECT=${N_SHARDS_EXPECT:-9}
SOFT_DEADLINE_UTC=${SOFT_DEADLINE_UTC:-2026-08-12T12:00:00Z}

_past() {
  local deadline=$1
  local now dead
  now=$(date -u +%s)
  dead=$(date -u -d "$deadline" +%s)
  (( now > dead ))
}

headroom_ok() {
  local f="$1"
  python - <<PY
import json
from pathlib import Path
p=Path("$f")
if not p.is_file():
    raise SystemExit(1)
d=json.loads(p.read_text())
h=d.get("headroom_vs_live_2se")
if h is None:
    h=d.get("headroom_vs_3se")
raise SystemExit(0 if h is not None and float(h)>=float("$HEADROOM_BAR") else 1)
PY
}

# 0) Warm TKC.
echo "[r2bn-alloy] waiting for warm_stack_ready"
for i in $(seq 1 2880); do
  if [[ -f "$WARM" ]]; then
    echo "[r2bn-alloy] warm ready at iter=$i"
    break
  fi
  if (( i == 2880 )); then
    echo "[r2bn-alloy] TIMEOUT warm" >&2
    exit 2
  fi
  sleep 10
done

# 1) Wait R2bm terminal. Skip R2bn if guass already clears Stage-5 bar.
echo "[r2bn-alloy] waiting R2bm terminal"
for i in $(seq 1 2880); do
  for f in "$R2BM_DEC" "$R2BM_ALT"; do
    if [[ -f "$f" ]]; then
      if headroom_ok "$f"; then
        echo "SKIP_R2BN_R2BM_CLEARS file=$f $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
        exit 0
      fi
      echo "[r2bn-alloy] R2bm terminal at $f iter=$i"
      break 2
    fi
  done
  if _past "$SOFT_DEADLINE_UTC"; then
    echo "[r2bn-alloy] past soft waiting R2bm; abort" >&2
    exit 1
  fi
  if (( i % 12 == 0 )); then
    echo "[r2bn-alloy] wait-r2bm iter=$i"
  fi
  if (( i == 2880 )); then
    echo "[r2bn-alloy] TIMEOUT R2bm" >&2
    exit 2
  fi
  sleep 10
done

# 1b) If board Reason stamp already present with hr≤0, skip n80.
if [[ -f "$REASON_STAMP" ]]; then
  if python - <<PY
import json
from pathlib import Path
d=json.loads(Path("$REASON_STAMP").read_text())
hr=d.get("headroom_vs_3se")
m=d.get("reason_margin")
# SKIP only on scored Reason− (or unservable)
if d.get("accepted") is False and m is None:
    raise SystemExit(0)  # unservable → skip
if hr is not None and float(hr) <= 0:
    raise SystemExit(0)
raise SystemExit(1)
PY
  then
    echo "SKIP_R2BN_BOARD_REASON_NEG $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    cp -f "$REASON_STAMP" /root/affine_data/r2bn_alloy_skip_reason.json 2>/dev/null || true
    exit 0
  fi
  echo "[r2bn-alloy] board Reason stamp present and not ≤0 — proceed"
else
  echo "[r2bn-alloy] no board Reason stamp yet (queue lag) — pure screen vs ckp333"
fi

# 2) R9 pre-merge is safe to take chall.
echo "[r2bn-alloy] checking R9 merge state"
r9_at_merge=0
if [[ -f /root/logs/r9_merge.done || -f /root/logs/r9_chall_serve.done \
      || -f /root/affine_data/r9_reason_progress.json ]]; then
  r9_at_merge=1
fi
if (( r9_at_merge == 1 )); then
  echo "[r2bn-alloy] R9 already at merge/sim — wait for post to finish before yanking chall"
  for i in $(seq 1 2880); do
    if [[ -f /root/logs/r9_pipeline.done || -f /root/logs/r9_pipeline.aborted ]]; then
      echo "[r2bn-alloy] R9 pipeline terminal at iter=$i"
      break
    fi
    if [[ -f /root/logs/r9_post_train.pid ]]; then
      rpid=$(cat /root/logs/r9_post_train.pid 2>/dev/null || true)
      if [[ -z "${rpid:-}" ]] || ! kill -0 "$rpid" 2>/dev/null; then
        echo "[r2bn-alloy] R9 post gone at iter=$i"
        break
      fi
    else
      echo "[r2bn-alloy] no R9 post pid — proceed"
      break
    fi
    if _past "$SOFT_DEADLINE_UTC"; then
      echo "[r2bn-alloy] past soft waiting R9 merge; abort" >&2
      exit 1
    fi
    sleep 10
  done
else
  echo "[r2bn-alloy] R9 pre-merge — proceed to screen"
fi

# 3) Prefetch full snapshot (9 shards for this parent).
alloy_shards_ready() {
  python3 - <<PY
import json
from pathlib import Path
snap = Path("$ALLOY_SNAP")
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

echo "[r2bn-alloy] waiting alloy FULL snapshot (${N_SHARDS_EXPECT} shards)"
for i in $(seq 1 1440); do
  if alloy_shards_ready; then
    echo "[r2bn-alloy] snapshot ready at iter=$i"
    break
  fi
  if [[ -f "$PREFETCH_DONE" ]] && ! alloy_shards_ready; then
    echo "[r2bn-alloy] FATAL prefetch done but shards incomplete" >&2
    exit 2
  fi
  if (( i % 12 == 0 )); then
    n=$(ls -1 "$ALLOY_SNAP"/model-*.safetensors 2>/dev/null | wc -l | tr -d ' ')
    crumb=$(tail -n 2 /root/logs/r2_prefetch_alloy.log 2>/dev/null | tr '\r' '\n' | tail -1 || true)
    echo "[r2bn-alloy] wait-prefetch iter=$i shards=${n:-0}/${N_SHARDS_EXPECT} crumb=${crumb:-none}"
  fi
  if (( i == 1440 )); then
    echo "[r2bn-alloy] TIMEOUT prefetch" >&2
    exit 2
  fi
  sleep 10
done

mkdir -p "$CHALL_DIR"
for f in "$ALLOY_SNAP"/*; do
  base=$(basename "$f")
  [[ "$base" == "." || "$base" == ".." ]] && continue
  ln -sfn "$(readlink -f "$f")" "$CHALL_DIR/$base"
done
if [[ ! -f "$CHALL_DIR/preprocessor_config.json" ]]; then
  if [[ -f "$CHALL_DIR/processor_config.json" ]]; then
    cp -L "$CHALL_DIR/processor_config.json" "$CHALL_DIR/preprocessor_config.json"
  else
    KING_PP=/root/hf/hub/models--tolegend--Affine-5fqbxvz29b-ckp333/snapshots/${KING_REV}/preprocessor_config.json
    [[ -f "$KING_PP" ]] || KING_PP=/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53/preprocessor_config.json
    cp -L "$KING_PP" "$CHALL_DIR/preprocessor_config.json"
  fi
fi
echo "[r2bn-alloy] chall dir ready: $CHALL_DIR"

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
[[ -L /usr/local/cuda ]] && rm -f /usr/local/cuda

ln -sfn "$CHALL_DIR" "$LINK"
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) claiming chall pure-alloy" >"$HOLDING"
trap 'rm -f "$HOLDING"' EXIT

# Do not yank while R9 holds chall mid-merge.
if [[ -f /root/logs/r9_post_train.pid ]]; then
  RP=$(cat /root/logs/r9_post_train.pid || true)
  if [[ -n "${RP:-}" ]] && kill -0 "$RP" 2>/dev/null; then
    if [[ -f /root/logs/r9_merge.done || -f /root/logs/r9_chall_serve.done || -f /root/affine_data/r9_reason_progress.json ]]; then
      echo "[r2bn-alloy] waiting R9 post pid=$RP (merge/sim active)"
      for j in $(seq 1 1440); do
        kill -0 "$RP" 2>/dev/null || break
        sleep 10
      done
    else
      echo "[r2bn-alloy] R9 post alive but pre-merge — ok to take chall"
    fi
  fi
fi

CHALL_PID_FILE=/root/logs/vllm_chall.pid
if [[ -f "$CHALL_PID_FILE" ]]; then
  CPID=$(cat "$CHALL_PID_FILE" || true)
  if [[ -n "${CPID:-}" ]] && kill -0 "$CPID" 2>/dev/null; then
    echo "[r2bn-alloy] stopping chall pid=$CPID"
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
    echo "[r2bn-alloy] killing leftover chall orphan pid=$op"
    kill "$op" 2>/dev/null || true
  fi
done
for op in $(pgrep -f 'vllm serve .*--port 8002' 2>/dev/null || true); do
  if [[ "$op" != "$$" ]] && kill -0 "$op" 2>/dev/null; then
    kill "$op" 2>/dev/null || true
  fi
done
sleep 2

if [[ ! -d /root/.triton/cache/chall ]] || [[ -z "$(find /root/.triton/cache/chall -name '*.so' 2>/dev/null | head -1)" ]]; then
  if [[ -d /root/.triton/cache/king ]]; then
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

echo "[r2bn-alloy] launching chall :8002 $ALLOY_REPO@$ALLOY_REV"
CUDA_VISIBLE_DEVICES=4,5 TRITON_CACHE_DIR=/root/.triton/cache/chall \
  nohup /root/venv/bin/vllm serve "$ALLOY_REPO" \
    --revision "$ALLOY_REV" \
    --port 8002 --gpu-memory-utilization 0.72 \
    "${COMMON[@]}" \
    >/root/logs/vllm_chall.log 2>&1 &
echo $! >/root/logs/vllm_chall.pid

for i in $(seq 1 480); do
  c0=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/v1/models || true)
  c1=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  c2=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8002/v1/models || true)
  if [[ "$c0$c1$c2" == "200200200" ]]; then
    kid=$(curl -s --max-time 3 http://127.0.0.1:8001/v1/models | python3 -c 'import sys,json; print(json.load(sys.stdin)["data"][0]["id"])')
    cid=$(curl -s --max-time 3 http://127.0.0.1:8002/v1/models | python3 -c 'import sys,json; print(json.load(sys.stdin)["data"][0]["id"])')
    echo "[r2bn-alloy] engines ready king=$kid chall=$cid"
    if [[ "$kid" != *ckp333* && "$kid" != *tolegend* ]]; then
      echo "[r2bn-alloy] FATAL king not ckp333: $kid" >&2
      exit 2
    fi
    if [[ "$cid" != *alloy* && "$cid" != *athena2634* ]]; then
      echo "[r2bn-alloy] FATAL chall not alloy: $cid" >&2
      exit 2
    fi
    break
  fi
  CPID=$(cat /root/logs/vllm_chall.pid || true)
  if [[ -n "${CPID:-}" ]] && ! kill -0 "$CPID" 2>/dev/null; then
    echo "[r2bn-alloy] chall died early; UNSERVABLE" >&2
    python3 - <<'PY2'
import json, time
from pathlib import Path
dec={
  "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
  "hyp": "R2bn",
  "decision": "UNSERVABLE_WEIGHT_INIT",
  "serve_mode": "hf_repo_rev",
  "note": "athena2634 alloy HF-id serve failed",
  "repo": "athena2634/Affine-5h3msswruf-alloy",
  "revision": "74a6ac4d57beda2a9dff604c0d9799959aa676dc",
}
Path("/root/affine_data/r2bn_alloy_decision.json").write_text(json.dumps(dec, indent=2)+"\n")
Path("/root/logs/r2bn_alloy_reload.done").write_text(f"UNSERVABLE {dec['utc']}\n")
print(json.dumps(dec, indent=2))
PY2
    exit 3
  fi
  if (( i % 12 == 0 )); then
    echo "[r2bn-alloy] wait-engines iter=$i codes=${c0}/${c1}/${c2}"
  fi
  if (( i == 480 )); then
    echo "[r2bn-alloy] TIMEOUT engines" >&2
    exit 2
  fi
  sleep 5
done

OUT=/root/affine_data/r2bn_alloy_reason_sim.json
DEC=/root/affine_data/r2bn_alloy_decision.json
PROG=/root/affine_data/r2bn_alloy_reason_progress.json
rm -f "$OUT" "$DEC" "$PROG"
BH=$(python - <<'PY'
import hashlib, time
print(hashlib.sha256(f"r2bn-alloy-{time.time_ns()}".encode()).hexdigest())
PY
)

echo "[r2bn-alloy] launching n80 vs $KING_REPO@$KING_REV block_hash=${BH:0:16}…"
python /root/mining_src/r1-reason-distill/run_reason_sim.py \
  --n-turns 80 \
  --block-hash "$BH" \
  --hotkey "local-r2bn-alloy-$(date -u +%Y%m%dT%H:%M:%SZ)" \
  --king-repo "$KING_REPO" \
  --king-rev "$KING_REV" \
  --chall-repo "$ALLOY_REPO" \
  --chall-rev "$ALLOY_REV" \
  --out "$OUT" \
  --progress-out "$PROG" \
  --save-artifact \
  2>&1 | tee /root/logs/r2bn_alloy_reason_sim.log

python /root/mining_src/r1-reason-distill/write_reason_decision.py \
  --sim-result "$OUT" --out "$DEC" --hyp R2bn --k-sigma 2.0 \
  2>&1 | tee -a /root/logs/r2bn_alloy_reason_sim.log

echo "[r2bn-alloy] DONE $(date -u +%Y-%m-%dT%H:%M:%SZ)"
cat "$DEC"
echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$DONE"
cp -f "$DEC" /root/logs/r2bn_alloy_decision.json 2>/dev/null || true
cp -f "$DONE" /root/affine_data/r2bn_alloy_reload.done 2>/dev/null || true
