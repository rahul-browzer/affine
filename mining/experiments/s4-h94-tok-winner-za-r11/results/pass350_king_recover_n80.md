# H94 pass350 — king Triton ENOENT → re-fire → n80+mid304

## What happened
- Prior recover332 (p349) aborted @18:26:43Z: `ABORT early: Triton launcher ENOENT`
  hash `WGUL55MZARPIFIN3…/__triton_launcher.so` during load-time GDN warmup.
- Retry burned mid-retry wait 40 → `aborted_engines_unhealthy` @18:28:14Z;
  watcher relaunched retry (poll 0/120).
- GPUs 2,3 free; chall :8002 + teacher :8000 stayed 200.

## Action
1. Kill retry (no completions-probe during recover settle).
2. Wipe `/root/.triton/isolated/h94_king_p332_*` + bare `cache/king*`.
3. Re-fire `king_recover_pass332.sh` → TCACHE
   `/root/.triton/isolated/h94_king_p332_1786213733_26826` util=0.72.
4. **KING PROMPTABLE** @18:35:53Z poll=40.
5. Retry engines double-promptable → n80 attempt1 block_hash=a203 @18:36:13Z.
6. `bash /root/logs/arm_mid304_h94.sh` → mid304 pid=30462 watching sim.

## Leave state
n80+mid304 live. form+watch_n80 armed. Chall untouched.
