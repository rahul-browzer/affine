#!/usr/bin/env bash
# Host → mine-r29-hirank-1: R3 stack + R29 HiRank-GRPO overlay, bootstrap.
# Axis R29: Tok-init Reason-GRPO lora_r=64 (≠ R3 r=16 / R3b r64+lr+G).
# p2231: n80 king = live guass + Reason writer + form-dec.
set -euo pipefail

ROOT=/home/const/subnet120
POD_NAME=${POD_NAME:-mine-r29-hirank-1}
DST_HOST=${DST_HOST:?set DST_HOST}
DST_PORT=${DST_PORT:?set DST_PORT}
KNOWN=${KNOWN:-/tmp/${POD_NAME}.known_hosts}
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

STAGE=$(mktemp -d /tmp/mine-r29-stack.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

EXP=r3-reason-grpo
mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
         "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h1-sft" \
         "$STAGE/s4-h1v2-sft" "$STAGE/r1-reason-distill" \
         "$STAGE/$EXP" "$STAGE/r29-hirank-grpo"

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
# p2231: form-dec / post_train Reason crown writer.
cp -a "$ROOT/mining/experiments/r1-reason-distill/write_reason_decision.py" \
      "$STAGE/r1-reason-distill/"
cp -a "$ROOT/mining/experiments/r1-reason-distill/graft_visual_weights.py" \
      "$STAGE/r1-reason-distill/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/s4-h1-sft/merge_lora.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h1-sft/salvage_adapter.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h1-sft/push_merged.py" "$STAGE/s4-h1-sft/"
cp -a "$ROOT/mining/experiments/s4-h1v2-sft/thought_mask.py" "$STAGE/s4-h1v2-sft/" 2>/dev/null || true
cp -a "$ROOT/mining/experiments/$EXP/"*.sh "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/$EXP/"*.py "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/$EXP/plan.md" "$STAGE/$EXP/"
cp -a "$ROOT/mining/experiments/r29-hirank-grpo/plan.md" "$STAGE/r29-hirank-grpo/"
cp -a "$ROOT/mining/experiments/r29-hirank-grpo/start_r29.sh" "$STAGE/r29-hirank-grpo/"
cp -a "$ROOT/mining/experiments/r29-hirank-grpo/bootstrap_r29.sh" "$STAGE/r29-hirank-grpo/"
# Overlay: bootstrap_r3 + start_r3 → R29 HiRank + guass n80 king.
cp -a "$ROOT/mining/experiments/r29-hirank-grpo/start_r29.sh" "$STAGE/$EXP/start_r3.sh"
cp -a "$ROOT/mining/experiments/r29-hirank-grpo/bootstrap_r29.sh" "$STAGE/$EXP/bootstrap_r3.sh"

# Soft/Dead = Removal−1h / Removal−30m from lium describe (never wall-clock +Nh).
# p2237: +23h Soft landed AFTER Removal → post_train outlived the box.
_rem_raw=$(lium describe "$POD_NAME" --json 2>/dev/null \
  | python3 -c 'import sys,json; d=json.load(sys.stdin); print((d.get("billing") or {}).get("removal_scheduled_at") or "")' \
  || true)
if [[ -z "${_rem_raw}" ]]; then
  echo "[r29-up] FATAL: no billing.removal_scheduled_at for POD_NAME=$POD_NAME" >&2
  exit 1
fi
REMOVAL=$(date -u -d "${_rem_raw}" +%Y-%m-%dT%H:%M:%SZ)
SOFT=$(date -u -d "${_rem_raw} -1 hour" +%Y-%m-%dT%H:%M:%SZ)
DEAD=$(date -u -d "${_rem_raw} -30 minutes" +%Y-%m-%dT%H:%M:%SZ)
echo "[r29-up] Removal=$REMOVAL Soft=$SOFT Dead=$DEAD (from lium describe $POD_NAME)"
export STAGE_EXP_POST="$STAGE/$EXP/post_train_pipeline.sh"
export SOFT
export DEAD
python3 - <<'PY'
from pathlib import Path
import re, os
soft, dead = os.environ["SOFT"], os.environ["DEAD"]
p = Path(os.environ["STAGE_EXP_POST"])
t = p.read_text()
t2, n1 = re.subn(
    r"SOFT_DEADLINE_UTC=\$\{SOFT_DEADLINE_UTC:-[^}]+\}",
    f"SOFT_DEADLINE_UTC=${{SOFT_DEADLINE_UTC:-{soft}}}",
    t,
    count=1,
)
t3, n2 = re.subn(
    r"DEADMAN_UTC=\$\{DEADMAN_UTC:-[^}]+\}",
    f"DEADMAN_UTC=${{DEADMAN_UTC:-{dead}}}",
    t2,
    count=1,
)
p.write_text(t3)
print("SOFT_DEADLINE_SET", soft, "n=", n1, "DEADMAN_SET", dead, "n=", n2)
PY

TAR=/tmp/mine-r29-stack.tar.gz
tar -C "$STAGE" -czf "$TAR" .
ls -lh "$TAR"
test -n "$(tar -tzf "$TAR" | grep 'r1-reason-distill/write_reason_decision.py' || true)"
grep -q "DOWNLOAD guass-king" "$STAGE/$EXP/bootstrap_r3.sh"

ENV_TMP=$(mktemp /tmp/mine-r29.env.XXXXXX)
# shellcheck disable=SC1091
set -a
source "$ROOT/mining/.env"
set +a
umask 077
KING_REPO_DEFAULT=ttttxxxxsada/Affine-5guassq3tu
KING_REV_DEFAULT=e86758f5080d1e373e5fbbd7b4fbf6af327aeb44
KING_LOCAL_DEFAULT=/root/hf/hub/models--ttttxxxxsada--Affine-5guassq3tu/snapshots/e86758f5080d1e373e5fbbd7b4fbf6af327aeb44
{
  echo "export HF_TOKEN=${HF_TOKEN}"
  echo "export HF_HOME=/root/hf"
  echo "export HF_HUB_ENABLE_HF_TRANSFER=1"
  echo "export HF_XET_HIGH_PERFORMANCE=1"
  echo "export AFFINE_DATA_DIR=/root/affine_data"
  echo "export SOFT_DEADLINE_UTC=${SOFT}"
  echo "export DEADMAN_UTC=${DEAD}"
  echo "export HF_LORA_REPO=unconst/Affine-5czsc2fc98-r29-lora"
  echo "export HF_MERGED_REPO=unconst/Affine-5czsc2fc98-r29-merged"
  echo "export R29_AXIS=hirank_grpo_reason"
  echo "export R29_LR=5e-6"
  echo "export R29_LORA_R=64"
  echo "export R29_LORA_ALPHA=128"
  echo "export R29_GROUP_SIZE=4"
  echo "export R29_MAX_STEPS=200"
  echo "export R29_MAX_LEN=6144"
  echo "export R29_MAX_NEW=512"
  echo "export R29_TEMPERATURE=0.8"
  echo "export KING_REPO=${KING_REPO_DEFAULT}"
  echo "export KING_REV=${KING_REV_DEFAULT}"
  echo "export KING_LOCAL=${KING_LOCAL_DEFAULT}"
  echo "export RESTART_KING=1"
} >"$ENV_TMP"
chmod 600 "$ENV_TMP"

DATA="$ROOT/mining/experiments/s4-h27-clip-l1-shape/results/winner_za_high_l1.jsonl"
test -s "$DATA"
test "$(wc -l <"$DATA")" -ge 300

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/r3 /root/r29 /root/hf'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-r29-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r3/winner_za_high_l1.jsonl"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r29/winner_za_high_l1.jsonl"
rm -f "$ENV_TMP"

python3 - <<'PY'
import os
from huggingface_hub import HfApi
api = HfApi(token=os.environ["HF_TOKEN"])
for repo in (
    "unconst/Affine-5czsc2fc98-r29-lora",
    "unconst/Affine-5czsc2fc98-r29-merged",
):
    try:
        api.create_repo(repo, private=False, exist_ok=True, repo_type="model")
        print("HF_OK", repo)
    except Exception as e:
        print("HF_ERR", repo, type(e).__name__, e)
PY

"${SSH[@]}" 'set -e
  tar -C /root/mining_src -xzf /tmp/mine-r29-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h2-merge/*.sh \
           /root/mining_src/r3-reason-grpo/*.sh \
           /root/mining_src/r29-hirank-grpo/*.sh
  test -f /root/mining_src/affine_pkg/affine/score.py
  test -s /root/r3/winner_za_high_l1.jsonl
  test -x /root/mining_src/r3-reason-grpo/bootstrap_r3.sh
  test -x /root/mining_src/r3-reason-grpo/start_r3.sh
  # Prove overlay is R29 HiRank; sim king = guass; Reason writer present.
  grep -q "R29: HiRank-GRPO" /root/mining_src/r3-reason-grpo/start_r3.sh
  grep -q "R29_LORA_R:-64" /root/mining_src/r3-reason-grpo/start_r3.sh
  grep -q "DOWNLOAD guass-king" /root/mining_src/r3-reason-grpo/bootstrap_r3.sh
  test -f /root/mining_src/r1-reason-distill/write_reason_decision.py
  set -a; source /root/mine.env; set +a
  test "$KING_REPO" = "ttttxxxxsada/Affine-5guassq3tu"
  echo "R29_DEADLINES soft=$SOFT_DEADLINE_UTC dead=$DEADMAN_UTC axis=$R29_AXIS king=$KING_REPO@$KING_REV"
  echo "R29_KNOBS lr=${R29_LR} G=${R29_GROUP_SIZE} temp=${R29_TEMPERATURE} r=${R29_LORA_R} max_len=${R29_MAX_LEN}"
  echo STACK_UPLOAD_OK
  nohup bash /root/mining_src/r3-reason-grpo/bootstrap_r3.sh \
    >/root/logs/r29_pipeline.nohup 2>&1 &
  echo $! > /root/logs/r29_pipeline.pid
  cp -f /root/logs/r29_pipeline.pid /root/logs/r3_pipeline.pid
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh r3 \
    /root/affine_data/r3_sim_result.json /root/affine_data/r3_decision.json \
    /root/logs/r29_form_decision.nohup \
    >/root/logs/r29_form_decision.launch.out 2>&1 &
  echo $! > /root/logs/r29_form_decision.pid
  echo PIPELINE_PID=$(cat /root/logs/r29_pipeline.pid)
  sleep 5
  head -n 40 /root/logs/bootstrap_r3.log 2>/dev/null || head -n 40 /root/logs/r29_pipeline.nohup || true
  ps -p "$(cat /root/logs/r29_pipeline.pid)" -o pid,etime,cmd || true
  nvidia-smi -L | wc -l
'

echo "UPLOAD_AND_LAUNCH_OK pod=$POD_NAME $(date -u +%Y-%m-%dT%H:%M:%SZ)"
