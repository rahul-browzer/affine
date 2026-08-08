# H92 — Tok-init × winner-zA @ LoRA r=13 vs Tok (non-α)

## Claim
Tok-init r22–r29 flat/near-null (best H81@r22 m=+0.008811;
H87@r29 m=+0.005075 REFUTE). Step **≥8 from r22** to untested **r=13**
(∉ dead ≤8∨16–24∨≥32∨Tok-init r17/r18/r22–r23/r25–r29;
∉ live H88–H91 r30–31+r14+r12). Between H91@r12 and H90@r14.

## Method
1. Data: H27 winner_za_high_l1.jsonl (406 ex).
2. Init: Tok331102/affine-5EqYW8McUc-af10 @ eb8bf9a…
3. Thought-only LoRA **r=13 / α32**, lr=5e-6, 1 epoch.
4. Merge → n80 vs Tok331102 @ eb8bf9a… (live king).

## Decision rule
margin > 0.04 + gates green → Stage 5 submit path.
m ∈ [0.015, 0.04] → shortlist replicate (do not blacklist).
m≤0 or gate-fail → REFUTE + tear.

## Rent note
UUID @$≥28/h, COUNT=8, `--ttl 12h`. mid304 for mid-n80 bare.
