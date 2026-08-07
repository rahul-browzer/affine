#!/usr/bin/env bash
# Wait for H1 LoRA train.done → merge → re-serve chall → sim vs kevin.
# Designed to run under nohup on mine-sim-1 so a Ralph pass gap cannot miss TTL.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

export HF_HOME=/root/hf
export PYTHONPATH=/root/mining_src/affine_pkg:/root/mining_src:${PYTHONPATH:-}

BASE=/root/hf/hub/models--kevin954--Affine-5dfqbbh8ev-sft/snapshots/6a5815fad8f4e34c983b1933c1fae5762fe25220
ADAPTER=/root/h1/train/adapter
MERGED=/root/h1/merged
TRAIN_DONE=/root/h1/train/train.done
SIM_OUT=/root/affine_data/h1_sim_result.json
MARKER=/root/logs/h1_pipeline.done

log() { echo "[h1-pipe] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

# Fail-closed: if train dies before writing train.done, promote the newest
# mid-checkpoint (adapter weights only) so merge→sim still runs. Better a
# partial-epoch candidate than a silent $23.60/h burn with no decision signal.
promote_latest_ckpt() {
  local ckpt_root=/root/h1/train/checkpoints
  local best="" best_n=-1 n name
  [[ -d "$ckpt_root" ]] || return 1
  for d in "$ckpt_root"/checkpoint-*; do
    [[ -d "$d" ]] || continue
    [[ -f "$d/adapter_model.safetensors" || -f "$d/adapter_config.json" ]] || continue
    name=$(basename "$d")
    n=${name#checkpoint-}
    [[ "$n" =~ ^[0-9]+$ ]] || continue
    if (( n > best_n )); then
      best_n=$n
      best=$d
    fi
  done
  [[ -n "$best" ]] || return 1
  log "FAIL-CLOSED: promoting $best → $ADAPTER (train died pre-done)"
  rm -rf "$ADAPTER"
  mkdir -p "$ADAPTER"
  # Adapter artifacts only — skip optimizer/rng (not needed for merge/serve).
  for f in adapter_config.json adapter_model.safetensors README.md \
           tokenizer.json tokenizer_config.json special_tokens_map.json \
           vocab.json merges.txt added_tokens.json chat_template.jinja; do
    [[ -f "$best/$f" ]] && cp -a "$best/$f" "$ADAPTER/$f"
  done
  # Some PEFT saves use model.safetensors naming; copy any leftover *.safetensors.
  for f in "$best"/*.safetensors; do
    [[ -f "$f" ]] || continue
    bn=$(basename "$f")
    [[ -f "$ADAPTER/$bn" ]] || cp -a "$f" "$ADAPTER/$bn"
  done
  if [[ ! -f "$ADAPTER/adapter_config.json" ]]; then
    log "ERROR: promote missing adapter_config.json from $best"
    return 1
  fi
  {
    echo "fallback_from=$(basename "$best")"
    date -u +%Y-%m-%dT%H:%M:%SZ
  } >"$TRAIN_DONE"
  printf '%s\n' \
    "{\"utc\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"fallback\":true,\"from\":\"$(basename "$best")\",\"adapter\":\"$ADAPTER\"}" \
    >/root/h1/train_fallback.json
  log "FAIL-CLOSED: wrote $TRAIN_DONE from $(basename "$best")"
  return 0
}

if [[ -f "$MARKER" ]]; then
  log "already done ($(cat "$MARKER")); exit"
  exit 0
fi

log "waiting for $TRAIN_DONE (poll 30s)"
_wait_i=0
while [[ ! -f "$TRAIN_DONE" ]]; do
  # If train pid died without writing done, promote latest mid-ckpt (do not exit).
  if [[ -f /root/logs/h1_train.pid ]]; then
    tpid=$(cat /root/logs/h1_train.pid)
    if ! kill -0 "$tpid" 2>/dev/null && [[ ! -f "$TRAIN_DONE" ]]; then
      log "WARN: train pid $tpid dead and no train.done — attempting mid-ckpt promote"
      if promote_latest_ckpt; then
        break
      fi
      log "ERROR: train dead and no promotable checkpoint"
      exit 1
    fi
  fi
  _wait_i=$((_wait_i + 1))
  if (( _wait_i % 10 == 0 )); then
    log "still waiting for train.done (poll #$_wait_i)"
  fi
  sleep 30
done
log "train.done present: $(cat "$TRAIN_DONE")"

# Ensure train process has fully exited so adapter flush is complete.
if [[ -f /root/logs/h1_train.pid ]]; then
  tpid=$(cat /root/logs/h1_train.pid)
  for _ in $(seq 1 60); do
    kill -0 "$tpid" 2>/dev/null || break
    sleep 2
  done
fi

# Normal train path writes adapter/; fail-closed path may have just promoted.
if [[ ! -d "$ADAPTER" ]]; then
  log "WARN: adapter dir missing at $ADAPTER — trying mid-ckpt promote"
  if ! promote_latest_ckpt; then
    log "ERROR: adapter dir missing at $ADAPTER and promote failed"
    exit 1
  fi
fi
if [[ ! -f "$ADAPTER/adapter_config.json" ]]; then
  log "ERROR: $ADAPTER/adapter_config.json missing"
  exit 1
fi

# Off-pod salvage BEFORE merge/sim. Adapter is small; TTL remove is 04:53Z
# and a crashed pass must not erase the train. Not a submission candidate.
if [[ -z "${HF_TOKEN:-}" ]]; then
  log "WARN: HF_TOKEN unset after mine.env; skipping adapter salvage"
else
  log "salvage LoRA adapter → HF (TTL insurance)"
  python3 /root/mining_src/s4-h1-sft/salvage_adapter.py \
    --adapter "$ADAPTER" \
    --out-meta /root/h1/adapter_salvage.json \
    || log "WARN: adapter salvage failed (continuing to merge/sim)"
fi

# Free dead H2 α=0.5 merge before writing ~68G H1 merged (chall still on kp65).
if [[ -d /root/merges/h2-kp50 ]]; then
  log "reclaim /root/merges/h2-kp50"
  rm -rf /root/merges/h2-kp50
fi

# GPUs 6,7 are free after train exits; engines stay on 0-5. GPU merge of
# 35B is much faster than the prior CPU path and buys TTL margin before sim.
log "merge LoRA → $MERGED (CUDA 6,7)"
CUDA_VISIBLE_DEVICES=6,7 python3 /root/mining_src/s4-h1-sft/merge_lora.py \
  --base "$BASE" \
  --adapter "$ADAPTER" \
  --out "$MERGED" \
  --device-map auto
log "merge DONE"

# Full-merged HF salvage in background WHILE we re-serve + sim. Adapter-only
# salvage is already on HF; without this a 07:00Z deadman would erase the
# only vLLM-ready candidate and force another rental to re-merge for submit.
MERGED_PUSH_META=/root/affine_data/h1_merged_salvage.json
MERGED_PUSH_PID=""
if [[ -n "${HF_TOKEN:-}" ]]; then
  log "background HF push merged → unconst/Affine-5czsc2fc98-h1-merged"
  nohup python3 /root/mining_src/s4-h1-sft/push_merged.py \
    --merged "$MERGED" \
    --out-meta "$MERGED_PUSH_META" \
    >>/root/logs/h1_push_merged.nohup 2>&1 &
  MERGED_PUSH_PID=$!
  echo "$MERGED_PUSH_PID" >/root/logs/h1_push_merged.pid
  log "merged push pid=$MERGED_PUSH_PID"
else
  log "WARN: HF_TOKEN unset; skipping merged HF push"
fi

log "re-serve chall=$MERGED (king=kevin kept hot; teacher kept)"
RESTART_KING=0 MERGE="$MERGED" bash /root/mining_src/s4-h2-merge/restart_for_h2.sh
log "serve READY"

# Chall now serves H1 merged; reclaim old H2 α=0.65 weights.
if [[ -d /root/merges/h2-kp65 ]]; then
  log "reclaim /root/merges/h2-kp65"
  rm -rf /root/merges/h2-kp65
fi

# Dual-phase sim under TTL (remove 04:53Z): n=40 first (~21 min) so a
# late start or mid-80 kill still leaves a decision signal on disk/HF-harvest;
# then full n=80 for the plan.md gate (>0.04 on contract slice size).
SIM_N40=/root/affine_data/h1_sim_result_n40.json
# Soft deadline was 04:50Z (pod TTL 04:53Z). Pass 33 cancelled that Lium
# schedule so n=80 can finish; host deadman kills mine-sim-1 at 07:00Z.
TTL_DEADLINE_EPOCH=$(date -u -d '2026-08-07T06:50:00Z' +%s 2>/dev/null || echo 0)

log "launch sim n=40 → $SIM_N40 (TTL insurance probe)"
python /root/mining_src/s4-h2-merge/run_sim_duel.py \
  --chall-repo "$MERGED" \
  --out "$SIM_N40" \
  --hotkey local-h1-sim-n40 \
  --n-turns 40 \
  --progress-out /root/affine_data/h1_sim_progress_n40.json \
  --save-artifact \
  >>/root/logs/h1_sim.nohup 2>&1
log "SIM_N40_DONE → $SIM_N40"
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h1_sim_n40.done

now_epoch=$(date -u +%s)
if [[ "$TTL_DEADLINE_EPOCH" =~ ^[0-9]+$ ]] && (( TTL_DEADLINE_EPOCH > 0 )); then
  remain=$(( TTL_DEADLINE_EPOCH - now_epoch ))
else
  remain=99999
fi
wait_merged_push() {
  # Keep the pod alive until HF has the vLLM-ready weights (or 45 min).
  if [[ -z "${MERGED_PUSH_PID}" ]]; then
    return 0
  fi
  log "waiting for merged HF push pid=$MERGED_PUSH_PID (max 2700s)"
  for _ in $(seq 1 540); do
    kill -0 "$MERGED_PUSH_PID" 2>/dev/null || break
    sleep 5
  done
  if kill -0 "$MERGED_PUSH_PID" 2>/dev/null; then
    log "WARN: merged HF push still running after wait; leaving it"
  elif [[ -f "$MERGED_PUSH_META" ]]; then
    log "merged HF push DONE → $MERGED_PUSH_META"
  else
    log "WARN: merged HF push exited without meta at $MERGED_PUSH_META"
  fi
}

# Full 80-turn needs ~45 min wall; require 50 min buffer before soft deadline.
if (( remain < 3000 )); then
  log "WARN: only ${remain}s to soft TTL deadline; skipping full n=80 (n40 is the signal)"
  wait_merged_push
  {
    date -u +%Y-%m-%dT%H:%M:%SZ
    echo "n40_only remain_s=$remain"
  } >"$MARKER"
  exit 0
fi

log "launch sim n=80 → $SIM_OUT (${remain}s to soft deadline)"
python /root/mining_src/s4-h2-merge/run_sim_duel.py \
  --chall-repo "$MERGED" \
  --out "$SIM_OUT" \
  --hotkey local-h1-sim \
  --n-turns 80 \
  --progress-out /root/affine_data/h1_sim_progress.json \
  --save-artifact \
  >>/root/logs/h1_sim.nohup 2>&1

date -u +%Y-%m-%dT%H:%M:%SZ >"$MARKER"
log "SIM_DONE → $SIM_OUT"
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h1_sim.done
wait_merged_push
