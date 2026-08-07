#!/usr/bin/env bash
# Host-side poller for H5 α=0.50 n80 artifacts → triage → h5_a50_decision.json.
set -euo pipefail

SSH=(ssh -i "$HOME/.ssh/id_ed25519" -o StrictHostKeyChecking=accept-new
     -o ConnectTimeout=15 -p 40301 root@69.63.236.160)
SCP=(scp -i "$HOME/.ssh/id_ed25519" -o StrictHostKeyChecking=accept-new
     -P 40301)
OUT=/home/const/subnet120/mining/experiments/s4-h5-talentpigs/results
TRIAGE_PY=/home/const/subnet120/mining/experiments/s4-h1-sft/triage_sim.py
mkdir -p "$OUT" "$OUT/triage_in_a50"
log() { echo "[h5-a50-harvest] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

HARVEST_STOP_UTC=${HARVEST_STOP_UTC:-2026-08-07T11:45:00Z}
deadline=$(date -u -d "$HARVEST_STOP_UTC" +%s 2>/dev/null || date -u -d '2026-08-07 11:45:00' +%s)
got_result=0
got_triage=0

log "polling mine-sim-1 for H5 α0.50 n80 → $OUT (stop ${HARVEST_STOP_UTC})"

while true; do
  now=$(date -u +%s)
  if (( now >= deadline )); then
    log "deadline reached; stop (got_result=$got_result got_triage=$got_triage)"
    exit 0
  fi

  if "${SSH[@]}" 'test -f /root/affine_data/h5_kt50_sim_progress.json' 2>/dev/null; then
    "${SCP[@]}" root@69.63.236.160:/root/affine_data/h5_kt50_sim_progress.json \
      "$OUT/h5_kt50_sim_progress.json" 2>/dev/null || true
  fi

  if (( got_result == 0 )); then
    if "${SSH[@]}" 'test -f /root/affine_data/h5_kt50_sim_result.json' 2>/dev/null; then
      "${SCP[@]}" root@69.63.236.160:/root/affine_data/h5_kt50_sim_result.json \
        "$OUT/h5_kt50_sim_result.json"
      for f in h5_kt50_sim_result_artifact.json h5_kt50_identity.json \
               h5_kt50_merge_meta.json; do
        if "${SSH[@]}" "test -f /root/affine_data/$f" 2>/dev/null; then
          "${SCP[@]}" "root@69.63.236.160:/root/affine_data/$f" "$OUT/$f" \
            2>/dev/null || true
        fi
      done
      if "${SSH[@]}" 'ls /root/affine_data/h5_kt50_sim_result*.json >/dev/null 2>&1'; then
        "${SCP[@]}" 'root@69.63.236.160:/root/affine_data/h5_kt50_sim_result*.json' \
          "$OUT/" 2>/dev/null || true
      fi
      got_result=1
      log "got h5_kt50_sim_result.json"
      date -u +%Y-%m-%dT%H:%M:%SZ >"$OUT/h5_a50_sim_n80_harvested.stamp"
    fi
  fi

  if (( got_result == 1 && got_triage == 0 )); then
    rm -f "$OUT/triage_in_a50/h1_sim_result.json"
    cp -f "$OUT/h5_kt50_sim_result.json" "$OUT/triage_in_a50/h1_sim_result.json"
    if python3 "$TRIAGE_PY" \
        --results-dir "$OUT/triage_in_a50" \
        --out "$OUT/h5_a50_decision.json"; then
      got_triage=1
      action=$(python3 -c "import json;print(json.load(open('$OUT/h5_a50_decision.json'))['primary']['action'])" 2>/dev/null || echo '?')
      margin=$(python3 -c "import json;print(json.load(open('$OUT/h5_a50_decision.json'))['primary']['margin'])" 2>/dev/null || echo '?')
      log "triage → h5_a50_decision.json action=$action margin=$margin"
      date -u +%Y-%m-%dT%H:%M:%SZ >"$OUT/host_harvest_h5_a50.done"
      log "done; exiting"
      exit 0
    else
      log "triage failed; will retry"
    fi
  fi

  sleep 45
done
