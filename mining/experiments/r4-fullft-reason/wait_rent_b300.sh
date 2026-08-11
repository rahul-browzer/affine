#!/usr/bin/env bash
# Host poller: rent mine-r4-fullft-1 on first free 8×B300 (else 8×B200).
# Cap 25 mine-*. Exits after one successful rent or if name already live.
# No validator pods. Always --ttl. No bulk rm.
set -euo pipefail

ROOT=/home/const/subnet120
EXP="$ROOT/mining/experiments/r4-fullft-reason"
LOG="$EXP/logs/wait_rent_b300.log"
PIDF="$EXP/logs/wait_rent_b300.pid"
STAMP="$EXP/artifacts/rented.json"
NAME=${POD_NAME:-mine-r4-fullft-1}
TTL=${TTL:-24h}
CAP=${MINE_CAP:-25}
POLL_S=${POLL_S:-45}
MAX_ITERS=${MAX_ITERS:-480}  # ~6h @45s

mkdir -p "$EXP/logs" "$EXP/artifacts"
echo $$ >"$PIDF"
exec >>"$LOG" 2>&1

# shellcheck disable=SC1091
source "$ROOT/.venv/bin/activate"

log() { echo "[r4-rent] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

# lium ps table wraps names; always use JSON.
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

already_live() {
  mine_names | grep -qx "$NAME" || return 1
  return 0
}

mine_count() {
  mine_names | wc -l
}

stock_ok() {
  local gpu=$1
  local out
  out=$(lium ls --gpu "$gpu" --count 8 2>&1 || true)
  if echo "$out" | grep -qiE 'All .* currently rented|No nodes|0 shown'; then
    return 1
  fi
  echo "$out" | grep -qi 'Nodes' || return 1
  echo "$out" | grep -qiE "${gpu}" || return 1
  echo "$out" | grep -qiE '★|[0-9]+×'"$gpu" || return 1
  return 0
}

try_rent() {
  local gpu=$1
  log "attempting lium up gpu=$gpu name=$NAME ttl=$TTL"
  if ! lium ls --gpu "$gpu" --count 8; then
    log "ls failed for $gpu"
    return 1
  fi
  set +e
  lium up 1 --name "$NAME" --ttl "$TTL" --no-ssh -y --ports 12
  local rc=$?
  set -e
  if (( rc != 0 )); then
    log "lium up rc=$rc — retry filter form"
    set +e
    lium up --gpu "$gpu" -c 8 --name "$NAME" --ttl "$TTL" --no-ssh -y --ports 12
    rc=$?
    set -e
  fi
  return "$rc"
}

write_stamp() {
  python3 - <<PY
import json, subprocess, time
from pathlib import Path
try:
    ps = subprocess.check_output(["lium", "ps", "--format", "json"], text=True, timeout=60)
except Exception as e:
    ps = f"err:{e}"
Path("$STAMP").write_text(json.dumps({
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "pass": 2067,
    "name": "$NAME",
    "ttl": "$TTL",
    "axis": "R4-fullft-reason",
    "ps_json": ps[:4000],
}, indent=2) + "\n")
print("STAMP_OK", "$STAMP")
PY
}

log "start name=$NAME cap=$CAP poll=${POLL_S}s max_iters=$MAX_ITERS"

# Smoke-test JSON parse once
log "live_mines=$(mine_names | tr '\n' ' ')|count=$(mine_count)"

if already_live; then
  log "already live — exit"
  write_stamp || true
  exit 0
fi

for i in $(seq 1 "$MAX_ITERS"); do
  if already_live; then
    log "detected live at iter=$i"
    write_stamp
    exit 0
  fi
  n=$(mine_count)
  if (( n >= CAP )); then
    log "ABORT at cap: mine_count=$n >= $CAP"
    exit 3
  fi
  # Prefer B300; B200 only if B300 stock empty (operator directive).
  gpu=""
  if stock_ok B300; then
    gpu=B300
  elif stock_ok B200; then
    gpu=B200
    log "B300×8 empty — falling back to B200×8"
  else
    if (( i % 8 == 1 )); then
      bal=$(lium balance 2>/dev/null | tr -d '\n' | head -c 80 || true)
      log "iter=$i no 8×B300/B200; mine=$n/$CAP bal=$bal"
    fi
    sleep "$POLL_S"
    continue
  fi

  if try_rent "$gpu"; then
    sleep 8
    if already_live; then
      log "RENTED ok gpu=$gpu"
      write_stamp
      lium ps --format json | head -c 2000 || true
      lium balance || true
      exit 0
    fi
    log "up returned 0 but name not in ps — keep polling"
  else
    log "rent failed gpu=$gpu iter=$i"
  fi
  sleep "$POLL_S"
done

log "TIMEOUT after $MAX_ITERS iters — no rent"
exit 2
