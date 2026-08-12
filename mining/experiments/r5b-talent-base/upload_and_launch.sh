#!/usr/bin/env bash
# Host → mine-r5-nonking-2: H122 full-FT stack + R5b Talent-base overlay, bootstrap.
# Axis R5b: TalentPigs reign-3 full-FT (≠ R5 Genesis, ≠ R4 Tok).
set -euo pipefail

ROOT=/home/const/subnet120
POD_NAME=${POD_NAME:-mine-r5-nonking-2}
DST_HOST=${DST_HOST:?set DST_HOST}
DST_PORT=${DST_PORT:?set DST_PORT}
KNOWN=${KNOWN:-/tmp/${POD_NAME}.known_hosts}
SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -p "$DST_PORT" "root@$DST_HOST")
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o UserKnownHostsFile="$KNOWN"
     -o StrictHostKeyChecking=accept-new -P "$DST_PORT")

PRESTAGE="$ROOT/mining/experiments/r5b-talent-base/artifacts/mine-r5b-stack.prestaged.tar.gz"
TAR=/tmp/mine-r5b-stack.tar.gz
STAGE=$(mktemp -d /tmp/mine-r5b-stack.XXXXXX)
trap 'rm -rf "$STAGE"' EXIT

EXP=s4-h122-f27-genesis-full-ft
# p2225: reuse prestaged tar when newer than R5b overlay sources (faster snatch boot).
# p2228: also require Reason crown writer inside the tar (form-dec landmine).
_use_pre=0
if [[ -s "$PRESTAGE" ]] \
  && tar -tzf "$PRESTAGE" | grep -q 'r1-reason-distill/write_reason_decision.py'; then
  _newest_src=$(find "$ROOT/mining/experiments/r5b-talent-base" \
    \( -name 'bootstrap_r5b.sh' -o -name 'start_r5b.sh' -o -name 'upload_and_launch.sh' \) \
    -printf '%T@\n' | sort -n | tail -1)
  _pre_m=$(stat -c '%Y' "$PRESTAGE")
  if awk -v a="$_pre_m" -v b="${_newest_src%.*}" 'BEGIN{exit !(a+0 >= b+0)}'; then
    _use_pre=1
  fi
fi
if [[ "$_use_pre" -eq 1 ]]; then
  cp -f "$PRESTAGE" "$TAR"
  echo "[r5b-up] using prestaged stack $(ls -lh "$TAR" | awk '{print $5}')"
else
  mkdir -p "$STAGE/affine_pkg/affine" "$STAGE/affine_pkg/evalsrv" \
           "$STAGE/s3-duel-sim" "$STAGE/s4-h2-merge" "$STAGE/s4-h1-sft" \
           "$STAGE/s4-h1v2-sft" "$STAGE/r1-reason-distill" \
           "$STAGE/$EXP" "$STAGE/r5b-talent-base"

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
  # p2228: form-dec (live crown) needs Reason writer; old prestages omitted it.
  cp -a "$ROOT/mining/experiments/r1-reason-distill/write_reason_decision.py" \
        "$STAGE/r1-reason-distill/"
  cp -a "$ROOT/mining/experiments/r1-reason-distill/graft_visual_weights.py" \
        "$STAGE/r1-reason-distill/" 2>/dev/null || true
  cp -a "$ROOT/mining/experiments/s4-h1-sft/push_merged.py" "$STAGE/s4-h1-sft/"
  cp -a "$ROOT/mining/experiments/s4-h1v2-sft/thought_mask.py" "$STAGE/s4-h1v2-sft/"
  cp -a "$ROOT/mining/experiments/s4-h1v2-sft/verify_thought_mask.py" "$STAGE/s4-h1v2-sft/"
  cp -a "$ROOT/mining/experiments/$EXP/"*.sh "$STAGE/$EXP/"
  cp -a "$ROOT/mining/experiments/$EXP/"*.py "$STAGE/$EXP/"
  cp -a "$ROOT/mining/experiments/$EXP/plan.md" "$STAGE/$EXP/" 2>/dev/null || true
  cp -a "$ROOT/mining/experiments/r5b-talent-base/plan.md" "$STAGE/r5b-talent-base/"
  cp -a "$ROOT/mining/experiments/r5b-talent-base/start_r5b.sh" "$STAGE/r5b-talent-base/"
  cp -a "$ROOT/mining/experiments/r5b-talent-base/bootstrap_r5b.sh" "$STAGE/r5b-talent-base/"
  # Overlay: H122 bootstrap + start → Talent base (not Genesis).
  cp -a "$ROOT/mining/experiments/r5b-talent-base/start_r5b.sh" "$STAGE/$EXP/start_h122.sh"
  cp -a "$ROOT/mining/experiments/r5b-talent-base/bootstrap_r5b.sh" "$STAGE/$EXP/bootstrap_h122.sh"

  tar -C "$STAGE" -czf "$TAR" .
  cp -f "$TAR" "$PRESTAGE"
  echo "[r5b-up] rebuilt stack + prestaged $(ls -lh "$TAR" | awk '{print $5}')"
