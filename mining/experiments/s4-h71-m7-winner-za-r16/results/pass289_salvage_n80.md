# H71 pass289 — salvage after writable-w1 ghost → n80 vs Tok

UTC 2026-08-08T10:45–10:52Z on mine-h71-1 (eager-fox-be).

## Before
- recover264 mid diverse-warm; Worker_TP1 ghost ImportError
  `…/6YKNXZRS…/__triton_launcher….so` @10:42:45Z; w1 TimeoutError @10:45:41Z.
- n_so **16→22**; TCACHE still writable then script frozen mode=555.
- Teacher :8000 + Tok king :8001 stayed 200; chall hung (shm_broadcast).

## Salvage (script path, confirmed)
- Prefreeze grown TCACHE mode=555; relaunch same TCACHE chall_pid=19474.
- health=200 @10:50:30 poll=29; settle 45s.
- salvage w1/w2/w3 all **200**; triple-promptable; FREEZE_DONE n_so=22 mode=555.
- Rearmed form+watch_n80_retry @10:51:44Z.

## n80
- Engines double-promptable @10:52:04; attempt 1/3 `block_hash=a203…`.
- SIM_UP pid=21916 vs Tok331102@eb8bf9a; local `/root/h71/merged`.

## Decision
Do not tear down. Wait `h71_decision.json`. Salvage-after-ghost matches H66 p274.
