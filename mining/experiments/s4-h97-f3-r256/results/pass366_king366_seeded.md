# Pass 366 — F3 king366 seeded re-fire

**When:** 2026-08-08T19:58:14Z
**Pod:** mine-f3-1 (noble-raven-ff)

## Symptom
- p332 cold-JIT ABORT @19:54:31Z: Triton launcher ENOENT (poll=21),
  TCACHE had NODUTTS4/FHFMBKEV ghosts; GPUs 2,3 empty; T200 K000 C200.
- No `run_sim_duel`; watch_n80_retry + form still armed; mid304 previously exited.

## Action
1. Packed H95 live king TCACHE (`/root/.triton/cache/king`, n_so=23, ghosts=0)
   → 12 MiB tar via this host (deleted same pass) → F3 `/tmp/king_tcache_seed_p366.tar.gz`.
2. Wrote+launched `king_recover_pass366.sh` (pid 24951 → vllm 25078):
   - wipe bare + failed p332 isolated
   - seed isolated `/root/.triton/isolated/h97_king_p366_1786219096_24951` n_so=23
   - util=0.72 GPUs 2,3; leave teacher+chall alone
   - freeze TCACHE after promptable; write `h97_king_recover_pass366.done`
3. @20:00:48Z: health still 000 but workers loading shards (GPU2/3 ≈36 GiB;
   "Loading safetensors… 0/2") — past prior abort point.

## Next
1. Await `h97_king_recover_pass366.done` + `:8001` promptable → n80 auto-resume.
2. Rearm mid304 once `run_sim_duel` alive.
3. Do not touch chall (frozen n_so=22).
