# H64 pass264 — preempt bare TCACHE before n80

## Why
Same as H63: avoid bare-cache n80 (H61/H62 failure mode).

## Action (2026-08-08T07:42Z)
- Cloned recover → `relaunch_chall_pass264.sh` (EXP=`s4-h64-m7-winner-za-r18`).
- Uploaded + launched `watch_preempt_bare_tcache_pass264.sh` pid=11151.
- At arm: train.done → merge LoRA loading base on GPUs 6,7; chall down.

## Expect
post_train → restart_for_h2 bare chall → watcher fires recover264 →
isolated TCACHE + diverse warmups + freeze n_so≥16 → rearm retry_h64_n80.
