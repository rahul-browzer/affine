# H51 pass241 — chall pre-freeze recover (4th)

UTC 2026-08-08T04:15:59Z p240 a1: health=200 after 45s settle,
`n_pre=16` launcher.so, warmup#1 → **500** in 4s.
Root cause: `RuntimeError: …/__triton_launcher….so: No such file or directory`
(same TP race-delete as p229/p239; settle alone insufficient).

Action: killed doomed p240 a2 mid-load; launched
`relaunch_chall_pass241.sh` pid=**33262** @04:20:37Z.
Upgrades vs p240: (1) seed TCACHE from live king cache (16 .so);
(2) **PRE-FREEZE** `chmod -R a-w` before w1 when n_pre≥1;
(3) outer×3 kept. a1 chall_pid=**33332** @04:21:18Z,
TCACHE=`…/h51_chall_p241_a1_1786162871_33262`.

Log: `/root/logs/h51_chall_recover_pass241.log`.
Next: poll `h51_chall_freeze_pass241.done` → n80 → decision.
Do **not** `lium rm`. FALSE_PROBE ≠ REFUTE.
