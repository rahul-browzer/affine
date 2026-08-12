#!/usr/bin/env bash
# Host poller: rent many mine-* 8×B300 (else 8×B200) with distinct axes.
# Keeps going until TARGET live mine pods or CAP, not one-and-done.
# Never touches non-mine pods. Always --ttl. No bulk rm.
set -euo pipefail

ROOT=/home/const/subnet120
EXP="$ROOT/mining/experiments/fleet-rent"
LOG="$EXP/logs/wait_fleet_b300.log"
PIDF="$EXP/logs/wait_fleet_b300.pid"
STAMP_DIR="$EXP/artifacts"
TTL=${TTL:-24h}
CAP=${MINE_CAP:-25}
# Burn floor ≈ $833/h ÷ ~$64/h ≈ 13 boxes; keep renting to CAP (floor≠ceiling).
TARGET=${TARGET_MINES:-25}
# Empty-stock sleep between ls polls. 0 → 0.25s (avoid CPU spin; ls≈0.6s anyway).
POLL_S=${POLL_S:-0}
# Max distinct axes to claim per stock sighting (one node → one name).
PARALLEL_N=${PARALLEL_N:-22}
MAX_ITERS=${MAX_ITERS:-86400}
PASS=${PASS:-2134}

# Distinct experimental axes (one pod each). Skip names already live.
# Format: name|axis_id|short_note
# R24–R32 (structural) sit after R3b — ahead of cosmetic parent-swap GRPO.
QUEUE=(
  # R4/R4b/R5/R6/R6b/R8 REFUTED. R7 live on warm mine-r4-fullft-1 (p2158) — do not re-rent R7/R8.
  # R3b live on mine-r3-grpo-1 (p2127 retarget after R3 REFUTE) — do not re-rent.
  # R24 live on mine-r3-grpo-1 (p2205 warm-arm after R15 REFUTE) — do not re-rent.
  # R24 live on mine-r3; R25=mine-r25-hitemp-1; R26=mine-crown-1 — do not re-rent.
  # p2224: sbs-v2 still GATED (index 403) — demote R10/R18; next=R5b (weights_ok).
  # "mine-r10-merge-rl-1|R10|Tok×sbs-v2 α-merge → Reason-GRPO (BLOCKED Hub gated)"
  # "mine-r18-sbs-grpo-1|R18|pure sbs-v2-init Reason-GRPO (BLOCKED Hub gated)"
  "mine-r5-nonking-2|R5b|Talent/kevin non-king base FT"
  "mine-r19-talent-grpo-1|R19|TalentPigs-init Reason-GRPO (≠ R3/R5b; sbs gated)"
  "mine-r22-golden-grpo-1|R22|golden-crown-init Reason-GRPO (≠ R3/R16/R19–R21)"
  "mine-r23-diane-grpo-1|R23|diane613-init Reason-GRPO (≠ R3/R16/R19–R22)"
  "mine-r27-bigg-1|R27|Tok GRPO group_size=16 (≠ R3 G=4 / R3b G=8+alt-lr)"
  "mine-r28-hilr-1|R28|Tok GRPO lr=2e-5 (≠ R3 5e-6; isolates LR vs R3b)"
  "mine-r29-hirank-1|R29|Tok GRPO lora_r=64 (≠ R3 r=16; isolates rank vs R3b)"
  "mine-r30-hialpha-1|R30|Tok GRPO lora_alpha=128 r=16 (≠ R3 α=32; isolates α vs R29)"
  "mine-r31-nodrop-1|R31|Tok GRPO lora_dropout=0.0 (≠ R3 0.05; isolates dropout)"
  "mine-r32-kl-1|R32|Tok GRPO kl_coef=0.02 vs base (≠ R3 kl=0; isolates KL)"
  # p2233: guass-init GRPO (train FROM live reign-6).
  "mine-r33-guass-grpo-1|R33|guass-init Reason-GRPO (≠ R3 Tok / R19–R23; LoRA from live king)"
)

mkdir -p "$EXP/logs" "$STAMP_DIR"
echo $$ >"$PIDF"
exec >>"$LOG" 2>&1

# shellcheck disable=SC1091
source "$ROOT/.venv/bin/activate"

