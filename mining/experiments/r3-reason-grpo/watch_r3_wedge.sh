#!/usr/bin/env bash
# Host watchdog: relaunch R3 GRPO only on a real teacher-socket wedge.
# Criteria (all must hold): train pid alive, log age > STALE_S, at least one
# CLOSE-WAIT to :8000, zero ESTAB to :8000. Never touches non-mine pods.
# Kill by PID only (never pkill -f).
set -euo pipefail

ROOT=/home/const/subnet120
EXP="$ROOT/mining/experiments/r3-reason-grpo"
LOG="$EXP/logs/watch_r3_wedge.log"
PIDF="$EXP/logs/watch_r3_wedge.pid"
REPORT="$EXP/logs/watch_r3_wedge_last.json"
SSH_HOST=${SSH_HOST:-204.9.206.245}
SSH_PORT=${SSH_PORT:-40051}
POLL_S=${POLL_S:-60}
STALE_S=${STALE_S:-600}
MAX_ITERS=${MAX_ITERS:-720}
PASS=${PASS:-2071}

mkdir -p "$EXP/logs" "$EXP/artifacts"
echo $$ >"$PIDF"
exec >>"$LOG" 2>&1

log() { echo "[r3-wedge] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

ssh_cmd() {
  ssh -o StrictHostKeyChecking=accept-new -o ConnectTimeout=20 \
    -o BatchMode=yes -p "$SSH_PORT" "root@$SSH_HOST" "$@"
}

log "start poll=${POLL_S}s stale=${STALE_S}s max_iters=$MAX_ITERS pass=$PASS host=$SSH_HOST:$SSH_PORT"

for ((i=1; i<=MAX_ITERS; i++)); do
  set +e
  ssh_cmd 'python3 - <<'"'"'PY'"'"'
import json, subprocess, time
from pathlib import Path

def sh(cmd):
    try:
        return subprocess.check_output(cmd, shell=True, text=True, timeout=20)
    except Exception as e:
        return f"ERR:{e}"

pid_path = Path("/root/logs/r3_train.pid")
pid = int(pid_path.read_text().strip()) if pid_path.is_file() else None
alive = bool(pid and Path(f"/proc/{pid}").exists())
logp = Path("/root/logs/r3_train.nohup")
age = (time.time() - logp.stat().st_mtime) if logp.is_file() else None
ss = sh("ss -tn \"( dport = :8000 or sport = :8000 )\" 2>/dev/null || true")
estab = sum(1 for line in ss.splitlines() if "ESTAB" in line)
cwait = sum(1 for line in ss.splitlines() if "CLOSE-WAIT" in line)
done = Path("/root/r3/train/train.done").is_file()
last = ""
if logp.is_file():
    for line in reversed(logp.read_text(errors="replace").splitlines()):
        if "[r3-log]" in line or "[r3-hb]" in line or "[r3] DONE" in line:
            last = line[:220]
            break
print(json.dumps({
    "alive": alive, "pid": pid, "age_s": None if age is None else round(age),
    "estab": estab, "close_wait": cwait, "train_done": done, "last": last,
}))
PY
' >"$REPORT"
  rc=$?
  set -e
  if (( rc != 0 )) || [[ ! -s "$REPORT" ]]; then
    log "iter=$i ssh_fail rc=$rc"
    sleep "$POLL_S"
    continue
  fi
  log "iter=$i $(tr -d '\n' <"$REPORT")"

  set +e
  verdict=$(STALE_S="$STALE_S" REPORT="$REPORT" python3 - <<'PY'
import json, os, sys
from pathlib import Path
rep = json.loads(Path(os.environ["REPORT"]).read_text())
stale = int(os.environ["STALE_S"])
if rep.get("train_done"):
    print("TRAIN_DONE"); sys.exit(0)
if not rep.get("alive"):
    print("DEAD"); sys.exit(2)
age = rep.get("age_s")
if age is None or age < stale:
    print("OK_FRESH"); sys.exit(0)
if int(rep.get("estab") or 0) > 0:
    print("OK_ESTAB"); sys.exit(0)
if int(rep.get("close_wait") or 0) < 1:
    print("OK_NO_CWAIT"); sys.exit(0)
print("WEDGE"); sys.exit(3)
PY
)
  code=$?
  set -e
  case "$code" in
    0)
      if [[ "$verdict" == "TRAIN_DONE" ]]; then
        log "train.done present — exit"
        exit 0
      fi
      sleep "$POLL_S"
      continue
      ;;
    2)
      log "iter=$i train pid dead — relaunch start_r3.sh"
      ;;
    3)
      log "iter=$i WEDGE (stale+CLOSE-WAIT+no ESTAB) — kill+relaunch"
      old_pid=$(python3 -c 'import json,sys; from pathlib import Path; print(json.loads(Path(sys.argv[1]).read_text()).get("pid") or "")' "$REPORT")
      if [[ -n "$old_pid" ]]; then
        ssh_cmd "kill $old_pid 2>/dev/null || true; sleep 2; kill -9 $old_pid 2>/dev/null || true" || true
      fi
      ;;
    *)
      sleep "$POLL_S"
      continue
      ;;
  esac

  scp -o StrictHostKeyChecking=accept-new -o ConnectTimeout=20 -P "$SSH_PORT" \
    "$EXP/train_reason_grpo.py" "root@$SSH_HOST:/root/mining_src/r3-reason-grpo/train_reason_grpo.py" \
    || log "scp trainer failed (will use pod copy)"
  ssh_cmd 'bash /root/mining_src/r3-reason-grpo/start_r3.sh' || log "relaunch failed"
  new_pid=$(ssh_cmd 'cat /root/logs/r3_train.pid' || echo "?")
  log "relaunched new_pid=$new_pid"
  REPORT="$REPORT" NEW_PID="$new_pid" PASS="$PASS" EXP="$EXP" python3 - <<'PY'
import json, os, time
from pathlib import Path
rep = json.loads(Path(os.environ["REPORT"]).read_text())
out = Path(os.environ["EXP"]) / "artifacts" / f"p{os.environ['PASS']}_wedge_relaunch.json"
out.write_text(json.dumps({
    "pass": int(os.environ["PASS"]),
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "report": rep,
    "new_pid": os.environ.get("NEW_PID", "").strip(),
}, indent=2) + "\n")
PY
  sleep "$POLL_S"
done
log "max_iters reached — exit"
