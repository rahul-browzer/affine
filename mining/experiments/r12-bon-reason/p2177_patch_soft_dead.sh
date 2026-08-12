#!/usr/bin/env bash
# p2177: Soft/Dead were past pod Removal (20:57Z). Set TTL−1h / TTL−30m;
# relaunch post_train waiter only (BoN train stays).
set -euo pipefail

SOFT=2026-08-12T19:57:47Z
DEAD=2026-08-12T20:27:47Z
REMOVE=2026-08-12T20:57:47Z
echo "[p2177] patch Soft=$SOFT Dead=$DEAD remove=$REMOVE"

python3 - <<PY
from pathlib import Path
import re
p = Path("/root/mine.env")
text = p.read_text()
for k, v in {
    "SOFT_DEADLINE_UTC": "$SOFT",
    "DEADMAN_UTC": "$DEAD",
}.items():
    pat = rf"(?m)^export {k}=.*$"
    rep = f"export {k}={v}"
    if re.search(pat, text):
        text = re.sub(pat, rep, text)
    else:
        if not text.endswith("\n"):
            text += "\n"
        text += rep + "\n"
p.write_text(text)
print("mine.env Soft/Dead/King:")
for line in p.read_text().splitlines():
    if any(x in line for x in ("SOFT", "DEAD", "KING_REPO")):
        print(" ", line)
PY

PIPE=/root/mining_src/s4-h137-f42-tok-bon-l2/post_train_pipeline.sh
python3 - <<PY
from pathlib import Path
import re
p = Path("$PIPE")
text = p.read_text()
soft = "$SOFT"
dead = "$DEAD"
text2, n1 = re.subn(
    r"SOFT_DEADLINE_UTC=\$\{SOFT_DEADLINE_UTC:-[^}]+\}",
    f"SOFT_DEADLINE_UTC=\${{SOFT_DEADLINE_UTC:-{soft}}}",
    text,
    count=1,
)
text3, n2 = re.subn(
    r"DEADMAN_UTC=\$\{DEADMAN_UTC:-[^}]+\}",
    f"DEADMAN_UTC=\${{DEADMAN_UTC:-{dead}}}",
    text2,
    count=1,
)
Path(str(p) + ".new").write_text(text3)
print("deadline_patch soft", n1, "dead", n2, soft, dead)
for line in text3.splitlines():
    if "SOFT_DEADLINE" in line or "DEADMAN_UTC=" in line:
        print(" ", line)
PY
mv -f "$PIPE.new" "$PIPE"
chmod +x "$PIPE"

POST_PIDF=/root/logs/r12_post_train.pid
if [[ -f "$POST_PIDF" ]]; then
  pid=$(cat "$POST_PIDF")
  if kill -0 "$pid" 2>/dev/null; then
    echo "[p2177] killing post_train pid=$pid"
    kill "$pid" || true
    sleep 2
    if kill -0 "$pid" 2>/dev/null; then
      kill -9 "$pid" || true
    fi
  fi
fi

TRAIN_PID=$(cat /root/logs/h137_train.pid)
kill -0 "$TRAIN_PID"
echo "[p2177] train still alive pid=$TRAIN_PID"

set -a
# shellcheck disable=SC1091
source /root/mine.env
set +a
export SOFT_DEADLINE_UTC="$SOFT"
export DEADMAN_UTC="$DEAD"
nohup bash /root/mining_src/s4-h137-f42-tok-bon-l2/post_train_pipeline.sh \
  >>/root/logs/r12_post_train.nohup 2>&1 &
echo $! | tee /root/logs/r12_post_train.pid
sleep 2
kill -0 "$(cat /root/logs/r12_post_train.pid)"
echo "[p2177] post_train relaunched Soft=$SOFT_DEADLINE_UTC Dead=$DEADMAN_UTC"
tr "\0" "\n" <"/proc/$(cat /root/logs/r12_post_train.pid)/environ" \
  | grep -E "SOFT|DEAD|KING_REPO" | sort
tail -8 /root/logs/r12_post_train.nohup
tail -2 /root/logs/h137_train.nohup
echo "R12_SOFT_DEAD_PATCH_OK $(date -u +%Y-%m-%dT%H:%M:%SZ)"
