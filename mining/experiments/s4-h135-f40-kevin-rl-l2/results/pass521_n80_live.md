# pass521 — F40 chall salvage → n80 live (b203)

**UTC:** 2026-08-09T10:08–10:14Z · pod `mine-f40-1` / `zesty-wolf-91`

## What happened
- Prior: FALSE_PROBE @10:08Z (`ConnectError` on a203 while chall mid-recover).
- Attempt-1 writable w1 hit Triton ENOENT on `MS7U6ENY…/__triton_launcher.so` (n_so 19→23).
- recover264 SALVAGE: same TCACHE pre-frozen mode=555 → chall health=200 @10:13:05Z.
- Salvage warmups ×3 code=200; TCACHE frozen n_so=23.
- n80 attempt1 (a203) failed teacher `400 Bad Request` → rotate.
- **n80 attempt 2/3 live** `block_hash=b203…` `run_sim_duel.py` pid=44134; eng 200/200/200.

## Decision
FALSE_PROBE ≠ REFUTE. Await n80 margin vs Tok; m>+0.015 → CONFIRM k=4.
