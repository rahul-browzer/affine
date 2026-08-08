# Pass 349 — H94 king OOM → king-only recover332

## Symptom
- After p348 n80+mid304: king `:8001` died @18:17:47Z.
- `torch.OutOfMemoryError` allocate 7.57 GiB / 6.69 free (util headroom).
- Teacher `:8000=200`, chall `:8002=200` isolated
  (`…/h94_chall_p260_a1_1786212543_19076`).
- mid304 exited `sim gone` @18:18:15Z; retry waiting engines poll≥12/40.

## Action
- GPUs 2,3 free (0 MiB). Left chall alone.
- Launched `king_recover_pass332.sh` (util=0.72 isolated) pid=23321
  @18:20:53Z → TCACHE=`/root/.triton/isolated/h94_king_p332_1786213256_23321`
  king serve pid=23424 @18:21:21Z.
- Wrote `/root/logs/arm_mid304_h94.sh` for rearm after n80 resumes.

## Next
Await king PROMPTABLE → retry n80 a203 → `bash /root/logs/arm_mid304_h94.sh`.
