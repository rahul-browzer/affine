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
POLL_S=${POLL_S:-10}  # snatch B300×8 fast when stock flickers (was 30)
# Fire this many distinct axis names per round in parallel (p2129).
# Serial one-name blind-fire misses multi-node flickers and races poorly.
PARALLEL_N=${PARALLEL_N:-4}
MAX_ITERS=${MAX_ITERS:-2160}  # ~6h @10s
PASS=${PASS:-2108}

# Distinct experimental axes (one pod each). Skip names already live.
# Format: name|axis_id|short_note
# R24–R32 (structural) sit after R3b — ahead of cosmetic parent-swap GRPO.
QUEUE=(
  # R4/R4b/R5 REFUTED. R6 retargeted onto mine-r4-fullft-1 (p2126) — do not re-rent R6.
  "mine-r7-datafilt-1|R7|high-Reason data filter curriculum FT"
  "mine-r8-reinforce-1|R8|REINFORCE on Reason (full-rank / alt base)"
  # R3b live on mine-r3-grpo-1 (p2127 retarget after R3 REFUTE) — do not re-rent.
  "mine-r24-longctx-1|R24|Tok GRPO max_len=16384 max_new=1024 (≠ R3 6144/512)"
  "mine-r25-hitemp-1|R25|Tok GRPO temperature=1.2 (≠ R3 temp=0.8)"
  "mine-r26-lotemp-1|R26|Tok GRPO temperature=0.5 (≠ R3 0.8 / R25 1.2)"
  "mine-r27-bigg-1|R27|Tok GRPO group_size=16 (≠ R3 G=4 / R3b G=8+alt-lr)"
  "mine-r28-hilr-1|R28|Tok GRPO lr=2e-5 (≠ R3 5e-6; isolates LR vs R3b)"
  "mine-r29-hirank-1|R29|Tok GRPO lora_r=64 (≠ R3 r=16; isolates rank vs R3b)"
  "mine-r30-hialpha-1|R30|Tok GRPO lora_alpha=128 r=16 (≠ R3 α=32; isolates α vs R29)"
  "mine-r31-nodrop-1|R31|Tok GRPO lora_dropout=0.0 (≠ R3 0.05; isolates dropout)"
  "mine-r32-kl-1|R32|Tok GRPO kl_coef=0.02 vs base (≠ R3 kl=0; isolates KL)"
  "mine-r9-teacher-zc-1|R9|teacher-z_C imitation / format prior"
  "mine-r5-nonking-2|R5b|Talent/kevin non-king base FT"
  "mine-r10-merge-rl-1|R10|merge+RL hybrid Reason"
  "mine-r6-fmt-2|R6b|long-thought vs short-thought ablate"
  "mine-r11-odpo-1|R11|online DPO on live teacher Reason"
  "mine-r12-bon-1|R12|Best-of-N CE on live teacher Reason"
  "mine-r13-odpo-1|R13|offline DPO on duel Reason prefs"
  "mine-r14-kevin-rl-1|R14|kevin954-init REINFORCE on teacher Reason"
  "mine-r15-pandora-rl-1|R15|pandora-box-init REINFORCE on teacher Reason"
  "mine-r16-golden-rl-1|R16|golden-crown-init REINFORCE on teacher Reason"
  "mine-r17-coder-rl-1|R17|Qwen3-Coder base REINFORCE on teacher Reason"
  "mine-r18-sbs-grpo-1|R18|pure sbs-v2-init Reason-GRPO (≠ R3/R10)"
  "mine-r19-talent-grpo-1|R19|TalentPigs-init Reason-GRPO (≠ R3/R5b/R18)"
  "mine-r20-kevin-grpo-1|R20|kevin954-init Reason-GRPO (≠ R3/R14/R19)"
  "mine-r21-pandora-grpo-1|R21|pandora-box-init Reason-GRPO (≠ R3/R15/R20)"
  "mine-r22-golden-grpo-1|R22|golden-crown-init Reason-GRPO (≠ R3/R16/R18–R21)"
  "mine-r23-diane-grpo-1|R23|diane613-init Reason-GRPO (≠ R3/R16/R18–R22)"
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

stock_ok() {
  local gpu=$1
  lium ls --gpu "$gpu" --count 8 --format json 2>/dev/null \
    | python3 -c 'import json,sys
try:
    d=json.load(sys.stdin)
except Exception:
    sys.exit(1)
sys.exit(0 if isinstance(d,list) and len(d)>0 else 1)'
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

log "start target=$TARGET cap=$CAP poll=${POLL_S}s parallel=$PARALLEL_N max_iters=$MAX_ITERS pass=$PASS"
log "live_mines=$(mine_names | tr '\n' ' ')|count=$(mine_count)"

for i in $(seq 1 "$MAX_ITERS"); do
  n=$(mine_count)
  if (( n >= TARGET )); then
    log "TARGET reached mine_count=$n >= $TARGET — exit"
    exit 0
  fi
  if (( n >= CAP )); then
    log "ABORT at cap mine_count=$n >= $CAP"
    exit 3
  fi
  if ! bal_ok; then
    log "ABORT balance below \$10k floor"
    exit 4
  fi

  # Cap parallel width by remaining slots under CAP.
  local_n=$PARALLEL_N
  remain=$(( CAP - n ))
  if (( remain < local_n )); then
    local_n=$remain
  fi
  if (( local_n < 1 )); then
    log "ABORT at cap mine_count=$n >= $CAP"
    exit 3
  fi

  mapfile -t slots < <(next_slots "$local_n" || true)
  if (( ${#slots[@]} == 0 )); then
    log "QUEUE exhausted with mine_count=$n < target=$TARGET — exit"
    exit 0
  fi

  # Parallel blind-fire: one B300 attempt per pending axis name, then B200
  # fallbacks for misses. snatch multi-node flickers; race better vs serial.
  declare -A slot_axis=() slot_note=() rented_gpu=()
  names=()
  for slot in "${slots[@]}"; do
    name=${slot%%|*}
    rest=${slot#*|}
    axis=${rest%%|*}
    note=${rest#*|}
    if name_live "$name"; then
      continue
    fi
    names+=("$name")
    slot_axis["$name"]=$axis
    slot_note["$name"]=$note
  done
  if (( ${#names[@]} == 0 )); then
    sleep 2
    continue
  fi

  pids=()
  for name in "${names[@]}"; do
    (
      if try_rent B300 "$name"; then
        echo "B300" >"/tmp/fleet_rent_${name}.gpu"
        exit 0
      fi
      exit 1
    ) &
    pids+=($!)
  done
  for pid in "${pids[@]}"; do
    wait "$pid" || true
  done

  miss=()
  for name in "${names[@]}"; do
    if [[ -f "/tmp/fleet_rent_${name}.gpu" ]]; then
      rented_gpu["$name"]=$(cat "/tmp/fleet_rent_${name}.gpu")
      rm -f "/tmp/fleet_rent_${name}.gpu"
    else
      miss+=("$name")
    fi
  done

  # B200 fallback only when 8×B200 stock exists. Empty B200 waves double API
  # latency and eat the B300 flicker window (p2132).
  if (( ${#miss[@]} > 0 )) && stock_ok B200; then
    pids=()
    for name in "${miss[@]}"; do
      (
        if try_rent B200 "$name"; then
          echo "B200" >"/tmp/fleet_rent_${name}.gpu"
          exit 0
        fi
        exit 1
      ) &
      pids+=($!)
    done
    for pid in "${pids[@]}"; do
      wait "$pid" || true
    done
    for name in "${miss[@]}"; do
      if [[ -f "/tmp/fleet_rent_${name}.gpu" ]]; then
        rented_gpu["$name"]=$(cat "/tmp/fleet_rent_${name}.gpu")
        rm -f "/tmp/fleet_rent_${name}.gpu"
        log "B300×8 empty — fell back to B200×8 for $name"
      fi
    done
  elif (( ${#miss[@]} > 0 )); then
    if (( i % 20 == 1 )); then
      log "skip B200 fallback (B200×8 stock empty); keep B300-only fire"
    fi
  fi

  n_rented=${#rented_gpu[@]}
  if (( n_rented == 0 )); then
    if (( i % 20 == 1 )); then
      bal=$(lium balance 2>/dev/null | tr -d '\n' | head -c 80 || true)
      log "iter=$i no 8×B300/B200 (parallel×${#names[@]} miss); mine=$n/$TARGET (cap $CAP) next=${names[*]} bal=$bal"
    fi
    if (( POLL_S > 0 )); then
      sleep "$POLL_S"
    fi
    continue
  fi

  sleep 10
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
  # Immediately try next round if more stock (no long sleep).
done

log "TIMEOUT after $MAX_ITERS iters — mine_count=$(mine_count)"
exit 2
