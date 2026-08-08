# H102/F7 pass386 — salvage 555 hang → unfreeze

## Prior
- a1 hit health=200 @21:35:42, settle+writable warm started.
- n80 raced during settle → FALSE_PROBE (chall completions 400 =
  `prompt≥30977 + max_tokens=1792 > 32768`; known H32 slice).
- Warmup itself then died (`comp a1_d1 code=000`); n_so 0→22.
- recover SALVAGE relaunched same TCACHE **pre-frozen mode=555**
  (also froze torchinductor twin) chall_pid=25332 @21:39:50.

## Hang
- APIServer alive, log stuck after transformers deprecation, **no
  EngineCore**, GPUs 4/5 = 4 MiB for >60s.
- Cause: inductor/Triton needed a write under mode=555.

## Fix
- `chmod 755` (dirs) / `644` (files) on
  `…/h102_chall_p260_a1_…` **and**
  `~/.cache/torchinductor_h102_chall_p260_a1_…`.
- Within ~24s: EngineCore spawned, workers up, GPUs → 36 GiB load.

## Next
Await salvage :8002=200 → short promptable×2 → n80 retry (block_hash
rotates a203→b203; FALSE_PROBE already quarantined by retry script).
