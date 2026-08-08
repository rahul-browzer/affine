# H58 pass253 — chall recover (default chall cache ENOENT)

## Symptom
- merge.done → chall :8002 health=200; retry double-promptable @06:00:35Z
  → n80 a203 started.
- ~9s later EngineDead: ENOENT
  `/root/.triton/cache/chall/OV4T43AL…/__triton_launcher…so`
  (default role cache — **not** isolated+freeze). Same hash as H56 p251→n80.
- :8002 down; orphan workers on GPUs 4–5 reaped by recover.

## Action
- Quarantine artifact. Kill dying n80/retry.
- Launch `relaunch_chall_pass253.sh`: king-seed WRITABLE + diverse warmups
  → freeze → w2/w3 → rearm watcher/form → n80.

## Decision rule
- Recover OK → n80; m>0.04 submit else REFUTE. Never tear down on
  FALSE_PROBE.
