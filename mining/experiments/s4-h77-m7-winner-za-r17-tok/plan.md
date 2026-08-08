# H77 — m7×winner-zA @ LoRA r=17 vs Tok (non-α)

## Claim
H69@r17 was +0.01641 vs TalentPigs (shortlist-weak, never Tok). H72@r18 and H73@r19 both m<0 vs Tok — test r=17 vs live king.

## Method
1. Data: H27 winner_za_high_l1.jsonl (406 ex).
2. Init: Radiant28/5eqdtdzqle-ckpt1000-m7 @ f766293ee878…
3. Thought-only LoRA **r=17 / α32**, lr=5e-6, 1 epoch.
4. Merge → n80 vs Tok331102 @ eb8bf9a… (live king S=0.04456).

## Decision rule
margin > 0.04 + gates green → Stage 5 submit path.
m ∈ [0.015, 0.04] → shortlist replicate (do not blacklist).
m≤0 or gate-fail → REFUTE + tear.

## Rent note
Patch SOFT/DEADMAN `:-` to ≥TTL−1h. UUID @$≥28/h, COUNT=8.
KING=Tok from rent. Use p283-safe preempt (isolated TCACHE → leave alone).
