#!/usr/bin/env bash
# Host → lean warm-arm R26 onto TKC-hot mine-crown-1 after R17 REFUTE.
# Keeps teacher:8000 + guass:8001; trains Tok LoTemp-GRPO (temp=0.5) on GPUs 6–7.
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

STAGE=$(mktemp -d /tmp/mine-r26-warm.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

EXP=r3-reason-grpo
mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h1-sft" \
         "$STAGE/s4-h1v2-sft" "$STAGE/$EXP" "$STAGE/r26-lotemp-grpo"

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
cp -a "$ROOT/mining/experiments/r26-lotemp-grpo/"*.sh "$STAGE/r26-lotemp-grpo/"
cp -a "$ROOT/mining/experiments/r26-lotemp-grpo/plan.md" "$STAGE/r26-lotemp-grpo/"
# Overlay start for R26 identity grep.
cp -a "$ROOT/mining/experiments/r26-lotemp-grpo/start_r26.sh" "$STAGE/$EXP/start_r3.sh"

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

TAR=/tmp/mine-r26-warm-stack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"

# shellcheck disable=SC1091
set -a
source "$ROOT/mining/.env"
set +a
umask 077
ENV_TMP=$(mktemp /tmp/mine-r26.env.XXXXXX)
{
  echo "export HF_TOKEN=${HF_TOKEN}"
  echo "export HF_HOME=/root/hf"
  echo "export HF_HUB_ENABLE_HF_TRANSFER=1"
  echo "export HF_XET_HIGH_PERFORMANCE=1"
  echo "export AFFINE_DATA_DIR=/root/affine_data"
  echo "export SOFT_DEADLINE_UTC=${SOFT}"
  echo "export DEADMAN_UTC=${DEAD}"
  echo "export HF_LORA_REPO=unconst/Affine-5czsc2fc98-r26-lora"
  echo "export HF_MERGED_REPO=unconst/Affine-5czsc2fc98-r26-merged"
  echo "export R26_AXIS=lotemp_grpo_reason"
  echo "export R26_LR=5e-6"
  echo "export R26_LORA_R=16"
  echo "export R26_LORA_ALPHA=32"
  echo "export R26_GROUP_SIZE=4"
  echo "export R26_MAX_STEPS=200"
  echo "export R26_MAX_LEN=6144"
  echo "export R26_MAX_NEW=512"
  echo "export R26_TEMPERATURE=0.5"
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

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/r3 /root/r26 /root/hf'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-r26-warm-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r3/winner_za_high_l1.jsonl"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r26/winner_za_high_l1.jsonl"
rm -f "$ENV_TMP"

python3 - <<'PY'
import os
from huggingface_hub import HfApi
api = HfApi(token=os.environ["HF_TOKEN"])
for repo in (
    "unconst/Affine-5czsc2fc98-r26-lora",
    "unconst/Affine-5czsc2fc98-r26-merged",
):
    try:
        api.create_repo(repo, private=False, exist_ok=True, repo_type="model")
        print("HF_OK", repo)
    except Exception as e:
        print("HF_ERR", repo, type(e).__name__, e)
PY

"${SSH[@]}" 'set -euo pipefail
  tar -C /root/mining_src -xzf /tmp/mine-r26-warm-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/r3-reason-grpo/*.sh \
           /root/mining_src/r26-lotemp-grpo/*.sh \
           /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h2-merge/*.sh
  test -f /root/mining_src/r3-reason-grpo/train_reason_grpo.py
  grep -q "R26: LoTemp-GRPO" /root/mining_src/r3-reason-grpo/start_r3.sh
  grep -q "temperature=0.5" /root/mining_src/r3-reason-grpo/start_r3.sh
  curl -sf --max-time 5 http://127.0.0.1:8000/v1/models >/dev/null
  curl -sf --max-time 5 http://127.0.0.1:8001/v1/models >/dev/null
  # Stop leftover R17 lean/post/form/sim by pidfile only (never pkill -f).
  for f in /root/logs/r17_lean_warm.pid /root/logs/r17_post_train.pid \
           /root/logs/r17_form_decision.pid /root/logs/r17_n80_guass_p2209.pid \
           /root/logs/h135_sim.pid /root/logs/r3_train.pid /root/logs/r3_post_train.pid \
           /root/logs/watch_n80_retry.pid; do
    if [[ -f "$f" ]]; then
      pid=$(cat "$f" 2>/dev/null || true)
      if [[ -n "${pid:-}" ]] && [[ "$pid" =~ ^[0-9]+$ ]] && kill -0 "$pid" 2>/dev/null; then
        kill "$pid" || true
        echo "killed_pidfile $f $pid"
      fi
    fi
  done
  nohup bash /root/mining_src/r26-lotemp-grpo/lean_warm_boot.sh \
    >/root/logs/r26_lean_warm.nohup 2>&1 &
  echo $! >/root/logs/r26_lean_warm.pid
  sleep 30
  echo LEAN_PID=$(cat /root/logs/r26_lean_warm.pid)
  head -n 80 /root/logs/r26_lean_warm.log 2>/dev/null \
    || head -n 80 /root/logs/r26_lean_warm.nohup || true
  ps -p "$(cat /root/logs/r26_lean_warm.pid)" -o pid,etime,cmd || true
  test -f /root/logs/r3_train.pid && echo TRAIN_PID=$(cat /root/logs/r3_train.pid)
  test -f /root/logs/r26_post_train.pid && echo POST_PID=$(cat /root/logs/r26_post_train.pid)
  curl -s -o /dev/null -w "t=%{http_code} " --max-time 3 http://127.0.0.1:8000/health || true
  curl -s -o /dev/null -w "k=%{http_code}\n" --max-time 3 http://127.0.0.1:8001/health || true
'

echo "R26_WARM_ARM_OK pod=$POD_NAME soft=$SOFT dead=$DEAD $(date -u +%Y-%m-%dT%H:%M:%SZ)"
