#!/usr/bin/env bash
# Lightweight host-side poller: SCP H1 artifacts off mine-sim-1 before TTL.
# No GPU/weights on host — JSON/meta only.
set -euo pipefail

SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o StrictHostKeyChecking=accept-new
     -o ConnectTimeout=15 -p 40301 root@69.63.236.160)
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o StrictHostKeyChecking=accept-new
     -P 40301)
OUT=/home/const/subnet120/mining/experiments/s4-h1-sft/results
mkdir -p "$OUT"
log() { echo "[host-harvest] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

log "polling mine-sim-1 for H1 artifacts → $OUT"
# Aligned with pass-33 host deadman (pod kill 07:00Z); was 04:50Z under Lium TTL.
deadline=$(date -u -d '2026-08-07T06:55:00Z' +%s 2>/dev/null || date -u -d '2026-08-07 06:55:00' +%s)
got_sim=0
got_salvage=0
got_train=0

# Emit / refresh train step JSON on the pod (tqdm uses \r; parse on pod).
# Python lives in emit_train_progress.py — keep it out of a bash-quoted heredoc
# so single-quoted Trainer loss dicts do not break the host script.
EMIT_PY=/home/const/subnet120/mining/experiments/s4-h1-sft/emit_train_progress.py
_emit_train_progress() {
  "${SCP[@]}" "$EMIT_PY" root@69.63.236.160:/root/mining_src/s4-h1-sft/emit_train_progress.py \
    2>/dev/null || true
  "${SSH[@]}" 'python3 /root/mining_src/s4-h1-sft/emit_train_progress.py' \
    2>/dev/null || true
}

while true; do
  now=$(date -u +%s)
  if (( now >= deadline )); then
    log "deadline reached (host harvest stop 06:55Z; deadman 07:00Z); stop"
    exit 0
  fi

  # Best-effort train + sim progress (overwrites); survives pod kill.
  _emit_train_progress
  if "${SSH[@]}" 'test -f /root/affine_data/h1_train_progress.json' 2>/dev/null; then
    "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1_train_progress.json \
      "$OUT/h1_train_progress.json" 2>/dev/null || true
  fi
  if "${SSH[@]}" 'test -f /root/affine_data/h1_train_loss.json' 2>/dev/null; then
    "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1_train_loss.json \
      "$OUT/h1_train_loss.json" 2>/dev/null || true
  fi
  if "${SSH[@]}" 'test -f /root/affine_data/h1_trainer_state.json' 2>/dev/null; then
    "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1_trainer_state.json \
      "$OUT/h1_trainer_state.json" 2>/dev/null || true
  fi
  if "${SSH[@]}" 'test -f /root/affine_data/h1_sim_progress.json' 2>/dev/null; then
    "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1_sim_progress.json \
      "$OUT/h1_sim_progress.json" 2>/dev/null || true
  fi
  if "${SSH[@]}" 'test -f /root/affine_data/h1_sim_progress_n40.json' 2>/dev/null; then
    "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1_sim_progress_n40.json \
      "$OUT/h1_sim_progress_n40.json" 2>/dev/null || true
  fi
  "${SCP[@]}" 'root@69.63.236.160:/root/h1/mid_*_salvage.json' \
    "$OUT/" 2>/dev/null || true

  # n40 probe is TTL insurance; harvest even if full 80 never finishes.
  if [[ ! -f "$OUT/h1_sim_result_n40.json" ]]; then
    if "${SSH[@]}" 'test -f /root/affine_data/h1_sim_result_n40.json' 2>/dev/null; then
      "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1_sim_result_n40.json \
        "$OUT/h1_sim_result_n40.json"
      log "got h1_sim_result_n40.json"
    fi
  fi

  if (( got_sim == 0 )); then
    if "${SSH[@]}" 'test -f /root/affine_data/h1_sim_result.json' 2>/dev/null; then
      "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1_sim_result.json \
        "$OUT/h1_sim_result.json"
      log "got h1_sim_result.json"
      got_sim=1
    elif [[ -f "$OUT/h1_sim_result_n40.json" ]] \
      && "${SSH[@]}" 'test -f /root/logs/h1_pipeline.done' 2>/dev/null; then
      # Pipeline exited after n40-only (TTL soft cutoff); treat as harvested sim.
      log "pipeline done with n40-only; counting as sim harvest"
      got_sim=1
    fi
  fi

  if (( got_salvage == 0 )); then
    if "${SSH[@]}" 'test -f /root/h1/adapter_salvage.json' 2>/dev/null; then
      "${SCP[@]}" root@69.63.236.160:/root/h1/adapter_salvage.json \
        "$OUT/adapter_salvage.json"
      log "got adapter_salvage.json"
      got_salvage=1
    fi
  fi

  # Merge hygiene meta (first_1MiB ≠ king). Optional — do not block teardown.
  if [[ ! -f "$OUT/h1_merge_meta.json" ]]; then
    if "${SSH[@]}" 'test -f /root/affine_data/h1_merge_meta.json' 2>/dev/null; then
      "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1_merge_meta.json \
        "$OUT/h1_merge_meta.json"
      log "got h1_merge_meta.json"
    fi
  fi

  # Full merged HF salvage meta (background push during sim).
  if [[ ! -f "$OUT/h1_merged_salvage.json" ]]; then
    if "${SSH[@]}" 'test -f /root/affine_data/h1_merged_salvage.json' 2>/dev/null; then
      "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1_merged_salvage.json \
        "$OUT/h1_merged_salvage.json"
      log "got h1_merged_salvage.json"
    fi
  fi

  if (( got_train == 0 )); then
    if "${SSH[@]}" 'test -f /root/h1/train/train_result.json' 2>/dev/null; then
      "${SCP[@]}" root@69.63.236.160:/root/h1/train/train_result.json \
        "$OUT/train_result.json"
      log "got train_result.json"
      got_train=1
    fi
  fi

  # Apply plan.md decision rule whenever any sim JSON is local.
  if [[ -f "$OUT/h1_sim_result.json" || -f "$OUT/h1_sim_result_n40.json" ]]; then
    if python3 /home/const/subnet120/mining/experiments/s4-h1-sft/triage_sim.py \
      --results-dir "$OUT" >/dev/null 2>&1; then
      log "triage → $OUT/h1_decision.json action=$(python3 -c "import json;print(json.load(open('$OUT/h1_decision.json'))['primary']['action'])" 2>/dev/null || echo '?')"
    fi
  fi

  if (( got_sim == 1 && got_salvage == 1 && got_train == 1 )); then
    # Do not kill the pod while ~68G merged HF upload is still in flight —
    # that erase is exactly what the push was meant to prevent. Wait up to
    # 20 min; adapter salvage alone still allows a re-merge if push fails.
    push_alive=0
    if "${SSH[@]}" 'test -f /root/logs/h1_push_merged.pid && kill -0 "$(cat /root/logs/h1_push_merged.pid)"' \
      2>/dev/null; then
      push_alive=1
    fi
    if (( push_alive == 1 )) && [[ ! -f "$OUT/h1_merged_salvage.json" ]]; then
      log "sim harvested but merged HF push still running; defer early-teardown (recheck 60s)"
      sleep 60
      continue
    fi
    # Soft cap: if push has been running >20 min after sim harvest, proceed.
    if (( push_alive == 1 )); then
      if [[ ! -f "$OUT/.push_wait_started" ]]; then
        date -u +%s >"$OUT/.push_wait_started"
        log "merged push still alive; start 20min teardown grace"
        sleep 60
        continue
      fi
      started=$(cat "$OUT/.push_wait_started")
      if (( now - started < 1200 )); then
        log "merged push grace $((now - started))s/1200s; defer teardown"
        sleep 60
        continue
      fi
      log "WARN: merged push grace exhausted; tearing down (adapter salvage remains)"
    fi
    date -u +%Y-%m-%dT%H:%M:%SZ >"$OUT/host_harvest.done"
    log "all artifacts harvested; early-teardown mine-sim-1 (stop $/h burn)"
    # HARD RULE: verify name immediately before every rm. Never touch non-mine-*.
    name=$(lium describe mine-sim-1 2>/dev/null | awk '/^Name/{print $2; exit}') || name=
    if [[ "$name" != "mine-sim-1" ]]; then
      log "WARN: describe Name='$name' != mine-sim-1; refusing rm (deadman 07:00Z still armed)"
      exit 0
    fi
    case "$name" in
      mine-*) ;;
      *)
        log "FATAL: name does not start with mine-; refusing rm"
        exit 2
        ;;
    esac
    log "lium rm mine-sim-1 (verified name=$name)"
    if lium rm mine-sim-1 -y; then
      log "early teardown OK"
    else
      log "WARN: lium rm failed; host deadman 07:00Z remains as backstop"
    fi
    exit 0
  fi

  sleep 60
done
