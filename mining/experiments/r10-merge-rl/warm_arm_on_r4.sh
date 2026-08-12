#!/usr/bin/env bash
# Host → lean warm-arm R10 onto TKC-hot mine-r4-fullft-1 (skip bootstrap/prewarm).
set -euo pipefail

ROOT=/home/const/subnet120
POD_NAME=${POD_NAME:-mine-r4-fullft-1}
DST_HOST=${DST_HOST:-86.38.182.50}
DST_PORT=${DST_PORT:-40307}
KNOWN=${KNOWN:-/tmp/${POD_NAME}.known_hosts}
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -o ConnectTimeout=20 -o BatchMode=yes
     -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-r10-warm.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

EXP=r10-merge-rl
mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h1-sft" \
         "$STAGE/s4-h1v2-sft" "$STAGE/$EXP"

cp -a "$ROOT/affine/affine.toml" "$STAGE/affine_pkg/"
cp -a "$ROOT/affine/affine/." "$STAGE/affine_pkg/affine/"
cp -a "$ROOT/affine/evalsrv/." "$STAGE/affine_pkg/evalsrv/"
cp -a "$ROOT/mining/experiments/s3-duel-sim/"*.sh "$STAGE/s3-duel-sim/"
cp -a "$ROOT/mining/experiments/s3-duel-sim/"*.py "$STAGE/s3-duel-sim/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/s4-h2-merge/restart_for_h2.sh" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h2-merge/run_sim_duel.py" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h2-merge/write_merge_decision.py" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h2-merge/watch_form_decision.sh" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h2-merge/watch_n80_retry.sh" "$STAGE/s4-h2-merge/"
cp -a "$ROOT/mining/experiments/s4-h1-sft/merge_lora.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h1-sft/salvage_adapter.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h1-sft/push_merged.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/$EXP/"*.sh "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/$EXP/"*.py "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/$EXP/plan.md" "$STAGE/$EXP/"
test -x "$STAGE/$EXP/lean_warm_boot.sh"

TAR=/tmp/mine-r10-warm-stack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

# shellcheck disable=SC1091
set -a
source "$ROOT/mining/.env"
set +a
umask 077
SOFT=$(date -u -d '+23 hours' +%Y-%m-%dT%H:%M:%SZ)
DEAD=$(date -u -d '+23 hours 30 minutes' +%Y-%m-%dT%H:%M:%SZ)
ENV_TMP=$(mktemp /tmp/mine-r10.env.XXXXXX)
{
  echo "export HF_TOKEN=${HF_TOKEN}"
  echo "export HF_HOME=/root/hf"
  echo "export HF_HUB_ENABLE_HF_TRANSFER=1"
  echo "export HF_XET_HIGH_PERFORMANCE=1"
  echo "export AFFINE_DATA_DIR=/root/affine_data"
  echo "export SOFT_DEADLINE_UTC=${SOFT}"
  echo "export DEADMAN_UTC=${DEAD}"
  echo "export HF_MERGED_REPO=unconst/Affine-5czsc2fc98-r10-merged"
  echo "export HF_LORA_REPO=unconst/Affine-5czsc2fc98-r10-lora"
  echo "export R10_AXIS=merge_rl_tok_sbs"
  echo "export R10_LR=5e-6"
  echo "export R10_LORA_R=16"
  echo "export R10_LORA_A=32"
  echo "export R10_GROUP_SIZE=4"
  echo "export R10_MAX_STEPS=200"
  echo "export BASE=/root/r10/merge_base"
  echo "export KING_REPO=tolegend/Affine-5fqbxvz29b-ckp333"
  echo "export KING_REV=24c137e8a978aea1e2b4abeec594fb6ca943f03c"
  echo "export KING_LOCAL=/root/hf/hub/models--tolegend--Affine-5fqbxvz29b-ckp333/snapshots/24c137e8a978aea1e2b4abeec594fb6ca943f03c"
} >"$ENV_TMP"
chmod 600 "$ENV_TMP"

DATA="$ROOT/mining/experiments/s4-h27-clip-l1-shape/results/winner_za_high_l1.jsonl"
test -s "$DATA"

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/r10 /root/hf'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-r10-warm-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r10/winner_za_high_l1.jsonl"
rm -f "$ENV_TMP"

"${SSH[@]}" 'set -euo pipefail
  tar -C /root/mining_src -xzf /tmp/mine-r10-warm-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/r10-merge-rl/*.sh /root/mining_src/s3-duel-sim/*.sh /root/mining_src/s4-h2-merge/*.sh
  grep -q "R10: merge+RL" /root/mining_src/r10-merge-rl/start_r10.sh
  grep -q "tolegend/Affine-5fqbxvz29b-ckp333" /root/mining_src/r10-merge-rl/post_train_pipeline.sh
  test -x /root/mining_src/r10-merge-rl/lean_warm_boot.sh
  test -s /root/r10/winner_za_high_l1.jsonl
  curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null
  curl -sf --max-time 5 http://127.0.0.1:8001/v1/models >/dev/null
  # Stop finished R7 retry watchers by pidfile only (never pkill -f over SSH).
  for f in /root/logs/h121_n80.pid /root/logs/r7_n80.pid /root/logs/h121_retry.pid \
           /root/affine_data/h121_retry.pid /root/h121/retry.pid; do
    if [[ -f "$f" ]]; then
      pid=$(cat "$f" 2>/dev/null || true)
      if [[ -n "${pid:-}" ]] && kill -0 "$pid" 2>/dev/null; then
        kill "$pid" || true
        echo "killed_pidfile $f $pid"
      fi
    fi
  done
  nohup bash /root/mining_src/r10-merge-rl/lean_warm_boot.sh \
    >/root/logs/r10_lean_warm.nohup 2>&1 &
  echo $! >/root/logs/r10_lean_warm.pid
  sleep 4
  echo LEAN_PID=$(cat /root/logs/r10_lean_warm.pid)
  head -n 50 /root/logs/r10_lean_warm.log 2>/dev/null \
    || head -n 50 /root/logs/r10_lean_warm.nohup || true
  ps -p "$(cat /root/logs/r10_lean_warm.pid)" -o pid,etime,cmd || true
  curl -s -o /dev/null -w "t=%{http_code} " --max-time 3 http://127.0.0.1:8000/health || true
  curl -s -o /dev/null -w "k=%{http_code}\n" --max-time 3 http://127.0.0.1:8001/health || true
'

echo "R10_WARM_ARM_OK pod=$POD_NAME soft=$SOFT dead=$DEAD $(date -u +%Y-%m-%dT%H:%M:%SZ)"
