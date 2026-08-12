#!/usr/bin/env bash
# Host → lean warm-arm R16 onto TKC-hot mine-crown-1 after R9 REFUTE.
# Keeps teacher:8000 + ckp333:8001; trains golden-REINFORCE on GPUs 6–7.
set -euo pipefail

ROOT=/home/const/subnet120
POD_NAME=${POD_NAME:-mine-crown-1}
DST_HOST=${DST_HOST:-95.133.253.90}
DST_PORT=${DST_PORT:-40099}
KNOWN=${KNOWN:-/tmp/${POD_NAME}.known_hosts}
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -o ConnectTimeout=20 -o BatchMode=yes
     -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-r16-warm.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

EXP=s4-h135-f40-kevin-rl-l2
mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h1-sft" \
         "$STAGE/s4-h1v2-sft" "$STAGE/$EXP" "$STAGE/r16-golden-rl"

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
cp -a "$ROOT/mining/experiments/$EXP/plan.md" "$STAGE/$EXP/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/r16-golden-rl/"*.sh "$STAGE/r16-golden-rl/"
cp -a "$ROOT/mining/experiments/r16-golden-rl/plan.md" "$STAGE/r16-golden-rl/"
# Overlay start/bootstrap for R16 identity grep.
cp -a "$ROOT/mining/experiments/r16-golden-rl/start_r16.sh" "$STAGE/$EXP/start_h135.sh"
cp -a "$ROOT/mining/experiments/r16-golden-rl/bootstrap_r16.sh" "$STAGE/$EXP/bootstrap_h135.sh"

# Soft/Dead must be BEFORE pod Removal (LESSONS TTL−1h / TTL−30m).
REMOVE_AT=${REMOVE_AT:-2026-08-13T02:35:59Z}
SOFT=$(date -u -d "$REMOVE_AT - 1 hour" +%Y-%m-%dT%H:%M:%SZ)
DEAD=$(date -u -d "$REMOVE_AT - 30 minutes" +%Y-%m-%dT%H:%M:%SZ)
SOFT="$SOFT" DEAD="$DEAD" STAGE_POST="$STAGE/$EXP/post_train_pipeline.sh" python3 - <<'PY'
from pathlib import Path
import os, re
soft, dead = os.environ["SOFT"], os.environ["DEAD"]
p = Path(os.environ["STAGE_POST"])
t = p.read_text()
t2, n1 = re.subn(
    r"SOFT_DEADLINE_UTC=\$\{SOFT_DEADLINE_UTC:-[^}]+\}",
    "SOFT_DEADLINE_UTC=${SOFT_DEADLINE_UTC:-%s}" % soft,
    t,
    count=1,
)
t3, n2 = re.subn(
    r"DEADMAN_UTC=\$\{DEADMAN_UTC:-[^}]+\}",
    "DEADMAN_UTC=${DEADMAN_UTC:-%s}" % dead,
    t2,
    count=1,
)
p.write_text(t3)
print("deadline_patch soft", n1, "dead", n2, soft, dead)
PY

TAR=/tmp/mine-r16-warm-stack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

# shellcheck disable=SC1091
set -a
source "$ROOT/mining/.env"
set +a
umask 077
ENV_TMP=$(mktemp /tmp/mine-r16.env.XXXXXX)
{
  echo "export HF_TOKEN=${HF_TOKEN}"
  echo "export HF_HOME=/root/hf"
  echo "export HF_HUB_ENABLE_HF_TRANSFER=1"
  echo "export HF_XET_HIGH_PERFORMANCE=1"
  echo "export AFFINE_DATA_DIR=/root/affine_data"
  echo "export SOFT_DEADLINE_UTC=${SOFT}"
  echo "export DEADMAN_UTC=${DEAD}"
  echo "export HF_MERGED_REPO=unconst/Affine-5czsc2fc98-r16-golden-rl"
  echo "export R16_AXIS=golden_reinforce_reason"
  echo "export R16_LR=5e-6"
  echo "export R16_LORA_R=16"
  echo "export R16_LORA_ALPHA=32"
  echo "export R16_GROUP_SIZE=2"
  echo "export R16_MAX_STEPS=200"
  echo "export R16_MAX_NEW=256"
  echo "export KING_REPO=tolegend/Affine-5fqbxvz29b-ckp333"
  echo "export KING_REV=24c137e8a978aea1e2b4abeec594fb6ca943f03c"
  echo "export KING_LOCAL=/root/hf/hub/models--tolegend--Affine-5fqbxvz29b-ckp333/snapshots/24c137e8a978aea1e2b4abeec594fb6ca943f03c"
  echo "export RESTART_KING=0"
} >"$ENV_TMP"
chmod 600 "$ENV_TMP"

