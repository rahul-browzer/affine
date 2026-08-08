# Pass 283 — H70 preempt double-recover race

## Incident
recover264 pid14467 reached chall health=200 @ 10:14:48Z (settle 60s
before writable w1). Simultaneously watch_preempt saw isolated TCACHE
mode=755 n_so=16 and treated “not frozen enough” as a launch condition →
second recover pid17064 @ 10:14:49Z. Second recover truncated the log,
reaped GPUs 4/5, killed the healthy APIServer mid-settle.

## Fix
1. Killed orphan recover 14467; left 17064 (relaunched chall_pid=17319).
2. Patched `watch_preempt_bare_tcache_pass264.sh`: if recover already
   alive → exit; if TCACHE already under `/root/.triton/isolated/*` →
   leave alone (mode=755 mid-warmup is expected). Only bare/non-isolated
   launches recover.
3. Retarget279 pid11353 still waiting on `h70_chall_serve.done`.

## Next
chall warm+freeze → chall_serve.done → Tok :8001 swap → n80 vs Tok.
