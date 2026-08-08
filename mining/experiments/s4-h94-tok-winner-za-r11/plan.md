# H94 — Tok-init × winner-zA @ LoRA r=11 vs Tok (non-α)

## Claim
After H88@r30 REFUTE (m=+0.001358), fill free slot with untested **r=11**
(∉ dead ≤8∨16–24∨≥32∨Tok-init r17/r18/r22–r23/r25–r31;
∉ live H90–H93 r14/r12/r13/r15). Between dead ≤8 and live r12.

## Method
1. Data: H27 winner_za_high_l1.jsonl (406 ex).
2. Init: Tok331102/affine-5EqYW8McUc-af10 @ eb8bf9a…
3. Thought-only LoRA **r=11 / α32**, lr=5e-6, 1 epoch.
4. Merge → n80 vs Tok331102 @ eb8bf9a… (live king).

## Decision rule
margin > 0.04 + gates green → Stage 5 submit path.
m ∈ [0.015, 0.04] → shortlist replicate (do not blacklist).
m≤0 or gate-fail → REFUTE + tear. m≈0 (0–0.015) → REFUTE (below shortlist).

## Rent note
UUID @$≥28/h, COUNT=8, `--ttl 12h`. mid304 for mid-n80 bare.
