# Pass 397 — F4 turns sync + frozen chall relaunch

- After diverse warm+freeze (n_so=22, triple-promptable @22:26:58Z),
  `relaunch_chall_pass264.sh` hit `line 408: il: command not found` then
  reaped the healthy chall. n80 then failed `turns.jsonl` missing.
- Synced corpus epoch=4 → 18384 lines / 702786551 bytes.
- Relaunched same frozen TCACHE
  `h100_chall_p260_a1_1786227519_63229` mode=555 n_so=22 (no wipe)
  via `relaunch_chall_frozen_p397.sh` pid=69583; chall_pid=69660 @22:29:48Z.
- Fixed d4 quoting + rearm → `retry_h100_n80_longwait.sh`.
- Next: chall:8002=200 promptable → longwait n80 samples.
