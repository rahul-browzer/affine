#!/usr/bin/env bash
# Lightweight host-side poller: SCP H1 artifacts off mine-sim-1 before TTL.
# No GPU/weights on host — JSON/meta only.
set -euo pipefail

SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o StrictHostKeyChecking=accept-new
     -o ConnectTimeout=15 -p 40301 root@69.63.236.160)
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o StrictHostKeyChecking=accept-new
     -P 40301)
OUT=/home/const/subnet120/mining/experiments/s4-h1-sft/results
OUT_H1V2=/home/const/subnet120/mining/experiments/s4-h1v2-sft/results
mkdir -p "$OUT" "$OUT_H1V2"
log() { echo "[host-harvest] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

log "polling mine-sim-1 for H1 + H1v2 artifacts → $OUT | $OUT_H1V2"
# Aligned with pass-33 host deadman (pod kill 07:00Z); was 04:50Z under Lium TTL.
deadline=$(date -u -d '2026-08-07T06:55:00Z' +%s 2>/dev/null || date -u -d '2026-08-07 06:55:00' +%s)
got_sim=0
got_salvage=0
got_train=0
got_h1v2=0

# Emit / refresh train step JSON on the pod (tqdm uses \r; parse on pod).
# Python lives in emit_train_progress.py — keep it out of a bash-quoted heredoc
# so single-quoted Trainer loss dicts do not break the host script.
EMIT_PY=/home/const/subnet120/mining/experiments/s4-h1-sft/emit_train_progress.py
EMIT_H1V2_PY=/home/const/subnet120/mining/experiments/s4-h1v2-sft/emit_train_progress.py
_emit_train_progress() {
  "${SCP[@]}" "$EMIT_PY" root@69.63.236.160:/root/mining_src/s4-h1-sft/emit_train_progress.py \
    2>/dev/null || true
  "${SSH[@]}" 'python3 /root/mining_src/s4-h1-sft/emit_train_progress.py' \
    2>/dev/null || true
  "${SCP[@]}" "$EMIT_H1V2_PY" root@69.63.236.160:/root/mining_src/s4-h1v2-sft/emit_train_progress.py \
    2>/dev/null || true
  "${SSH[@]}" 'python3 /root/mining_src/s4-h1v2-sft/emit_train_progress.py' \
    2>/dev/null || true
}

# H1v2 is the submit-candidate path. Never early-teardown while its train,
# post-train pipe, n40 sim, OR HF salvage pushes are still live — H1 n80
# completion alone must not kill the pod (pass 56: pipeline.done fires while
# ~68G merged upload still runs; killing then erases the only vLLM candidate).
_h1v2_still_running() {
  "${SSH[@]}" 'bash -s' <<'EOS' 2>/dev/null
set -e
if pgrep -f "s4-h1v2-sft/train_lora.py" >/dev/null 2>&1; then exit 0; fi
if pgrep -f "s4-h1v2-sft/post_train_pipeline.sh" >/dev/null 2>&1; then exit 0; fi
if pgrep -f "h1v2_sim_result_n40" >/dev/null 2>&1; then exit 0; fi
if pgrep -af "run_sim_duel.py" 2>/dev/null | grep -q "h1v2"; then exit 0; fi
for pidf in /root/logs/h1v2_push_merged.pid /root/logs/h1v2_push_adapter.pid; do
  if [[ -f "$pidf" ]]; then
    pid=$(cat "$pidf" 2>/dev/null || true)
    if [[ -n "${pid:-}" ]] && kill -0 "$pid" 2>/dev/null; then
      exit 0
    fi
  fi
done
if pgrep -af "push_merged.py|salvage_adapter.py" 2>/dev/null \
  | grep -qE "h1v2|5czsc2fc98-h1v2"; then
  exit 0
fi
if [[ -f /root/logs/h1v2_pipeline.nohup ]] \
  && [[ ! -f /root/logs/h1v2_pipeline.done ]] \
  && [[ ! -f /root/logs/h1v2_pipeline.aborted ]] \
  && [[ ! -f /root/logs/h1v2_pipeline.partial ]]; then
  exit 0
fi
exit 1
EOS
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
  # H1v2 progress / results (submit-candidate path).
  if "${SSH[@]}" 'test -f /root/affine_data/h1v2_train_progress.json' 2>/dev/null; then
    "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1v2_train_progress.json \
      "$OUT_H1V2/h1v2_train_progress.json" 2>/dev/null || true
  fi
  if "${SSH[@]}" 'test -f /root/affine_data/h1v2_sim_progress_n40.json' 2>/dev/null; then
    "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1v2_sim_progress_n40.json \
      "$OUT_H1V2/h1v2_sim_progress_n40.json" 2>/dev/null || true
  fi
  # H1v2 n80 progress (pipe prefers n80 when soft budget ≥ ~53m — pass 59).
  if "${SSH[@]}" 'test -f /root/affine_data/h1v2_sim_progress.json' 2>/dev/null; then
    "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1v2_sim_progress.json \
      "$OUT_H1V2/h1v2_sim_progress.json" 2>/dev/null || true
  fi
  if "${SSH[@]}" 'test -f /root/affine_data/h1_sim_progress.json' 2>/dev/null; then
    "${SCP[@]}" root@69.63.236.160:/root/affine_data/h1_sim_progress.json \
      "$OUT_H1V2/h1_n80_progress_mirror.json" 2>/dev/null || true
  fi
  for f in h1v2_sim_result.json h1v2_sim_result_n40.json \
           h1v2_decision_n80.json h1v2_decision_n40.json h1v2_merge_meta.json \
           h1v2_adapter_salvage.json h1v2_merged_salvage.json \
           h1v2_hf_salvage_armed.json; do
    # Overwrite OK for progress-sized decision/result files once; prefer
    # fetching when missing OR when n80 lands after an earlier n40.
    if [[ ! -f "$OUT_H1V2/$f" ]] \
      && "${SSH[@]}" "test -f /root/affine_data/$f" 2>/dev/null; then
      "${SCP[@]}" "root@69.63.236.160:/root/affine_data/$f" "$OUT_H1V2/$f" \
        2>/dev/null || true
      log "got $f → $OUT_H1V2/"
    fi
  done
  # Mid-ckpt salvage metas (overwrite OK — small JSON).
  for f in $("${SSH[@]}" 'ls /root/affine_data/h1v2_mid_checkpoint-*_salvage.json 2>/dev/null' || true); do
    bn=$(basename "$f")
    "${SCP[@]}" "root@69.63.236.160:$f" "$OUT_H1V2/$bn" 2>/dev/null || true
  done
  for f in h1v2_pipeline.done h1v2_pipeline.aborted h1v2_pipeline.partial \
           h1v2_merge.done h1v2_sim_n40.done h1v2_sim_n80.done; do
    if [[ ! -f "$OUT_H1V2/$f" ]] \
      && "${SSH[@]}" "test -f /root/logs/$f" 2>/dev/null; then
      "${SCP[@]}" "root@69.63.236.160:/root/logs/$f" "$OUT_H1V2/$f" \
        2>/dev/null || true
    fi
  done
  if (( got_h1v2 == 0 )); then
    # Terminal = pipe finished OR n80 result. n40 alone is NOT terminal while
    # the pipe may still chain n80 (pass 59); _h1v2_still_running also gates
    # teardown, but avoid marking got_h1v2 early on n40-only.
    if [[ -f "$OUT_H1V2/h1v2_sim_result.json" ]] \
      || [[ -f "$OUT_H1V2/h1v2_pipeline.done" ]] \
      || [[ -f "$OUT_H1V2/h1v2_pipeline.aborted" ]] \
      || [[ -f "$OUT_H1V2/h1v2_pipeline.partial" ]]; then
      got_h1v2=1
      log "H1v2 terminal artifact present (got_h1v2=1)"
    fi
  fi
  # Authoritative H1v2 triage with live-king guard. Prefer n80 when present;
  # re-run when n80 lands after an n40-only decision (pass 59).
  if [[ -f "$OUT_H1V2/h1v2_sim_result.json" || -f "$OUT_H1V2/h1v2_sim_result_n40.json" ]]; then
    need_triage=0
    if [[ ! -f "$OUT_H1V2/h1v2_decision.json" ]]; then
      need_triage=1
    elif [[ -f "$OUT_H1V2/h1v2_sim_result.json" ]]; then
      # Upgrade n40-only decision once n80 arrives.
      src=$(python3 -c "import json;print(json.load(open('$OUT_H1V2/h1v2_decision.json')).get('primary',{}).get('source',''))" 2>/dev/null || echo "")
      if [[ "$src" != "n80" ]]; then
        need_triage=1
      fi
    fi
    if (( need_triage == 1 )); then
      mkdir -p "$OUT_H1V2/triage_in"
      rm -f "$OUT_H1V2/triage_in/h1_sim_result.json" \
        "$OUT_H1V2/triage_in/h1_sim_result_n40.json"
      if [[ -f "$OUT_H1V2/h1v2_sim_result_n40.json" ]]; then
        cp -f "$OUT_H1V2/h1v2_sim_result_n40.json" \
          "$OUT_H1V2/triage_in/h1_sim_result_n40.json"
      fi
      if [[ -f "$OUT_H1V2/h1v2_sim_result.json" ]]; then
        cp -f "$OUT_H1V2/h1v2_sim_result.json" \
          "$OUT_H1V2/triage_in/h1_sim_result.json"
      fi
      if python3 /home/const/subnet120/mining/experiments/s4-h1-sft/triage_sim.py \
        --results-dir "$OUT_H1V2/triage_in" \
        --out "$OUT_H1V2/h1v2_decision.json" >/dev/null 2>&1; then
        log "H1v2 triage → $OUT_H1V2/h1v2_decision.json action=$(python3 -c "import json;print(json.load(open('$OUT_H1V2/h1v2_decision.json'))['primary']['action'])" 2>/dev/null || echo '?') source=$(python3 -c "import json;print(json.load(open('$OUT_H1V2/h1v2_decision.json'))['primary']['source'])" 2>/dev/null || echo '?')"
      fi
    fi
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
    elif [[ -n "$(ls -1 "$OUT"/mid_*_salvage.json 2>/dev/null | head -1)" ]]; then
      # Mid-ckpt already on HF (TTL insurance). Do not block early-teardown if
      # final adapter_salvage.json never appears (HF flake / skip).
      log "got mid-ckpt salvage on disk → counting as salvage insurance"
      got_salvage=1
    elif [[ -f "$OUT/h1_merged_salvage.json" ]]; then
      log "got h1_merged_salvage.json → counting as salvage insurance"
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
      # Merged push meta alone is enough salvage insurance for teardown.
      if (( got_salvage == 0 )); then
        got_salvage=1
      fi
    fi
  fi

  # train_result.json is only written on the happy path. Fail-closed promote
  # writes train_fallback.json + train.done instead — without accepting those,
  # early-teardown never fires and we burn until the 07:00Z deadman.
  if (( got_train == 0 )); then
    if "${SSH[@]}" 'test -f /root/h1/train/train_result.json' 2>/dev/null; then
      "${SCP[@]}" root@69.63.236.160:/root/h1/train/train_result.json \
        "$OUT/train_result.json"
      log "got train_result.json"
      got_train=1
    elif "${SSH[@]}" 'test -f /root/h1/train_fallback.json' 2>/dev/null; then
      "${SCP[@]}" root@69.63.236.160:/root/h1/train_fallback.json \
        "$OUT/train_fallback.json"
      log "got train_fallback.json (fail-closed promote)"
      got_train=1
    elif "${SSH[@]}" 'test -f /root/h1/train/train.done' 2>/dev/null; then
      "${SCP[@]}" root@69.63.236.160:/root/h1/train/train.done \
        "$OUT/train.done"
      log "got train.done (no train_result yet — counting as train harvest)"
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

  # Teardown when H1 train+salvage are in hand AND either H1 n80 finished
  # OR H1v2 reached a terminal artifact. Requiring got_sim alone stranded the
  # pod until deadman 07:00Z whenever the pipe killed lingering n80 for H1v2
  # (remain<2700s) even though the submit-candidate path was done (pass 58).
  if (( (got_sim == 1 || got_h1v2 == 1) && got_salvage == 1 && got_train == 1 )); then
    # CRITICAL (pass 53): H1 n80 DONE must not tear down while H1v2 still runs.
    if _h1v2_still_running; then
      log "H1 artifacts ready but H1v2 still running — defer early-teardown (deadman 07:00Z)"
      sleep 60
      continue
    fi
    if (( got_h1v2 == 0 )); then
      # Train/pipe gone without a terminal marker yet — give one more cycle to
      # SCP whatever landed, then allow teardown (soft/deadman still bound).
      if [[ ! -f "$OUT_H1V2/.h1v2_wait_started" ]]; then
        date -u +%s >"$OUT_H1V2/.h1v2_wait_started"
        log "H1v2 procs gone, no terminal artifact yet; 10min harvest grace"
        sleep 60
        continue
      fi
      h1v2_started=$(cat "$OUT_H1V2/.h1v2_wait_started")
      if (( now - h1v2_started < 600 )); then
        log "H1v2 harvest grace $((now - h1v2_started))s/600s; defer teardown"
        sleep 60
        continue
      fi
      log "WARN: H1v2 grace exhausted with no terminal artifact; allowing H1 teardown"
    fi
    if (( got_sim == 0 && got_h1v2 == 1 )); then
      log "teardown via H1v2 terminal (H1 n80 incomplete/killed); H1v2 is the submit path"
    fi
    # Do not kill the pod while ~68G merged HF upload is still in flight —
    # that erase is exactly what the push was meant to prevent. Wait up to
    # 20 min; adapter salvage alone still allows a re-merge if push fails.
    # Cover BOTH H1 and H1v2 push PIDs (pass 56: H1v2 was missing → deadman
    # race after pipeline.done).
    push_alive=0
    push_which=
    if "${SSH[@]}" 'test -f /root/logs/h1_push_merged.pid && kill -0 "$(cat /root/logs/h1_push_merged.pid)"' \
      2>/dev/null; then
      push_alive=1
      push_which=h1
    fi
    if "${SSH[@]}" 'test -f /root/logs/h1v2_push_merged.pid && kill -0 "$(cat /root/logs/h1v2_push_merged.pid)"' \
      2>/dev/null; then
      push_alive=1
      push_which=h1v2
    fi
    if "${SSH[@]}" 'test -f /root/logs/h1v2_push_adapter.pid && kill -0 "$(cat /root/logs/h1v2_push_adapter.pid)"' \
      2>/dev/null; then
      push_alive=1
      push_which=${push_which:-h1v2_adapter}
    fi
    salvage_ok=0
    if [[ -f "$OUT/h1_merged_salvage.json" ]] \
      || [[ -f "$OUT_H1V2/h1v2_merged_salvage.json" ]] \
      || [[ -f "$OUT_H1V2/h1v2_adapter_salvage.json" ]]; then
      salvage_ok=1
    fi
    if (( push_alive == 1 )) && (( salvage_ok == 0 )); then
      log "sim harvested but ${push_which:-merged} HF push still running; defer early-teardown (recheck 60s)"
      sleep 60
      continue
    fi
    # Soft cap: if push has been running >20 min after sim harvest, proceed.
    if (( push_alive == 1 )); then
      if [[ ! -f "$OUT/.push_wait_started" ]]; then
        date -u +%s >"$OUT/.push_wait_started"
        log "${push_which:-merged} push still alive; start 20min teardown grace"
        sleep 60
        continue
      fi
      started=$(cat "$OUT/.push_wait_started")
      if (( now - started < 1200 )); then
        log "${push_which:-merged} push grace $((now - started))s/1200s; defer teardown"
        sleep 60
        continue
      fi
      log "WARN: ${push_which:-merged} push grace exhausted; tearing down (adapter salvage remains)"
    fi
    date -u +%Y-%m-%dT%H:%M:%SZ >"$OUT/host_harvest.done"
    log "all artifacts harvested (H1 + H1v2 gate); early-teardown mine-sim-1 (stop $/h burn)"
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
