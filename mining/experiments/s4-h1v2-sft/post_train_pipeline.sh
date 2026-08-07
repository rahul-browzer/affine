#!/usr/bin/env bash
# After H1v2 train.done: merge LoRA → chall-only re-serve → n40 triage.
# Waits for any H1 n80 sim to finish (or soft deadline) before killing chall.
# Soft deadline 06:50Z; host deadman 07:00Z.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

export HF_HOME=${HF_HOME:-/root/hf}
export PYTHONPATH=/root/mining_src/affine_pkg:${PYTHONPATH:-}
export CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:-6,7}

BASE=${BASE:-/root/hf/hub/models--kevin954--Affine-5dfqbbh8ev-sft/snapshots/6a5815fad8f4e34c983b1933c1fae5762fe25220}
TRAIN_DIR=${TRAIN_DIR:-/root/h1v2/train}
# train_lora.py writes final adapter to $TRAIN_DIR/adapter and mid-ckpts to
# $TRAIN_DIR/checkpoints/checkpoint-* (NOT $TRAIN_DIR/checkpoint-*).
ADAPTER=${ADAPTER:-$TRAIN_DIR/adapter}
CKPT_ROOT=${CKPT_ROOT:-$TRAIN_DIR/checkpoints}
MERGED=${MERGED:-/root/h1v2/merged}
SIM_N40=/root/affine_data/h1v2_sim_result_n40.json
LOG=/root/logs/h1v2_pipeline.nohup
SOFT_DEADLINE_UTC=${SOFT_DEADLINE_UTC:-2026-08-07T06:50:00Z}

