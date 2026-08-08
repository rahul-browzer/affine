# H79 — Tok-init × winner-zA @ LoRA r=18 vs Tok (non-α)

## Claim
H72+H74 both m≤0 on m7×winner-zA@r18 vs Tok. New **init axis**: same data/hyps
(H64 cell) but train from live king Tok331102 instead of m7.

## Method
1. Data: H27 winner_za_high_l1.jsonl (406 ex).
2. Init: Tok331102/affine-5EqYW8McUc-af10 @ eb8bf9a… (also the duel king).
3. Thought-only LoRA **r=18 / α32**, lr=5e-6, 1 epoch.
4. Merge must be non-identical to Tok (LoRA Δ). n80 vs Tok @ eb8bf9a….

## Decision rule
margin > 0.04 + gates green → Stage 5 submit path.
m ∈ [0.015, 0.04] → shortlist replicate (do not blacklist).
m≤0 or gate-fail → REFUTE + tear.

## Rent note
Patch SOFT/DEADMAN `:-` to ≥TTL−1h. UUID @$≥28/h, COUNT=8.
KING=Tok from rent. Use p283-safe preempt (isolated TCACHE → leave alone).
