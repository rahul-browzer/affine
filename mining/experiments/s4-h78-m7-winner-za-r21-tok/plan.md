# H78 — m7×winner-zA @ LoRA r=21 vs Tok (non-α)

## Claim
Rank axis step ≥3 from r18. H72@r18 m=-0.009 vs Tok; r=16/19/20 dead. r=21 untested vs Tok (capacity between shortlist and band-fail ranks).

## Method
1. Data: H27 winner_za_high_l1.jsonl (406 ex).
2. Init: Radiant28/5eqdtdzqle-ckpt1000-m7 @ f766293ee878…
3. Thought-only LoRA **r=21 / α32**, lr=5e-6, 1 epoch.
4. Merge → n80 vs Tok331102 @ eb8bf9a… (live king S=0.04456).

## Decision rule
margin > 0.04 + gates green → Stage 5 submit path.
m ∈ [0.015, 0.04] → shortlist replicate (do not blacklist).
m≤0 or gate-fail → REFUTE + tear.

## Rent note
Patch SOFT/DEADMAN `:-` to ≥TTL−1h. UUID @$≥28/h, COUNT=8.
KING=Tok from rent. Use p283-safe preempt (isolated TCACHE → leave alone).
