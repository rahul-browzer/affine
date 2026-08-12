#!/usr/bin/env bash
# Host → lean warm-arm R27 onto TKC-hot mine-r4-fullft-1 after R19 SIGNAL_POS_BELOW.
# Keeps teacher:8000 + guass:8001; trains Tok BigG-GRPO (G=16) on GPUs 6–7.
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

STAGE=$(mktemp -d /tmp/mine-r27-warm.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

EXP=r3-reason-grpo
mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h1-sft" \
         "$STAGE/s4-h1v2-sft" "$STAGE/r1-reason-distill" "$STAGE/$EXP" \
         "$STAGE/r27-bigg-grpo"

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
cp -a "$ROOT/mining/experiments/r1-reason-distill/write_reason_decision.py" \
      "$STAGE/r1-reason-distill/"
cp -a "$ROOT/mining/experiments/r1-reason-distill/graft_visual_weights.py" \
      "$STAGE/r1-reason-distill/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/s4-h1-sft/merge_lora.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h1-sft/salvage_adapter.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h1-sft/push_merged.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/$EXP/"*.sh "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/$EXP/"*.py "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/$EXP/plan.md" "$STAGE/$EXP/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/r27-bigg-grpo/"*.sh "$STAGE/r27-bigg-grpo/"
cp -a "$ROOT/mining/experiments/r27-bigg-grpo/plan.md" "$STAGE/r27-bigg-grpo/"
# Overlay start/bootstrap for R27 identity grep (lean boot calls start_r3.sh).
cp -a "$ROOT/mining/experiments/r27-bigg-grpo/start_r27.sh" "$STAGE/$EXP/start_r3.sh"
cp -a "$ROOT/mining/experiments/r27-bigg-grpo/bootstrap_r27.sh" "$STAGE/$EXP/bootstrap_r3.sh"

# Soft/Dead must be BEFORE pod Removal (LESSONS TTL−1h / TTL−30m).
REMOVE_AT=${REMOVE_AT:-2026-08-13T08:57:47Z}
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

TAR=/tmp/mine-r27-warm-stack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

# shellcheck disable=SC1091
set -a
source "$ROOT/mining/.env"
set +a
umask 077
ENV_TMP=$(mktemp /tmp/mine-r27.env.XXXXXX)
{
  echo "export HF_TOKEN=${HF_TOKEN}"
  echo "export HF_HOME=/root/hf"
  echo "export HF_HUB_ENABLE_HF_TRANSFER=1"
  echo "export HF_XET_HIGH_PERFORMANCE=1"
  echo "export AFFINE_DATA_DIR=/root/affine_data"
  echo "export SOFT_DEADLINE_UTC=${SOFT}"
  echo "export DEADMAN_UTC=${DEAD}"
  echo "export HF_LORA_REPO=unconst/Affine-5czsc2fc98-r27-lora"
  echo "export HF_MERGED_REPO=unconst/Affine-5czsc2fc98-r27-merged"
  echo "export R27_AXIS=bigg_grpo_reason"
  echo "export R27_LR=5e-6"
  echo "export R27_LORA_R=16"
  echo "export R27_LORA_ALPHA=32"
  echo "export R27_GROUP_SIZE=16"
  echo "export R27_MAX_STEPS=200"
  echo "export R27_MAX_LEN=6144"
  echo "export R27_MAX_NEW=512"
  echo "export R27_TEMPERATURE=0.8"
  echo "export KING_REPO=ttttxxxxsada/Affine-5guassq3tu"
  echo "export KING_REV=e86758f5080d1e373e5fbbd7b4fbf6af327aeb44"
  echo "export KING_LOCAL=/root/hf/hub/models--ttttxxxxsada--Affine-5guassq3tu/snapshots/e86758f5080d1e373e5fbbd7b4fbf6af327aeb44"
  echo "export RESTART_KING=0"
  echo "export BASE=/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53"
} >"$ENV_TMP"
chmod 600 "$ENV_TMP"

DATA="$ROOT/mining/experiments/s4-h27-clip-l1-shape/results/winner_za_high_l1.jsonl"
test -s "$DATA"
test "$(wc -l <"$DATA")" -ge 300

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/r3 /root/r27 /root/hf'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-r27-warm-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r3/winner_za_high_l1.jsonl"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r27/winner_za_high_l1.jsonl"
rm -f "$ENV_TMP"

python3 - <<'PY'
import os
from huggingface_hub import HfApi
api = HfApi(token=os.environ["HF_TOKEN"])
for repo in (
    "unconst/Affine-5czsc2fc98-r27-lora",
    "unconst/Affine-5czsc2fc98-r27-merged",
):
    try:
        api.create_repo(repo, private=False, exist_ok=True, repo_type="model")
        print("HF_OK", repo)
    except Exception as e:
        print("HF_ERR", repo, type(e).__name__, e)
PY

"${SSH[@]}" 'set -euo pipefail
  tar -C /root/mining_src -xzf /tmp/mine-r27-warm-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/r3-reason-grpo/*.sh \
           /root/mining_src/r27-bigg-grpo/*.sh \
           /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h2-merge/*.sh
  test -f /root/mining_src/r3-reason-grpo/train_reason_grpo.py
  test -f /root/mining_src/r1-reason-distill/write_reason_decision.py
  grep -q "R27: BigG-GRPO" /root/mining_src/r3-reason-grpo/start_r3.sh
  grep -q "R27_GROUP_SIZE:-16" /root/mining_src/r3-reason-grpo/start_r3.sh
  curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null
  curl -sf --max-time 5 http://127.0.0.1:8001/v1/models >/dev/null
  # Stop leftover R19 sim/train/post by pidfile only (never pkill -f).
  for f in /root/logs/r19_lean_warm.pid /root/logs/r19_post_train.pid \
           /root/logs/r19_form_decision.pid /root/logs/r19_train.pid \
           /root/logs/r3_train.pid /root/logs/r3_post_train.pid \
           /root/logs/r3_pipeline.pid /root/logs/r19_pipeline.pid; do
    if [[ -f "$f" ]]; then
      pid=$(cat "$f" 2>/dev/null || true)
      if [[ -n "${pid:-}" ]] && [[ "$pid" =~ ^[0-9]+$ ]] && kill -0 "$pid" 2>/dev/null; then
        kill "$pid" || true
        echo "killed_pidfile $f $pid"
      fi
    fi
  done
  nohup bash /root/mining_src/r27-bigg-grpo/lean_warm_boot.sh \
    >/root/logs/r27_lean_warm.nohup 2>&1 &
  echo $! >/root/logs/r27_lean_warm.pid
  sleep 25
  echo LEAN_PID=$(cat /root/logs/r27_lean_warm.pid)
  head -n 120 /root/logs/r27_lean_warm.log 2>/dev/null \
    || head -n 120 /root/logs/r27_lean_warm.nohup || true
  ps -p "$(cat /root/logs/r27_lean_warm.pid)" -o pid,etime,cmd || true
  test -f /root/logs/r3_train.pid && echo TRAIN_PID=$(cat /root/logs/r3_train.pid)
  test -f /root/logs/r27_post_train.pid && echo POST_PID=$(cat /root/logs/r27_post_train.pid)
  curl -s -o /dev/null -w "t=%{http_code} " --max-time 3 http://127.0.0.1:8000/health || true
  curl -s -o /dev/null -w "k=%{http_code}\n" --max-time 3 http://127.0.0.1:8001/health || true
'

echo "R27_WARM_ARM_OK pod=$POD_NAME soft=$SOFT dead=$DEAD $(date -u +%Y-%m-%dT%H:%M:%SZ)"
