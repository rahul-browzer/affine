#!/usr/bin/env bash
# Pass 388: after Range-resume stamps tok331102.done, relaunch king (util=0.72)
# then chall from merged, clear n80 abort markers so watch_n80_retry can proceed.
# post_train was killed — its 120×15s king-wait would abort before Tok finished.
set -euo pipefail
source /root/venv/bin/activate
set -a
# shellcheck disable=SC1091
[[ -f /root/mine.env ]] && source /root/mine.env
set +a

LOG=/root/logs/h100_watch_tok_done_pass388.nohup
mkdir -p /root/logs
log() { echo "[p388-tokwatch] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*" | tee -a "$LOG"; }

DONE=/root/logs/tok331102.done
SNAP=/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/snapshots/eb8bf9a356a254f71faaa439e8abc3cfba572c53
BLOB1_SHA=3e0bd3310b597a826ed50503e7bcfa7d019462a15c335adbaac082c3a4cbb582
EXPECT1=35101763136
INC=/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/blobs/${BLOB1_SHA}.range.incomplete
FINAL=/root/hf/hub/models--Tok331102--affine-5EqYW8McUc-af10/blobs/${BLOB1_SHA}

log "START wait tok.done (or finalize range incomplete ${EXPECT1} B)"

deadline=$(( $(date +%s) + 7200 ))
while true; do
  if [[ -f "$DONE" ]]; then
    log "tok331102.done present: $(cat "$DONE" | head -1)"
    break
  fi
  # Fail-open finalize if Range process died after writing full size
  if [[ -f "$INC" ]]; then
    have=$(stat -c%s "$INC" 2>/dev/null || echo 0)
    if (( have >= EXPECT1 )) && [[ ! -f "$FINAL" ]]; then
      log "finalize incomplete have=$have → $FINAL (Range writer gone?)"
      mv -f "$INC" "$FINAL"
      ln -sfn "../../blobs/${BLOB1_SHA}" "$SNAP/model-00001-of-00002.safetensors"
      echo "$SNAP" > "$DONE"
      log "stamped $DONE"
      break
    fi
    if (( $(date +%s) % 60 < 5 )); then
      pct=$(python3 -c "print(round(100*${have}/${EXPECT1},1))")
      log "waiting range have=$have/$EXPECT1 pct=$pct"
    fi
  elif [[ -f "$FINAL" ]] && [[ ! -f "$DONE" ]]; then
    log "blob final present without done stamp — stamp now"
    ln -sfn "../../blobs/${BLOB1_SHA}" "$SNAP/model-00001-of-00002.safetensors"
    # require shard2 too
    if [[ -e "$SNAP/model-00002-of-00002.safetensors" ]]; then
      echo "$SNAP" > "$DONE"
      break
    fi
  fi
  if (( $(date +%s) >= deadline )); then
    log "TIMEOUT 2h waiting for Tok"
    exit 1
  fi
  # Range writer alive?
  if ! pgrep -f 'range.incomplete|p383-range|h100_tok_range' >/dev/null 2>&1; then
    # also check python holding the incomplete
    if ! lsof "$INC" >/dev/null 2>&1; then
      have=$(stat -c%s "$INC" 2>/dev/null || echo 0)
      log "WARN: no writer on incomplete have=$have (will keep waiting/finalize)"
    fi
  fi
  sleep 10
done

# Verify both shards readable
for f in model-00001-of-00002.safetensors model-00002-of-00002.safetensors; do
  real=$(readlink -f "$SNAP/$f")
  sz=$(stat -c%s "$real")
  log "ok $f -> $real size=$sz"
done

# King-only recover (GPUs 2,3 util=0.72 isolated TCACHE)
log "launch king_recover_pass332"
bash /root/mining_src/s4-h100-f4-genesis-base/king_recover_pass332.sh \
  >>/root/logs/h100_king_recover_pass332.nohup 2>&1
log "king_recover exit=$?"

# Wait king healthy
for i in $(seq 1 120); do
  k=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
  if [[ "$k" == "200" ]]; then
    log "king :8001=200 after poll $i"
    break
  fi
  sleep 10
done
k=$(curl -s -o /dev/null -w "%{http_code}" --max-time 3 http://127.0.0.1:8001/v1/models || true)
if [[ "$k" != "200" ]]; then
  log "ABORT king still unhealthy"
  exit 1
fi

# Chall from merged (recover264 path)
if [[ ! -d /root/h100/merged ]]; then
  log "ABORT missing /root/h100/merged"
  exit 1
fi
log "launch relaunch_chall_pass264"
bash /root/mining_src/s4-h100-f4-genesis-base/relaunch_chall_pass264.sh \
  >>/root/logs/h100_chall_recover_pass264.nohup 2>&1 &
echo $! >/root/logs/h100_chall_recover_pass264.pid
log "chall recover pid=$(cat /root/logs/h100_chall_recover_pass264.pid)"

# Clear abort so watch_n80_retry / retry can proceed once chall promptable
rm -f /root/logs/h100_n80_retry.aborted /root/logs/h100_pipeline.aborted
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h100_watch_tok_done_pass388.done
log "DONE armed (tok.done→king→chall; n80 via existing watch_n80_retry)"
EOF