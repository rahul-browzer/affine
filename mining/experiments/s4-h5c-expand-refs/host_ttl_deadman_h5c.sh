#!/usr/bin/env bash
# Host-side deadman for mine-h5c-1. At DEADLINE_UTC, terminate mine-h5c-1 only.
# Pod also has Lium TTL remove_at 2026-08-07T19:37:46Z; this fires earlier (19:00Z)
# to cut idle burn if harvest already finished or pipe stuck.
set -euo pipefail

POD_NAME=mine-h5c-1
DEADLINE_UTC=${DEADLINE_UTC:-2026-08-07T19:00:00Z}
LOG=/home/const/subnet120/mining/.ralph/host_ttl_deadman_h5c.log
mkdir -p "$(dirname "$LOG")"
log() { echo "[host-deadman-h5c] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

pod_alive() {
  local name
  name=$(lium describe "$POD_NAME" 2>/dev/null | awk '/^Name/{print $2; exit}') || return 1
  [[ "$name" == "$POD_NAME" ]]
}

deadline_epoch=$(date -u -d "$DEADLINE_UTC" +%s)
log "armed: kill $POD_NAME at $DEADLINE_UTC (epoch $deadline_epoch) if still live"

if ! pod_alive; then
  log "pod $POD_NAME not found at arm time; exit"
  exit 0
fi
log "confirmed live at arm time"

while true; do
  now=$(date -u +%s)
  if (( now >= deadline_epoch )); then
    break
  fi
  if ! pod_alive; then
    log "pod $POD_NAME already absent; exit"
    exit 0
  fi
  sleep 60
done

# HARD RULE: verify name immediately before every rm.
name=$(lium describe "$POD_NAME" 2>/dev/null | awk '/^Name/{print $2; exit}')
if [[ "$name" != "$POD_NAME" ]]; then
  log "FATAL: describe Name='$name' != $POD_NAME; refusing rm"
  exit 2
fi
case "$name" in
  mine-*) ;;
  *)
    log "FATAL: name does not start with mine-; refusing rm"
    exit 2
    ;;
esac
log "deadline reached; lium rm $POD_NAME (verified name=$name)"
lium rm "$POD_NAME" -y
log "rm issued"
exit 0
