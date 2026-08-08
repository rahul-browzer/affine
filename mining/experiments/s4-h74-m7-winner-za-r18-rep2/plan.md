# H74 — H64@r18 replicate #2 vs Tok (non-α)

## Claim
H64@r18 best n80 m=+0.02509. H72 is first redraw; H74 is a second
independent redraw of the same cell vs live Tok331102 (SE≈0.0084 ⇒ need
≥2 draws near the bar).

## Method
1. Data: H27 winner_za_high_l1.jsonl (406 ex).
2. Init: Radiant28/5eqdtdzqle-ckpt1000-m7 @ f766293ee878…
3. Thought-only LoRA **r=18 / α32**, lr=5e-6, 1 epoch (identical to H64/H72).
4. Merge → n80 vs Tok331102 @ eb8bf9a… (live king S=0.04456).

## Decision rule
margin > 0.04 + gates green → Stage 5 submit path.
m ∈ [0.015, 0.04] → shortlist another replicate (do not blacklist r=18).
m≤0 or gate-fail → REFUTE + tear.

## Rent note
Patch SOFT/DEADMAN `:-` to ≥TTL−1h. UUID @$≥28/h, COUNT=8.
KING=Tok from rent. Use p283-safe preempt (isolated TCACHE → leave alone).
