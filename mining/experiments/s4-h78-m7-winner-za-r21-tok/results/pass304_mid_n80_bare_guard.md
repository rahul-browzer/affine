# Pass 304 — continuous mid-n80 bare-TCACHE guard

## Why
`watch_preempt_bare_tcache_pass264` is one-shot: on isolated chall it logs
"leave alone" and exits. Pass 303 rearmed it after recover264 DONE → immediate
exit (mode=555). Mid-n80 bare flips (H61@21/80) then have no watcher.

## Action
Shipped `watch_mid_n80_bare_tcache_pass304.sh` (argv: H EXP): loops while
`run_sim_duel … local-hN` alive; if :8002=200 and chall `TRITON_CACHE_DIR` is
missing or `/root/.triton/cache/chall`, fire `relaunch_chall_pass264` once
(skip if recover already alive).

## Deployed (pids)
| pod | mid304 pid | note |
|---|---|---|
| mine-h76-1 | 29028 | sim alive → watch loop; n80 a203 chall 7/80 @12:38Z |
| mine-h77-1 | 24310 | waiting sim; king302 PROMPTABLE @12:38:16Z poll=43 |
| mine-h78-1 | 22954 | sim alive → watch loop; n80 a203 chall 13 / king 12 @12:38Z |
| mine-h79-1 | 11741 | waiting sim; merge_lora live |
| mine-h80-1 | 9499 | waiting sim; train_lora live |

No rent/rm. King still Tok331102 S=0.04456.
