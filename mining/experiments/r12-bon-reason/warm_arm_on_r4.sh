#!/usr/bin/env bash
# Host → lean warm-arm R12 onto TKC-hot mine-r4-fullft-1 after R11 REFUTE.
# Keeps teacher:8000 + ckp333:8001; trains BoN-CE on GPUs 6–7.
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

STAGE=$(mktemp -d /tmp/mine-r12-warm.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

EXP=s4-h137-f42-tok-bon-l2
mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h1-sft" \
         "$STAGE/s4-h1v2-sft" "$STAGE/$EXP" "$STAGE/r12-bon-reason"

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
cp -a "$ROOT/mining/experiments/r12-bon-reason/"*.sh "$STAGE/r12-bon-reason/"
cp -a "$ROOT/mining/experiments/r12-bon-reason/plan.md" "$STAGE/r12-bon-reason/"
# Overlay start/bootstrap for R12 identity grep.
cp -a "$ROOT/mining/experiments/r12-bon-reason/start_r12.sh" "$STAGE/$EXP/start_h137.sh"
cp -a "$ROOT/mining/experiments/r12-bon-reason/bootstrap_r12.sh" "$STAGE/$EXP/bootstrap_h137.sh"

SOFT=$(date -u -d '+23 hours' +%Y-%m-%dT%H:%M:%SZ)
DEAD=$(date -u -d '+23 hours 30 minutes' +%Y-%m-%dT%H:%M:%SZ)
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

TAR=/tmp/mine-r12-warm-stack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

# shellcheck disable=SC1091
set -a
source "$ROOT/mining/.env"
set +a
umask 077
ENV_TMP=$(mktemp /tmp/mine-r12.env.XXXXXX)
{
  echo "export HF_TOKEN=${HF_TOKEN}"
  echo "export HF_HOME=/root/hf"
  echo "export HF_HUB_ENABLE_HF_TRANSFER=1"
  echo "export HF_XET_HIGH_PERFORMANCE=1"
  echo "export AFFINE_DATA_DIR=/root/affine_data"
  echo "export SOFT_DEADLINE_UTC=${SOFT}"
  echo "export DEADMAN_UTC=${DEAD}"
  echo "export HF_MERGED_REPO=unconst/Affine-5czsc2fc98-r12-bon"
  echo "export R12_AXIS=bon_reason"
  echo "export R12_LR=5e-6"
  echo "export R12_LORA_R=16"
  echo "export R12_LORA_ALPHA=32"
  echo "export R12_GROUP=4"
  echo "export R12_MAX_STEPS=150"
  echo "export R12_TEMP=0.8"
  echo "export KING_REPO=tolegend/Affine-5fqbxvz29b-ckp333"
  echo "export KING_REV=24c137e8a978aea1e2b4abeec594fb6ca943f03c"
  echo "export KING_LOCAL=/root/hf/hub/models--tolegend--Affine-5fqbxvz29b-ckp333/snapshots/24c137e8a978aea1e2b4abeec594fb6ca943f03c"
} >"$ENV_TMP"
chmod 600 "$ENV_TMP"

DATA="$ROOT/mining/experiments/s4-h27-clip-l1-shape/results/winner_za_high_l1.jsonl"
test -s "$DATA"

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/h137 /root/r12 /root/hf'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-r12-warm-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/h137/winner_za_high_l1.jsonl"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r12/winner_za_high_l1.jsonl"
rm -f "$ENV_TMP"

python3 - <<'PY'
import os
from huggingface_hub import HfApi
api = HfApi(token=os.environ["HF_TOKEN"])
for repo in (
    "unconst/Affine-5czsc2fc98-r12-bon",
    "unconst/Affine-5czsc2fc98-r12-bon-lora",
):
    try:
        api.create_repo(repo, private=False, exist_ok=True, repo_type="model")
        print("HF_OK", repo)
    except Exception as e:
        print("HF_ERR", repo, type(e).__name__, e)
PY

"${SSH[@]}" 'set -euo pipefail
  tar -C /root/mining_src -xzf /tmp/mine-r12-warm-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/s4-h137-f42-tok-bon-l2/*.sh \
           /root/mining_src/r12-bon-reason/*.sh \
           /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h2-merge/*.sh
  test -f /root/mining_src/s4-h137-f42-tok-bon-l2/train_bon_l2.py
  grep -q "R12: BoN-CE" /root/mining_src/s4-h137-f42-tok-bon-l2/start_h137.sh
  curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null
  curl -sf --max-time 5 http://127.0.0.1:8001/v1/models >/dev/null
  # Stop leftover R11 lean/post by pidfile only (never pkill -f).
  for f in /root/logs/r11_lean_warm.pid /root/logs/r11_post_train.pid \
           /root/logs/h139_post_train.pid /root/logs/r11_form_decision.pid \
           /root/logs/h139_dec_watch.pid; do
    if [[ -f "$f" ]]; then
      pid=$(cat "$f" 2>/dev/null || true)
      if [[ -n "${pid:-}" ]] && kill -0 "$pid" 2>/dev/null; then
        kill "$pid" || true
        echo "killed_pidfile $f $pid"
      fi
    fi
  done
  nohup bash /root/mining_src/r12-bon-reason/lean_warm_boot.sh \
    >/root/logs/r12_lean_warm.nohup 2>&1 &
  echo $! >/root/logs/r12_lean_warm.pid
  sleep 8
  echo LEAN_PID=$(cat /root/logs/r12_lean_warm.pid)
  head -n 80 /root/logs/r12_lean_warm.log 2>/dev/null \
    || head -n 80 /root/logs/r12_lean_warm.nohup || true
  ps -p "$(cat /root/logs/r12_lean_warm.pid)" -o pid,etime,cmd || true
  test -f /root/logs/h137_train.pid && echo TRAIN_PID=$(cat /root/logs/h137_train.pid)
  test -f /root/logs/r12_post_train.pid && echo POST_PID=$(cat /root/logs/r12_post_train.pid)
  curl -s -o /dev/null -w "t=%{http_code} " --max-time 3 http://127.0.0.1:8000/health || true
  curl -s -o /dev/null -w "k=%{http_code}\n" --max-time 3 http://127.0.0.1:8001/health || true
'

echo "R12_WARM_ARM_OK pod=$POD_NAME soft=$SOFT dead=$DEAD $(date -u +%Y-%m-%dT%H:%M:%SZ)"
