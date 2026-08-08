# H89 — Tok-init × winner-zA @ LoRA r=31 vs Tok (non-α)

## Claim
After H83 Tok-init@r25 REFUTE (m=+0.001012 z=0.202), step rank to
**r=31** (untested; ∉ dead ≤8∨16–24∨≥32∨Tok-init
r17/r18/r22/r23/r25/r26).

## Method
1. Data: H27 winner_za_high_l1.jsonl (406 ex).
2. Init: Tok331102/affine-5EqYW8McUc-af10 @ eb8bf9a…
3. Thought-only LoRA **r=31 / α32**, lr=5e-6, 1 epoch.
4. Merge → n80 vs Tok331102 @ eb8bf9a… (live king).

## Decision rule
margin > 0.04 + gates green → Stage 5 submit path.
m ∈ [0.015, 0.04] → shortlist replicate (do not blacklist).
m≤0 or gate-fail → REFUTE + tear.

## Rent note
UUID @$≥28/h, COUNT=8, `--ttl 12h`. mid304 for mid-n80 bare.
