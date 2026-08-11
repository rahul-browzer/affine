#!/usr/bin/env bash
# Host: when fleet-rent stamps rented_*.json, bootstrap that axis (R4 first).
# Does not rent. Does not touch non-mine pods. Idempotent per stamp.
set -euo pipefail

ROOT=/home/const/subnet120
EXP="$ROOT/mining/experiments/fleet-rent"
STAMP_DIR="$EXP/artifacts"
LOG="$EXP/logs/wait_bootstrap_fleet.log"
PIDF="$EXP/logs/wait_bootstrap_fleet.pid"
DONE_DIR="$EXP/artifacts/bootstrapped"
# Match fleet-rent longevity: empty B300 waits can last many hours.
# 86400×5s ≈ 5d; do not leave rents un-armed after a short TIMEOUT.
POLL_S=${POLL_S:-5}
MAX_ITERS=${MAX_ITERS:-86400}
PASS=${PASS:-2135}

mkdir -p "$EXP/logs" "$STAMP_DIR" "$DONE_DIR"
echo $$ >"$PIDF"
exec >>"$LOG" 2>&1

# shellcheck disable=SC1091
source "$ROOT/.venv/bin/activate"

log() { echo "[fleet-boot] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

resolve_ssh() {
  local name=$1
  POD_NAME="$name" python3 - <<'PY'
import json, os, re, subprocess, sys
name = os.environ["POD_NAME"]
raw = subprocess.check_output(["lium", "ps", "--format", "json"], text=True, timeout=60)
pods = json.loads(raw)
if isinstance(pods, dict):
    pods = pods.get("pods") or pods.get("data") or []
for p in pods:
    if not isinstance(p, dict):
        continue
    if (p.get("name") or "") != name:
        continue
    ip = p.get("ip") or ""
    ports = p.get("ports") or {}
    port = ports.get("22") or ports.get(22)
    cmd = p.get("ssh_cmd") or ""
    m = re.search(r"ssh\s+root@(\S+)\s+-p\s+(\d+)", cmd)
    if m:
        ip, port = m.group(1), int(m.group(2))
    if ip and port:
        print(f"{ip} {port}")
        sys.exit(0)
sys.exit(1)
PY
}

bootstrap_r4() {
  local name=$1 host=$2 port=$3
  log "bootstrap R4 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r4-fullft-reason/upload_and_launch.sh"
}

bootstrap_r5() {
  local name=$1 host=$2 port=$3
  log "bootstrap R5 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r5-nonking-base/upload_and_launch.sh"
}

bootstrap_r6() {
  local name=$1 host=$2 port=$3
  log "bootstrap R6 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r6-thought-format/upload_and_launch.sh"
}

bootstrap_r7() {
  local name=$1 host=$2 port=$3
  log "bootstrap R7 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r7-data-filter/upload_and_launch.sh"
}

bootstrap_r8() {
  local name=$1 host=$2 port=$3
  log "bootstrap R8 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r8-reinforce-reason/upload_and_launch.sh"
}

bootstrap_r3b() {
  local name=$1 host=$2 port=$3
  log "bootstrap R3b upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r3b-grpo-alt/upload_and_launch.sh"
}

bootstrap_r9() {
  local name=$1 host=$2 port=$3
  log "bootstrap R9 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r9-teacher-zc/upload_and_launch.sh"
}

bootstrap_r4b() {
  local name=$1 host=$2 port=$3
  log "bootstrap R4b upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r4b-fullft-lr/upload_and_launch.sh"
}

bootstrap_r5b() {
  local name=$1 host=$2 port=$3
  log "bootstrap R5b upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r5b-talent-base/upload_and_launch.sh"
}

bootstrap_r10() {
  local name=$1 host=$2 port=$3
  log "bootstrap R10 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r10-merge-rl/upload_and_launch.sh"
}

bootstrap_r6b() {
  local name=$1 host=$2 port=$3
  log "bootstrap R6b upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r6b-long-thought/upload_and_launch.sh"
}

bootstrap_r11() {
  local name=$1 host=$2 port=$3
  log "bootstrap R11 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r11-online-dpo/upload_and_launch.sh"
}


bootstrap_r12() {
  local name=$1 host=$2 port=$3
  log "bootstrap R12 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r12-bon-reason/upload_and_launch.sh"
}

bootstrap_r13() {
  local name=$1 host=$2 port=$3
  log "bootstrap R13 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r13-offline-dpo/upload_and_launch.sh"
}

bootstrap_r14() {
  local name=$1 host=$2 port=$3
  log "bootstrap R14 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r14-kevin-rl/upload_and_launch.sh"
}

bootstrap_r15() {
  local name=$1 host=$2 port=$3
  log "bootstrap R15 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r15-pandora-rl/upload_and_launch.sh"
}

bootstrap_r16() {
  local name=$1 host=$2 port=$3
  log "bootstrap R16 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r16-golden-rl/upload_and_launch.sh"
}

bootstrap_r17() {
  local name=$1 host=$2 port=$3
  log "bootstrap R17 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r17-coder-rl/upload_and_launch.sh"
}

bootstrap_r18() {
  local name=$1 host=$2 port=$3
  log "bootstrap R18 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r18-sbs-grpo/upload_and_launch.sh"
}

bootstrap_r19() {
  local name=$1 host=$2 port=$3
  log "bootstrap R19 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r19-talent-grpo/upload_and_launch.sh"
}

bootstrap_r20() {
  local name=$1 host=$2 port=$3
  log "bootstrap R20 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r20-kevin-grpo/upload_and_launch.sh"
}

bootstrap_r21() {
  local name=$1 host=$2 port=$3
  log "bootstrap R21 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r21-pandora-grpo/upload_and_launch.sh"
}

bootstrap_r22() {
  local name=$1 host=$2 port=$3
  log "bootstrap R22 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r22-golden-grpo/upload_and_launch.sh"
}

bootstrap_r23() {
  local name=$1 host=$2 port=$3
  log "bootstrap R23 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r23-diane-grpo/upload_and_launch.sh"
}

bootstrap_r24() {
  local name=$1 host=$2 port=$3
  log "bootstrap R24 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r24-longctx-grpo/upload_and_launch.sh"
}

bootstrap_r25() {
  local name=$1 host=$2 port=$3
  log "bootstrap R25 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r25-hitemp-grpo/upload_and_launch.sh"
}

bootstrap_r26() {
  local name=$1 host=$2 port=$3
  log "bootstrap R26 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r26-lotemp-grpo/upload_and_launch.sh"
}

bootstrap_r27() {
  local name=$1 host=$2 port=$3
  log "bootstrap R27 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r27-bigg-grpo/upload_and_launch.sh"
}

bootstrap_r28() {
  local name=$1 host=$2 port=$3
  log "bootstrap R28 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r28-hilr-grpo/upload_and_launch.sh"
}

bootstrap_r29() {
  local name=$1 host=$2 port=$3
  log "bootstrap R29 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r29-hirank-grpo/upload_and_launch.sh"
}

bootstrap_r30() {
  local name=$1 host=$2 port=$3
  log "bootstrap R30 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r30-hialpha-grpo/upload_and_launch.sh"
}

bootstrap_r31() {
  local name=$1 host=$2 port=$3
  log "bootstrap R31 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r31-nodrop-grpo/upload_and_launch.sh"
}

bootstrap_r32() {
  local name=$1 host=$2 port=$3
  log "bootstrap R32 upload_and_launch name=$name host=$host port=$port"
  DST_HOST="$host" DST_PORT="$port" POD_NAME="$name" \
    bash "$ROOT/mining/experiments/r32-kl-grpo/upload_and_launch.sh"
}

mark_bootstrapped() {
  local done=$1 name=$2 axis=$3 host=$4 port=$5
  printf '%s\n' "{\"utc\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"pass\":$PASS,\"name\":\"$name\",\"axis\":\"$axis\",\"host\":\"$host\",\"port\":$port}" \
    >"$done"
  log "BOOTSTRAPPED $name → $done"
}

process_stamp() {
  local stamp=$1
  local base done name axis
  base=$(basename "$stamp")
  done="$DONE_DIR/${base}.bootstrapped"
  if [[ -f "$done" ]]; then
    return 0
  fi
  name=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["name"])' "$stamp")
  axis=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("axis",""))' "$stamp")
  log "new stamp $base name=$name axis=$axis — resolve SSH"
  local ssh_line host port
  # Pod may need a minute after rent before SSH answers.
  for _ in $(seq 1 30); do
    if ssh_line=$(resolve_ssh "$name"); then
      break
    fi
    sleep 10
  done
  if [[ -z "${ssh_line:-}" ]]; then
    log "FAIL resolve SSH for $name — will retry later"
    return 1
  fi
  host=${ssh_line%% *}
  port=${ssh_line##* }
  case "$name" in
    mine-r4-fullft-1)
      if bootstrap_r4 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r5-nonking-1)
      if bootstrap_r5 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r6-fmt-1)
      if bootstrap_r6 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r7-datafilt-1)
      if bootstrap_r7 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r8-reinforce-1)
      if bootstrap_r8 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r3-grpo-2)
      if bootstrap_r3b "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r24-longctx-1)
      if bootstrap_r24 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r25-hitemp-1)
      if bootstrap_r25 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r26-lotemp-1)
      if bootstrap_r26 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r27-bigg-1)
      if bootstrap_r27 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r28-hilr-1)
      if bootstrap_r28 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r29-hirank-1)
      if bootstrap_r29 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r30-hialpha-1)
      if bootstrap_r30 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r31-nodrop-1)
      if bootstrap_r31 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r32-kl-1)
      if bootstrap_r32 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r9-teacher-zc-1)
      if bootstrap_r9 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r4-fullft-2)
      if bootstrap_r4b "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r5-nonking-2)
      if bootstrap_r5b "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r10-merge-rl-1)
      if bootstrap_r10 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r6-fmt-2)
      if bootstrap_r6b "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r11-odpo-1)
      if bootstrap_r11 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r12-bon-1)
      if bootstrap_r12 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r13-odpo-1)
      if bootstrap_r13 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r14-kevin-rl-1)
      if bootstrap_r14 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r15-pandora-rl-1)
      if bootstrap_r15 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r16-golden-rl-1)
      if bootstrap_r16 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r17-coder-rl-1)
      if bootstrap_r17 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r18-sbs-grpo-1)
      if bootstrap_r18 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r19-talent-grpo-1)
      if bootstrap_r19 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r20-kevin-grpo-1)
      if bootstrap_r20 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r21-pandora-grpo-1)
      if bootstrap_r21 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r22-golden-grpo-1)
      if bootstrap_r22 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    mine-r23-diane-grpo-1)
      if bootstrap_r23 "$name" "$host" "$port"; then
        mark_bootstrapped "$done" "$name" "$axis" "$host" "$port"
      else
        log "FAIL bootstrap $name"
        return 1
      fi
      ;;
    *)
      # Other axes: stamp notice for next Ralph pass (plans exist; launchers TBD).
      printf '%s\n' "{\"utc\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"pass\":$PASS,\"name\":\"$name\",\"axis\":\"$axis\",\"host\":\"$host\",\"port\":$port,\"note\":\"needs_axis_uploader\"}" \
        >"$done"
      log "STAMPED pending uploader for $name ($axis) ssh=$host:$port"
      ;;
  esac
}

log "start poll=${POLL_S}s max_iters=$MAX_ITERS pass=$PASS stamp_dir=$STAMP_DIR"

for i in $(seq 1 "$MAX_ITERS"); do
  shopt -s nullglob
  stamps=("$STAMP_DIR"/rented_*.json)
  shopt -u nullglob
  for stamp in "${stamps[@]:-}"; do
    [[ -f "$stamp" ]] || continue
    process_stamp "$stamp" || true
  done
  if (( i % 15 == 1 )); then
    n_stamps=$(find "$STAMP_DIR" -maxdepth 1 -name 'rented_*.json' | wc -l)
    n_done=$(find "$DONE_DIR" -maxdepth 1 -name '*.bootstrapped' | wc -l)
    log "iter=$i rented_stamps=$n_stamps bootstrapped=$n_done"
  fi
  sleep "$POLL_S"
done

log "TIMEOUT after $MAX_ITERS iters"
exit 2