log() { echo "[h1v2-pipe] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

mkdir -p /root/logs /root/affine_data /root/h1v2

log "waiting for $TRAIN_DIR/train.done (or $ADAPTER/adapter_config.json + no train proc)"
while true; do
  if [[ -f "$TRAIN_DIR/train.done" ]]; then
    log "train.done present"
    break
  fi
  if [[ -f "$ADAPTER/adapter_config.json" ]] && ! pgrep -f "s4-h1v2-sft/train_lora.py" >/dev/null 2>&1; then
    log "adapter present and train proc gone (no train.done — proceed)"
    break
  fi
  now=$(date -u +%s)
  soft=$(date -u -d "$SOFT_DEADLINE_UTC" +%s)
  if (( now > soft - 2400 )); then
    log "WARN: <40m to soft deadline and train not done; abort pipe"
    echo "aborted_no_train $(date -u +%Y-%m-%dT%H:%M:%SZ)" > /root/logs/h1v2_pipeline.aborted
    exit 1
  fi
  sleep 30
done

# Prefer final adapter dir; fall back to latest checkpoints/checkpoint-*.
if [[ ! -f "$ADAPTER/adapter_config.json" ]]; then
  latest=$(ls -d "$CKPT_ROOT"/checkpoint-* 2>/dev/null | sort -V | tail -1 || true)
  if [[ -n "${latest:-}" && -f "$latest/adapter_config.json" ]]; then
    ADAPTER=$latest
    log "using checkpoint adapter $ADAPTER"
  else
    log "ERROR: no adapter under $ADAPTER or $CKPT_ROOT"
    exit 1
  fi
fi

# Merge on GPUs 6,7 WHILE H1 n80 may still be scoring on teacher/king/chall
# (0–5). Chall restart is the only step that must wait for n80. Reordering
# recovers ~6 min of merge (+ early HF salvage start) if n80 slips.
log "merge LoRA → $MERGED (CUDA $CUDA_VISIBLE_DEVICES) — parallel with any live n80"
python /root/mining_src/s4-h1-sft/merge_lora.py \
  --base "$BASE" \
  --adapter "$ADAPTER" \
  --out "$MERGED" \
  --device-map auto \
  | tee -a "$LOG"
# Stage H1v2 meta without depending on (or trusting) H1's h1_merge_meta.json —
# merge_lora.py also writes that path as a legacy side effect.
cp -f "$MERGED/merge_meta.json" /root/affine_data/h1v2_merge_meta.json 2>/dev/null || true
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h1v2_merge.done

# Adapter + merged HF salvage WHILE we wait for n80 / re-serve / n40.
# Soft 06:50Z / deadman 07:00Z would otherwise erase the only vLLM-ready
# H1v2 candidate.
HF_LORA_REPO=${HF_LORA_REPO:-unconst/Affine-5czsc2fc98-h1v2-lora}
HF_MERGED_REPO=${HF_MERGED_REPO:-unconst/Affine-5czsc2fc98-h1v2-merged}
if [[ -n "${HF_TOKEN:-}" ]]; then
  log "background HF push adapter → $HF_LORA_REPO"
  nohup python3 /root/mining_src/s4-h1-sft/salvage_adapter.py \
    --adapter "$ADAPTER" \
    --repo "$HF_LORA_REPO" \
    --commit-message "H1v2 thought-only LoRA salvage (TTL insurance; not a submission)" \
    --out-meta /root/affine_data/h1v2_adapter_salvage.json \
    >>/root/logs/h1v2_push_adapter.nohup 2>&1 &
  echo $! >/root/logs/h1v2_push_adapter.pid
  log "background HF push merged → $HF_MERGED_REPO"
  nohup python3 /root/mining_src/s4-h1-sft/push_merged.py \
    --merged "$MERGED" \
    --repo "$HF_MERGED_REPO" \
    --commit-message "H1v2 thought-only merged salvage (TTL insurance; not a submission)" \
    --out-meta /root/affine_data/h1v2_merged_salvage.json \
    >>/root/logs/h1v2_push_merged.nohup 2>&1 &
  echo $! >/root/logs/h1v2_push_merged.pid
  log "adapter push pid=$(cat /root/logs/h1v2_push_adapter.pid) merged push pid=$(cat /root/logs/h1v2_push_merged.pid)"
else
  log "WARN: HF_TOKEN unset; skipping H1v2 HF salvage pushes"
fi

# Wait only for H1 n80 (out=h1_sim_result). Broad pgrep run_sim_duel.py would
# also match this pipe's own later n40 if the wait were ever re-entered, and
# the soft-deadline pkill would murder H1v2's triage sim (pass 58).
log "waiting for H1 n80 sim to finish before chall restart"
while pgrep -f "run_sim_duel.py.*h1_sim_result" >/dev/null 2>&1; do
  now=$(date -u +%s)
  soft=$(date -u -d "$SOFT_DEADLINE_UTC" +%s)
  remain=$(( soft - now ))
  if (( remain < 2700 )); then
    log "WARN: ${remain}s to soft; killing lingering H1 n80 to free chall for H1v2"
    pkill -f "run_sim_duel.py.*h1_sim_result" || true
    sleep 5
    break
  fi
  sleep 30
done

log "chall-only re-serve $MERGED"
RESTART_KING=0 MERGE="$MERGED" bash /root/mining_src/s4-h2-merge/restart_for_h2.sh
log "serve READY"

now=$(date -u +%s)
soft=$(date -u -d "$SOFT_DEADLINE_UTC" +%s)
remain=$(( soft - now ))
if (( remain < 1200 )); then
  log "WARN: only ${remain}s to soft; skip n40 (merge+serve done)"
  echo "serve_only remain_s=$remain $(date -u +%Y-%m-%dT%H:%M:%SZ)" > /root/logs/h1v2_pipeline.partial
  exit 0
fi

log "launch H1v2 n40 sim → $SIM_N40 (${remain}s to soft)"
python /root/mining_src/s4-h2-merge/run_sim_duel.py \
  --chall-repo "$MERGED" \
  --out "$SIM_N40" \
  --hotkey local-h1v2-sim-n40 \
  --n-turns 40 \
  --progress-out /root/affine_data/h1v2_sim_progress_n40.json \
  --save-artifact \
  >>"$LOG" 2>&1

date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h1v2_sim_n40.done
log "SIM_N40_DONE → $SIM_N40"
# Compact triage echo for harvest
python3 - <<'PY' | tee -a /root/logs/h1v2_pipeline.nohup
import json
from pathlib import Path
p = Path("/root/affine_data/h1v2_sim_result_n40.json")
d = json.loads(p.read_text())
v = d.get("verdict") or {}
c = v.get("challenger") or {}
k = v.get("king") or {}
h4 = d.get("h4") or {}
out = {
    "utc": __import__("time").strftime("%Y-%m-%dT%H:%M:%SZ", __import__("time").gmtime()),
    "margin": v.get("margin"),
    "z": v.get("z"),
    "se": v.get("se"),
    "wins": v.get("challenger_wins"),
    "chall_S": c.get("S"),
    "king_S": k.get("S"),
    "chall_valid": c.get("valid"),
    "king_valid": k.get("valid"),
    "h4": h4,
    "submit_gate": (v.get("margin") or -1) > 0.04,
}
Path("/root/affine_data/h1v2_decision_n40.json").write_text(json.dumps(out, indent=2) + "\n")
print(json.dumps(out, indent=2))
PY

date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h1v2_pipeline.done
log "PIPELINE_DONE"