log() { echo "[fleet-rent] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

mine_names() {
  python3 - <<'PY'
import json, subprocess, sys
try:
    raw = subprocess.check_output(["lium", "ps", "--format", "json"], text=True, timeout=60)
except Exception as e:
    print(f"PS_FAIL {e}", file=sys.stderr)
    sys.exit(0)
try:
    data = json.loads(raw)
except Exception:
    sys.exit(0)
pods = data if isinstance(data, list) else data.get("pods") or data.get("data") or []
for p in pods:
    if not isinstance(p, dict):
        continue
    name = p.get("name") or p.get("Name") or p.get("pod_name") or ""
    if isinstance(name, str) and name.startswith("mine-"):
        print(name)
PY
}

mine_count() { mine_names | wc -l; }

name_live() {
  local n=$1
  mine_names | grep -qx "$n"
}

# Print available 8×$gpu node ids (prefer huid, else uuid), one per line.
list_nodes() {
  local gpu=$1
  # stderr discarded: empty stock prints "All … rented out" tips.
  lium ls --gpu "$gpu" --count 8 --format json 2>/dev/null \
    | python3 -c 'import json,sys
try:
    d=json.load(sys.stdin)
except Exception:
    sys.exit(0)
nodes = d if isinstance(d, list) else (d.get("nodes") or d.get("data") or [])
for n in nodes:
    if not isinstance(n, dict):
        continue
    nid = n.get("huid") or n.get("id") or n.get("name")
    if nid:
        print(nid)
'
}

stock_ok() {
  local gpu=$1
  list_nodes "$gpu" | grep -q .
}

next_slot() {
  local live
  live=$(mine_names | tr '\n' ' ')
  local ent name
  for ent in "${QUEUE[@]}"; do
    name=${ent%%|*}
    if ! echo " $live " | grep -q " $name "; then
      echo "$ent"
      return 0
    fi
  done
  return 1
}

# Emit up to $1 distinct non-live queue entries (one per line).
next_slots() {
  local want=${1:-1}
  local live ent name
  local -a out=()
  live=$(mine_names | tr '\n' ' ')
  for ent in "${QUEUE[@]}"; do
    name=${ent%%|*}
    if ! echo " $live " | grep -q " $name "; then
      out+=("$ent")
      if (( ${#out[@]} >= want )); then
        break
      fi
    fi
  done
  if (( ${#out[@]} == 0 )); then
    return 1
  fi
  printf '%s\n' "${out[@]}"
}

# Rent a concrete node id/huid (fast path once ls shows stock).
try_rent_node() {
  local node=$1 name=$2
  log "attempting lium up node=$node name=$name ttl=$TTL"
  set +e
  lium up "$node" --name "$name" --ttl "$TTL" --no-ssh -y
  local rc=$?
  set -e
  return "$rc"
}

# Legacy auto-select fallback (slower when empty; keep for rare ls/up races).
try_rent() {
  local gpu=$1 name=$2
  log "attempting lium up gpu=$gpu name=$name ttl=$TTL"
  set +e
  lium up --gpu "$gpu" -c 8 --name "$name" --ttl "$TTL" --no-ssh -y --ports 12
  local rc=$?
  set -e
  return "$rc"
}

write_rent_stamp() {
  local name=$1 axis=$2 gpu=$3 note=$4
  RENT_NAME="$name" RENT_AXIS="$axis" RENT_GPU="$gpu" RENT_NOTE="$note" \
  RENT_TTL="$TTL" RENT_PASS="$PASS" RENT_STAMP_DIR="$STAMP_DIR" \
  python3 - <<'PY'
import json, os, subprocess, time
from pathlib import Path
name = os.environ["RENT_NAME"]
try:
    ps = subprocess.check_output(["lium", "ps", "--format", "json"], text=True, timeout=60)
except Exception as e:
    ps = f"err:{e}"
path = Path(os.environ["RENT_STAMP_DIR"]) / f"rented_{name.replace('/', '_')}.json"
path.write_text(json.dumps({
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "pass": int(os.environ["RENT_PASS"]),
    "name": name,
    "axis": os.environ["RENT_AXIS"],
    "gpu": os.environ["RENT_GPU"],
    "note": os.environ["RENT_NOTE"],
    "ttl": os.environ["RENT_TTL"],
    "ps_json": ps[:4000],
}, indent=2) + "\n")
print("STAMP_OK", path)
PY
}

bal_ok() {
  python3 - <<'PY'
import subprocess, re, sys
try:
    raw = subprocess.check_output(["lium", "balance"], text=True, timeout=30)
except Exception:
    sys.exit(0)  # don't block rent on balance parse failure
m = re.search(r"([0-9]+(?:\.[0-9]+)?)", raw.replace(",", ""))
if not m:
    sys.exit(0)
bal = float(m.group(1))
# Hard floor $10k — refuse new rents below that.
sys.exit(0 if bal >= 10000 else 1)
PY
}

log "start target=$TARGET cap=$CAP poll=${POLL_S}s parallel=$PARALLEL_N max_iters=$MAX_ITERS pass=$PASS mode=ls-then-node-id"
log "live_mines=$(mine_names | tr '\n' ' ')|count=$(mine_count)"

empty_sleep() {
  # POLL_S=0 → brief pause so empty-stock loops don't peg a core (ls≈0.6s).
  if (( POLL_S > 0 )); then
    sleep "$POLL_S"
  else
    sleep 0.25
  fi
}

live_now=""
n=0
names=()
declare -A slot_axis=() slot_note=()

refresh_queue() {
  live_now=$(mine_names | tr '\n' ' ')
  n=$(echo "$live_now" | awk '{print NF}')
  if (( n >= TARGET )); then
    log "TARGET reached mine_count=$n >= $TARGET — exit"
    exit 0
  fi
  if (( n >= CAP )); then
    log "ABORT at cap mine_count=$n >= $CAP"
    exit 3
  fi
  local remain=$(( CAP - n ))
  local local_n=$PARALLEL_N
  if (( remain < local_n )); then
    local_n=$remain
  fi
  if (( local_n < 1 )); then
    log "ABORT at cap mine_count=$n >= $CAP"
    exit 3
  fi
  names=()
  slot_axis=()
  slot_note=()
  local ent name rest axis note
  for ent in "${QUEUE[@]}"; do
    name=${ent%%|*}
    rest=${ent#*|}
    axis=${rest%%|*}
    note=${rest#*|}
    if echo " $live_now " | grep -q " $name "; then
      continue
    fi
    names+=("$name")
    slot_axis["$name"]=$axis
    slot_note["$name"]=$note
    if (( ${#names[@]} >= local_n )); then
      break
    fi
  done
  if (( ${#names[@]} == 0 )); then
    log "QUEUE exhausted with mine_count=$n < target=$TARGET — exit"
    exit 0
  fi
}

refresh_queue

for i in $(seq 1 "$MAX_ITERS"); do
  # bal / ps only every 40 empty iters — keep the hunt on ls latency.
  if (( i == 1 || i % 40 == 0 )); then
    if ! bal_ok; then
      log "ABORT balance below \$10k floor"
      exit 4
    fi
    refresh_queue
  fi

  # Fast path (p2134): ls B300 (~0.6s) then rent concrete node ids.
  # Blind parallel `lium up --gpu` when empty burned ~20s/round and missed flickers.
  # B200 probed every 10th empty iter only — keep the B300 flicker window tight.
  mapfile -t b300_nodes < <(list_nodes B300 2>/dev/null || true)
  gpu_label=B300
  nodes=("${b300_nodes[@]}")
  if (( ${#nodes[@]} == 0 )) && (( i % 10 == 0 )); then
    mapfile -t b200_nodes < <(list_nodes B200 2>/dev/null || true)
    if (( ${#b200_nodes[@]} > 0 )); then
      gpu_label=B200
      nodes=("${b200_nodes[@]}")
      log "B300×8 empty — claiming B200×8 stock (${#nodes[@]} nodes)"
    fi
  fi

  if (( ${#nodes[@]} == 0 )); then
    if (( i % 40 == 1 )); then
      bal=$(lium balance 2>/dev/null | tr -d '\n' | head -c 80 || true)
      log "iter=$i ls-empty B300/B200×8; mine=$n/$TARGET (cap $CAP) next=${names[*]:0:6}… bal=$bal"
    fi
    empty_sleep
    continue
  fi

  # Stock appeared — refresh live names before claiming.
  refresh_queue
  if (( ${#names[@]} == 0 )); then
    continue
  fi

  # Pair each available node with next axis name; rent in parallel by node id.
  n_claim=${#nodes[@]}
  if (( n_claim > ${#names[@]} )); then
    n_claim=${#names[@]}
  fi
  log "STOCK ${gpu_label}×8 n=${#nodes[@]} — claiming $n_claim axes: ${names[*]:0:n_claim}"

  declare -A rented_gpu=()
  pids=()
  for ((j=0; j<n_claim; j++)); do
    name=${names[$j]}
    node=${nodes[$j]}
    (
      if try_rent_node "$node" "$name"; then
        echo "$gpu_label" >"/tmp/fleet_rent_${name}.gpu"
        exit 0
      fi
      # Race: node vanished between ls and up — one auto-select retry.
      if try_rent "$gpu_label" "$name"; then
        echo "$gpu_label" >"/tmp/fleet_rent_${name}.gpu"
        exit 0
      fi
      exit 1
    ) &
    pids+=($!)
  done
  for pid in "${pids[@]}"; do
    wait "$pid" || true
  done

  for ((j=0; j<n_claim; j++)); do
    name=${names[$j]}
    if [[ -f "/tmp/fleet_rent_${name}.gpu" ]]; then
      rented_gpu["$name"]=$(cat "/tmp/fleet_rent_${name}.gpu")
      rm -f "/tmp/fleet_rent_${name}.gpu"
    fi
  done

  n_rented=${#rented_gpu[@]}
  if (( n_rented == 0 )); then
    log "iter=$i STOCK sighting but 0 rents (${gpu_label} n=${#nodes[@]}) — keep polling"
    empty_sleep
    continue
  fi

  sleep 8
  for name in "${!rented_gpu[@]}"; do
    gpu=${rented_gpu[$name]}
    axis=${slot_axis[$name]}
    note=${slot_note[$name]}
    if name_live "$name"; then
      log "RENTED ok gpu=$gpu name=$name axis=$axis"
      write_rent_stamp "$name" "$axis" "$gpu" "$note" || true
    else
      log "up rc=0 but $name not in ps — keep polling"
    fi
  done
  refresh_queue
  # Immediately re-ls if more stock (no long sleep).
done

log "TIMEOUT after $MAX_ITERS iters — mine_count=$(mine_count)"
exit 2
