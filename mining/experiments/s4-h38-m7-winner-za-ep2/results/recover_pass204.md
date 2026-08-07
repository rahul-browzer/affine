# H38 recover pass204 — chall Triton init fail

## What happened
- post_train was racing patched retry (killed this pass).
- Chall weight load reached 100%, then EngineCore init failed:
  `__triton_launcher.so` missing under `/root/.triton/cache/chall/…`.
- GPUs 4,5 free; teacher+king healthy; watcher still armed.

## Actions (pass204)
1. Killed `post_train_pipeline` / `restart_for_h2` / `wait_ready`
   so only patched retry owns n80.
2. Patched `retry_h38_n80.sh` with completions probe gate.
3. Synced `write_merge_decision.py` FALSE_PROBE guard.
4. Relaunched chall via `relaunch_chall_pass204.sh`
   (wipe→settle→unique TCACHE `chall_p204_*`).

## Decision
H38 still **open**. Next: chall promptable → a203 n80.
