#!/usr/bin/env bash
# If r2_premerge.done lacks max_abs_delta, rewrite from merge_alpha_meta.json.
set -euo pipefail
DONE=/root/logs/r2_premerge.done
META=/root/r2_out/alpha_tok_talent_kevin/merge_alpha_meta.json
LOG=/root/logs/r2_premerge_stamp_fix.log
exec >>"$LOG" 2>&1
echo "[stamp-fix] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
for i in $(seq 1 720); do
  if [[ -f "$DONE" ]]; then
    if grep -q max_abs_delta "$DONE" 2>/dev/null; then
      echo "[stamp-fix] stamp_ok $(cat "$DONE")"
      exit 0
    fi
    if [[ -f "$META" ]]; then
      line=$(python3 - <<'PY'
import json
from pathlib import Path
from datetime import datetime, timezone
d=json.loads(Path("/root/r2_out/alpha_tok_talent_kevin/merge_alpha_meta.json").read_text())
ts=datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
print(f"OK {ts} max_abs_delta={d.get('max_abs_delta')} n_keys={d.get('n_keys')}")
PY
)
      echo "$line" | tee "$DONE"
      echo "[stamp-fix] rewrote_stamp"
      exit 0
    fi
    echo "[stamp-fix] done_without_meta iter=$i"
  fi
  sleep 10
done
echo "[stamp-fix] TIMEOUT"
exit 2
