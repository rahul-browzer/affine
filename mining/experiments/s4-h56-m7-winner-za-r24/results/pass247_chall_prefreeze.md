# H56 pass247 — chall Triton recover (prefreeze)

Merge present; first chall serve died @05:07:58Z on warmup:
`__triton_launcher.so` ENOENT under `/root/.triton/cache/chall/...`.
`restart_for_h2.sh`/`wait_ready` stuck ~1400s with GPUs 4–5 empty;
n80-retry abort/re-poll with c=0.

Launched `relaunch_chall_pass247.sh` (H54 p246 recipe: wipe + king-seed +
pre-freeze before w1 + outer×3) @2026-08-08T05:26:15Z pid=19702.
Killed leftover wait_ready/restart/watch_n80_retry before relaunch.

Teacher/king left up (:8000/:8001=200). Next: wait
`h56_chall_freeze_pass247.done` → n80.
