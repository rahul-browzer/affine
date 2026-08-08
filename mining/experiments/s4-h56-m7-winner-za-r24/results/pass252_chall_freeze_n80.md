# H56 pass252 — p251 writable-w1 freeze SUCCESS → n80

**UTC:** 2026-08-08T05:58:17Z DONE_LAUNCH

**p251 a1 result (first attempt):**
- health=200 @ poll34 (~5.5 min)
- settle 60s, TCACHE king-seed left **writable** (mode=755, launcher.so=16)
- `comp a1_w1 code=200` (JIT wrote +6 hashes → 22)
- FREEZE post-w1 → mode=555
- `comp a1_w2=200` `a1_w3=200` (survive freeze)
- form pid=28490 + watch_n80_retry pid=28496 rearmed
- `h56_chall_freeze_pass251.done` written

**n80:** `run_sim_duel.py` local-h56 block-hash **a203…0001** started
pid=28622 → `/root/affine_data/h56_sim_result.json`.

**Verdict vs p247:** prefreeze-before-w1 ABORT×3; post-w1 freeze clears
on attempt 1. Recipe confirmed live.
