# H73 — H67@r19 replicate vs Tok (non-α)

## Claim
H67@r19 n80 vs TalentPigs m=+0.01835 z=2.57 base×1.237 (gates OK).
Shortlist replicate same cell vs **live Tok331102**.

## Method
1. Data: H27 winner_za_high_l1.jsonl (406 ex).
2. Init: Radiant28/m7 @ f766293ee878…
3. Thought-only LoRA **r=19 / α32**, lr=5e-6, 1 epoch (identical to H67).
4. Merge → n80 vs Tok331102 @ eb8bf9a…

## Decision rule
margin > 0.04 + gates → Stage 5. m∈[0.015,0.04] → shortlist again.
m≤0 or gate-fail → REFUTE + tear.

## Rent note
UUID @$≥28/h, COUNT=8. KING=Tok from rent. p283-safe preempt.
