# H103/F8 pass402 — chall recover264

## Problem
Chall served @22:42 (`h103_chall_serve.done`) but never passed longwait
completions probe. Died @22:47: `TimeoutError: RPC call to sample_tokens
timed out` → `EngineDeadError`. GPUs 4–5 empty; longwait poll~60/360 stuck
on `:8002=000`. Stale `h103_sim_n80.done` / `pipeline.done` from post_train
skip-path (margin=?).

## Action
- Cleared false `sim_n80.done` + `pipeline.done`.
- nohup `relaunch_chall_pass264.sh` pid=32955 → chall_pid=33211
  TCACHE=`h103_chall_p260_a1_1786229674_32955` seeded from king332
  (19 launcher.so), util=0.72, CUDA_HOME via script.
- Rearmed `watch_preempt_bare_tcache_pass264` pid=32989.
- Left longwait watcher+retry intact (poll continues).

## State left
Chall loading; await health200 → diverse-warm → freeze → longwait n80.