fi
ls -lh "$TAR"
test -n "$(tar -tzf "$TAR" | grep 'r1-reason-distill/write_reason_decision.py' || true)"

ENV_TMP=$(mktemp /tmp/mine-r5b.env.XXXXXX)
# shellcheck disable=SC1091
set -a
source "$ROOT/mining/.env"
set +a
umask 077
# Soft/Dead = Removal−1h / Removal−30m from lium describe (never wall-clock +Nh).
# p2237: +23h Soft landed AFTER Removal on mine-r4 → post_train would outlive the box.
_rem_raw=$(lium describe "$POD_NAME" --json 2>/dev/null \
  | python3 -c 'import sys,json; d=json.load(sys.stdin); print((d.get("billing") or {}).get("removal_scheduled_at") or "")' \
  || true)
if [[ -z "${_rem_raw}" ]]; then
  echo "[r5b-up] FATAL: no billing.removal_scheduled_at for POD_NAME=$POD_NAME" >&2
  exit 1
fi
# Normalize to Zulu; date -d accepts the Lium form without Z.
REMOVAL=$(date -u -d "${_rem_raw}" +%Y-%m-%dT%H:%M:%SZ)
SOFT=$(date -u -d "${_rem_raw} -1 hour" +%Y-%m-%dT%H:%M:%SZ)
DEAD=$(date -u -d "${_rem_raw} -30 minutes" +%Y-%m-%dT%H:%M:%SZ)
echo "[r5b-up] Removal=$REMOVAL Soft=$SOFT Dead=$DEAD (from lium describe $POD_NAME)"
BASE_DEFAULT=/root/hf/hub/models--TalentPigs--affine-5ekxlcg3fx-abc/snapshots/dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4
# Live reign-6 king (api/v1/snapshot) — override H122 Tok defaults in post_train/n80.
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
  echo "export HF_MERGED_REPO=unconst/Affine-5czsc2fc98-r5b-talent"
  echo "export R5B_AXIS=talent_fullft"
  echo "export R5B_LR=1e-6"
  echo "export R5B_EPOCHS=1"
  echo "export R5B_MAX_LEN=8192"
  echo "export BASE=${BASE_DEFAULT}"
  echo "export KING_REPO=${KING_REPO_DEFAULT}"
  echo "export KING_REV=${KING_REV_DEFAULT}"
  echo "export KING_LOCAL=${KING_LOCAL_DEFAULT}"
} >"$ENV_TMP"
chmod 600 "$ENV_TMP"

DATA="$ROOT/mining/experiments/s4-h27-clip-l1-shape/results/winner_za_high_l1.jsonl"
test -s "$DATA"
test "$(wc -l <"$DATA")" -ge 300

