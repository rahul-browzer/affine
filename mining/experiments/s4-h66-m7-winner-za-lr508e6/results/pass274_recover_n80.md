# H66 pass274 — recover264 salvage → n80

## Before
- Engines :8000/:8001/:8002=200 but **no** `run_sim_duel` / `watch_n80_retry`.
- recover264 alive mid-warmup; n80-retry died @09:05 after bare-chall preempt.

## Attempt 1 writable warm
- health=200 @09:11:18; settle 60s; diverse w1 @09:12:19.
- Worker_TP1 `ImportError` ghost `__triton_launcher.so` under isolated TCACHE
  `…/74NSHKWV…` @09:12:20; w1 `TimeoutError` @09:15:19; n_so **16→22**.

## Salvage (script path)
- Prefreeze grown TCACHE mode=555; relaunch same TCACHE chall_pid=25117.
- health=200 @09:19:58; salvage w1/w2/w3 all **200**; triple-promptable.
- FREEZE_DONE `h66_chall_freeze_pass264.done` n_so=22 mode=555.
- Rearmed form+watch_n80_retry @09:21:13.

## n80
- Engines double-promptable @09:21:34; attempt 1/3 `block_hash=a203…`.
- SIM_UP pid=27342; progress @09:25: challenger 5/80, king 1/80.

## Decision
Do not tear down. Wait `decision.json`. Salvage-after-ghost-ENOENT works when n_so grew.
