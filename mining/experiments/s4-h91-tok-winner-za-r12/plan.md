# H91 — Tok-init × winner-zA @ LoRA r=12 vs Tok (non-α)

## Claim
Tok-init r22–r28 flat/near-null (best H81@r22 m=+0.008811;
H86@r28 m=−0.000341). Step **≥8 from r22** to untested **r=12**
(∉ dead ≤8∨16–24∨≥32∨Tok-init r17/r18/r22–r23/r25–r28;
∉ live H87–H90 r29–31+r14). Adjacent to H90@r14 — basin probe,
not a 1% micro-step.

## Method
1. Data: H27 winner_za_high_l1.jsonl (406 ex).
2. Init: Tok331102/affine-5EqYW8McUc-af10 @ eb8bf9a…
3. Thought-only LoRA **r=12 / α32**, lr=5e-6, 1 epoch.
4. Merge → n80 vs Tok331102 @ eb8bf9a… (live king).

## Decision rule
margin > 0.04 + gates green → Stage 5 submit path.
m ∈ [0.015, 0.04] → shortlist replicate (do not blacklist).
m≤0 or gate-fail → REFUTE + tear.

## Rent note
UUID @$≥28/h, COUNT=8, `--ttl 12h`. mid304 for mid-n80 bare.
