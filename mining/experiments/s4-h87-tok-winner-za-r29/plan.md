# H87 — Tok-init × winner-zA @ LoRA r=29 vs Tok (non-α)

## Claim
After H82 Tok-init@r23 REFUTE (m=−0.004388 z=−0.663), step rank to
**r=29** (≥3 from live H83–H86 r25–28; untested; ∉ dead
≤8∨16–23∨24∨≥32∨Tok-init r17/r18/r22/r23).

## Method
1. Data: H27 winner_za_high_l1.jsonl (406 ex).
2. Init: Tok331102/affine-5EqYW8McUc-af10 @ eb8bf9a…
3. Thought-only LoRA **r=29 / α32**, lr=5e-6, 1 epoch.
4. Merge → n80 vs Tok331102 @ eb8bf9a… (live king).

## Decision rule
margin > 0.04 + gates green → Stage 5 submit path.
m ∈ [0.015, 0.04] → shortlist replicate (do not blacklist).
m≤0 or gate-fail → REFUTE + tear.

## Rent note
UUID @$≥28/h, COUNT=8, `--ttl 12h`. mid304 for mid-n80 bare.
