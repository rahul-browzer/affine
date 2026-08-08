# H51 pass242 — pre-freeze SUCCEEDED → n80 live

UTC 2026-08-08T04:27:58Z `h51_chall_freeze_pass241.done`:
`TCACHE=…/h51_chall_p241_a1_1786162871_33262 mode=555 probe=200
attempts_ok prefreeze=1 king_seed=1`

Timeline (a1):
- 04:21:11Z seed TCACHE from king (launcher.so=16)
- 04:21:18Z chall_pid=33332 util=0.72
- 04:26:40Z health=200 @ poll=33; settle 45s
- 04:27:26Z PRE-FREEZE before w1 (n_pre=16 → mode=555)
- 04:27:31Z a1_w1 **200** (p240 failed here ENOENT); frozen .so=22
- 04:27:37Z a1_w2 200; 04:27:57Z a1_w3 200 → triple-promptable
- 04:27:58Z rearm form=35234 watcher=35240; n80
  `run_sim_duel.py` pid=35373 block-hash a203…

**Verdict on method:** king-seed + pre-freeze before w1 closed the
TP race that killed p240 a1_w1. Do not tear down; wait n80 decision.

Next: poll progress → `h51_decision.json`.
