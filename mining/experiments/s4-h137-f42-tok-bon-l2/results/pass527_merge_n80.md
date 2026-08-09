# F42 / H137 — pass 527

## What happened
- Train finished step 150 @ 10:44:30Z (`train.done`).
- Merge LoRA → `/root/h137/merged` completed OK_NON_IDENTICAL
  (`identical_to_base=false`, `identical_to_king=false`) @ 10:52:30Z.
- Chall re-serve util=0.72 GPUs 4,5; `:8002=200` @ ~10:59Z; `n_so=24`.
- HF salvage push started: `unconst/Affine-5czsc2fc98-h137-lora` +
  `unconst/Affine-5czsc2fc98-h137-merged` (TTL insurance, not a submission).

## Fix
Misnamed `retry_h137_n80_d203first.sh` was still a203-first (H32 hazard).
Deployed `retry_h137_n80_d203first_p527.sh` (d/e/f/g/b + nested FALSE_PROBE
guard from F41 p523). Killed a203 n80 (rc=143), relaunched d203 @ 11:01:33Z.

## Live
n80 attempt 1/5 `block_hash=d203…004` vs Tok331102; engines 8000/8001/8002=200.
Next pass: read decision; m>+0.015 → CONFIRM k=4; else REFUTE + tear (no replace).
