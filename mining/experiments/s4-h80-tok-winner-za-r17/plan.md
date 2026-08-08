# H80 — Tok-init × winner-zA @ LoRA r=17 vs Tok (non-α)

## Claim
H79 runs Tok-init@r18. H69 shortlisted r=17 (+0.01641 vs TalentPigs). After
H75 near-null on m7×r18, train Tok-init at **r=17** (one axis from H79).

## Method
1. Data: H27 winner_za_high_l1.jsonl (406 ex).
2. Init: Tok331102/affine-5EqYW8McUc-af10 @ eb8bf9a… (also the duel king).
3. Thought-only LoRA **r=17 / α32**, lr=5e-6, 1 epoch.
4. Merge must be non-identical to Tok (LoRA Δ). n80 vs Tok @ eb8bf9a….

## Decision rule
margin > 0.04 + gates green → Stage 5 submit path.
m ∈ [0.015, 0.04] → shortlist replicate (do not blacklist).
m≤0 or gate-fail → REFUTE + tear.

## Rent note
Patch SOFT/DEADMAN `:-` to ≥TTL−1h. UUID @$≥28/h, COUNT=8.
KING=Tok from rent. Use p283-safe preempt (isolated TCACHE → leave alone).