DATA="$ROOT/mining/experiments/s4-h27-clip-l1-shape/results/winner_za_high_l1.jsonl"
test -s "$DATA"
test "$(wc -l <"$DATA")" -ge 300

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/h135 /root/r16 /root/hf'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-r16-warm-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/h135/winner_za_high_l1.jsonl"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r16/winner_za_high_l1.jsonl"
rm -f "$ENV_TMP"

python3 - <<'PY'
import os
from huggingface_hub import HfApi
api = HfApi(token=os.environ["HF_TOKEN"])
for repo in (
    "unconst/Affine-5czsc2fc98-r16-golden-rl",
    "unconst/Affine-5czsc2fc98-r16-golden-rl-lora",
):
    try:
        api.create_repo(repo, private=False, exist_ok=True, repo_type="model")
        print("HF_OK", repo)
    except Exception as e:
        print("HF_ERR", repo, type(e).__name__, e)
PY

"${SSH[@]}" 'set -euo pipefail
  tar -C /root/mining_src -xzf /tmp/mine-r16-warm-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/s4-h135-f40-kevin-rl-l2/*.sh \
           /root/mining_src/r16-golden-rl/*.sh \
           /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h2-merge/*.sh
  test -f /root/mining_src/s4-h135-f40-kevin-rl-l2/train_rl_l2.py
  grep -q "R16: golden-REINFORCE" /root/mining_src/s4-h135-f40-kevin-rl-l2/start_h135.sh
  curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null
  curl -sf --max-time 5 http://127.0.0.1:8001/v1/models >/dev/null
  # Stop leftover R9 lean/post/form by pidfile only (never pkill -f).
  for f in /root/logs/r9_lean_warm.pid /root/logs/r9_post_train.pid \
           /root/logs/r9_form_decision.pid /root/logs/r9_train.pid \
           /root/logs/h135_train.pid /root/logs/h135_post_train.pid \
           /root/logs/r9_n80.pid /root/logs/h99_train.pid; do
    if [[ -f "$f" ]]; then
      pid=$(cat "$f" 2>/dev/null || true)
      if [[ -n "${pid:-}" ]] && [[ "$pid" =~ ^[0-9]+$ ]] && kill -0 "$pid" 2>/dev/null; then
        kill "$pid" || true
        echo "killed_pidfile $f $pid"
      fi
    fi
  done
  nohup bash /root/mining_src/r16-golden-rl/lean_warm_boot.sh \
    >/root/logs/r16_lean_warm.nohup 2>&1 &
  echo $! >/root/logs/r16_lean_warm.pid
  sleep 15
  echo LEAN_PID=$(cat /root/logs/r16_lean_warm.pid)
  head -n 80 /root/logs/r16_lean_warm.log 2>/dev/null \
    || head -n 80 /root/logs/r16_lean_warm.nohup || true
  ps -p "$(cat /root/logs/r16_lean_warm.pid)" -o pid,etime,cmd || true
  test -f /root/logs/h135_train.pid && echo TRAIN_PID=$(cat /root/logs/h135_train.pid)
  test -f /root/logs/r16_post_train.pid && echo POST_PID=$(cat /root/logs/r16_post_train.pid)
  curl -s -o /dev/null -w "t=%{http_code} " --max-time 3 http://127.0.0.1:8000/health || true
  curl -s -o /dev/null -w "k=%{http_code}\n" --max-time 3 http://127.0.0.1:8001/health || true
'

echo "R16_WARM_ARM_OK pod=$POD_NAME soft=$SOFT dead=$DEAD $(date -u +%Y-%m-%dT%H:%M:%SZ)"
