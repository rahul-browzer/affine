# H95 pass358 — mid304 armed; bare chall TCACHE → recover264

## Facts @19:23Z
- n80 a203 live 26/80; engines t/k/c=200/200/200.
- mid304 **not** running (form+watch_n80 only).
- chall PID 17989 `TRITON_CACHE_DIR=/root/.triton/cache/chall` (bare).

## Action
- Wrote `/root/logs/arm_mid304_h95.sh`; armed mid304 pid=22507 @19:24:28Z.
- mid304 immediately saw bare TCACHE → launched recover264 pid=22543.
- recover quarantined progress, killed sim 21312 + watch_n80 958, wiped GPUs 4,5.
- attempt1: seed from bare king TCACHE (launcher.so=23; king also bare),
  launch chall util=0.72 isolated
  `TCACHE=/root/.triton/isolated/h95_chall_p260_a1_1786217108_22543`.
- @19:26:09Z :8002 still loading (GPUs4,5 ~2.1 GiB); recover waiting health.

## Next
- Await recover DONE (:8002=200 + freeze) → auto-rearm form+n80.
- Then `bash /root/logs/arm_mid304_h95.sh` again (mid304 exited on sim gone).
- King still on bare `/root/.triton/cache/king` — leave unless EngineDead.
