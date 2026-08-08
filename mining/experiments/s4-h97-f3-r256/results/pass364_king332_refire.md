# Pass 364 — F3 king332 re-fire

**When:** 2026-08-08T19:50:41Z
**Pod:** mine-f3-1 (noble-raven-ff)

## Symptom
- Engines at poll: T200 **K000** C200; GPUs 2,3 empty; no `run_sim_duel`.
- `vllm_king.log` @19:47:23Z: Triton ENOENT on bare
  `/root/.triton/cache/king/74NSHKWV…/__triton_launcher.so` → EngineDead → APIServer exit.
- n80 attempt 1 failed `httpx.ConnectError`; `watch_n80_retry` stuck poll waiting health200.
- mid304 exited `sim gone` @19:47:56Z (fired=0). No `h97_sim_progress.json`.

## Action
- Fired `king_recover_pass332.sh` nohup (pid 22327 → king vllm 22425).
- Isolated TCACHE `/root/.triton/isolated/h97_king_p332_1786218644_22327`, util=0.72, GPUs 2,3.
- Cleared stale sim progress/result/decision; left teacher+chall alone.
- Poll@19:51:09Z: serve started; GPUs 2,3 beginning load. Await `:8001` promptable + `h97_king_recover_pass332.done`.

## Next
1. Await king promptable → retry_h97_n80 should auto-resume.
2. Rearm `watch_mid_n80_bare_tcache_pass304.sh` once sim alive (mid304 exited).
3. Do not touch chall (recover264 already frozen n_so=22).