"${SSH[@]}" 'mkdir -p /root/mining_src /root/affine_data /root/logs /root/h122 /root/r5b /root/hf'
"${SCP[@]}" "$TAR" "root@${DST_HOST}:/tmp/mine-r5b-stack.tar.gz"
"${SCP[@]}" "$ENV_TMP" "root@${DST_HOST}:/root/mine.env"
# H122 bootstrap expects this path/name; content is the Reason high-za set.
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/h122/winner_za_high_l2.jsonl"
"${SCP[@]}" "$DATA" "root@${DST_HOST}:/root/r5b/winner_za_high_l1.jsonl"
rm -f "$ENV_TMP"

python3 - <<'PY'
import os
from huggingface_hub import HfApi
api = HfApi(token=os.environ["HF_TOKEN"])
repo = "unconst/Affine-5czsc2fc98-r5b-talent"
try:
    api.create_repo(repo, private=False, exist_ok=True, repo_type="model")
    print("HF_OK", repo)
except Exception as e:
    print("HF_ERR", repo, type(e).__name__, e)
PY

"${SSH[@]}" 'set -e
  tar -C /root/mining_src -xzf /tmp/mine-r5b-stack.tar.gz
  chmod 600 /root/mine.env
  chmod +x /root/mining_src/s3-duel-sim/*.sh \
           /root/mining_src/s4-h2-merge/*.sh \
           /root/mining_src/s4-h122-f27-genesis-full-ft/*.sh \
           /root/mining_src/r5b-talent-base/*.sh
  test -f /root/mining_src/affine_pkg/affine/score.py
  test -s /root/h122/winner_za_high_l2.jsonl
  test -x /root/mining_src/s4-h122-f27-genesis-full-ft/bootstrap_h122.sh
  # Prove overlay is R5b Talent, not stock H122 / R5 Genesis; sim king = guass.
  grep -q "R5b: Talent" /root/mining_src/s4-h122-f27-genesis-full-ft/start_h122.sh
  grep -q "DOWNLOAD talent-init" /root/mining_src/s4-h122-f27-genesis-full-ft/bootstrap_h122.sh
  grep -q "DOWNLOAD guass-king" /root/mining_src/s4-h122-f27-genesis-full-ft/bootstrap_h122.sh
  test -f /root/mining_src/r1-reason-distill/write_reason_decision.py
  set -a; source /root/mine.env; set +a
  test "$KING_REPO" = "ttttxxxxsada/Affine-5guassq3tu"
  echo "R5B_DEADLINES soft=$SOFT_DEADLINE_UTC dead=$DEADMAN_UTC axis=$R5B_AXIS base=$BASE king=$KING_REPO@$KING_REV"
  echo STACK_UPLOAD_OK
  nohup bash /root/mining_src/s4-h122-f27-genesis-full-ft/bootstrap_h122.sh \
    >/root/logs/r5b_pipeline.nohup 2>&1 &
  echo $! > /root/logs/r5b_pipeline.pid
  cp -f /root/logs/r5b_pipeline.pid /root/logs/h122_pipeline.pid
  nohup bash /root/mining_src/s4-h2-merge/watch_form_decision.sh h122 \
    /root/affine_data/h122_sim_result.json /root/affine_data/h122_decision.json \
    /root/logs/r5b_form_decision.nohup \
    >/root/logs/r5b_form_decision.launch.out 2>&1 &
  echo $! > /root/logs/r5b_form_decision.pid
  echo PIPELINE_PID=$(cat /root/logs/r5b_pipeline.pid)
  sleep 5
  head -n 40 /root/logs/bootstrap_h122.log 2>/dev/null || head -n 40 /root/logs/r5b_pipeline.nohup || true
  ps -p "$(cat /root/logs/r5b_pipeline.pid)" -o pid,etime,cmd || true
  nvidia-smi -L | wc -l
'

echo "UPLOAD_AND_LAUNCH_OK pod=$POD_NAME $(date -u +%Y-%m-%dT%H:%M:%SZ)"
