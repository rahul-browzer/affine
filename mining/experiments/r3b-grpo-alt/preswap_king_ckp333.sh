#!/usr/bin/env bash
set -euo pipefail
source /root/venv/bin/activate
set -a; source /root/mine.env; set +a
LOG=/root/logs/r3b_preswap_king.nohup
exec >>"$LOG" 2>&1
echo "[preswap] $(date -u +%Y-%m-%dT%H:%M:%SZ) start king→ckp333 (keep teacher; train GPUs6-7 untouched)"
# Verify teacher healthy before touching anything
code_t=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8000/health || true)
echo "[preswap] teacher health=$code_t"
[[ "$code_t" == "200" ]] || { echo "[preswap] ABORT teacher unhealthy"; exit 1; }
# stop king+chall by pidfile only
for name in king chall; do
  pidf=/root/logs/vllm_${name}.pid
  if [[ -f "$pidf" ]]; then
    pid=$(cat "$pidf")
    if kill -0 "$pid" 2>/dev/null; then
      echo "[preswap] stop $name pid=$pid"
      kill "$pid" || true
      for _ in $(seq 1 40); do kill -0 "$pid" 2>/dev/null || break; sleep 2; done
      kill -9 "$pid" 2>/dev/null || true
    fi
    rm -f "$pidf"
  fi
done
sleep 3
export TEACHER_REPO=zai-org/GLM-4.5-Air-FP8
export KING_REPO=tolegend/Affine-5fqbxvz29b-ckp333
export KING_REV=24c137e8a978aea1e2b4abeec594fb6ca943f03c
export CHALL_REPO=/tmp/r3_merged
unset CHALL_REV
export CHALL_REV=local
# serve_three skips already-running teacher via pidfile
bash /root/mining_src/s3-duel-sim/serve_three.sh
bash /root/mining_src/s3-duel-sim/wait_ready.sh
echo "[preswap] $(date -u +%Y-%m-%dT%H:%M:%SZ) READY"
curl -s http://127.0.0.1:8001/v1/models | head -c 300; echo
curl -s http://127.0.0.1:8000/v1/models | head -c 200; echo
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/r3b_preswap_king.done
echo DONE
