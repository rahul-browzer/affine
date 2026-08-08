# H74 pass 292 — stale n80-retry wait refresh

## Facts
- Train finished ckpt-26 (epoch 1.0). Merge DONE 11:05:49Z; OK_NON_IDENTICAL vs m7 + Tok331102.
- Chall relaunch 11:06:26Z on bare `/root/.triton/cache/chall` GPUs 4,5 util 0.72; still mid torch.compile @11:10 (port 8002 down).
- Teacher :8000 + king Tok :8001 health 200 throughout.
- `retry_h74_n80.sh` pid=912 had been waiting since 10:43 (before merge) → poll **104/120** while chall not yet listening.

## Action
- Killed retry PID 912 only (not watcher 880). Watcher relaunched retry at 11:10:47Z → **poll=0/120**.
- Pod note: `/root/affine_data/h74_pass292_retry_refresh.json`.

## Expected next
- Chall → health200; preempt264 should see bare TCACHE and fire recover264 (isolated warm+freeze) before n80.
- Fresh retry budget can absorb recover; do not tear pod.
