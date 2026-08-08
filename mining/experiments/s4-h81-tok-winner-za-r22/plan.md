# H81 — Tok-init × winner-zA @ LoRA r=22 vs Tok (non-α)

## Claim
After H78 m7×r21 REFUTE (m=−0.0074) and m7×r18 family failing vs Tok,
Tok-init remains the open axis (H79@r18 / H80@r17). Step rank to **r=22**
(≥3 from shortlist; untested; not in dead set r≤8∨16∨19∨20∨21∨24∨≥32).

## Method
1. Data: H27 winner_za_high_l1.jsonl (406 ex).
2. Init: Tok331102/affine-5EqYW8McUc-af10 @ eb8bf9a… (same as H79/H80).
3. Thought-only LoRA **r=22 / α32**, lr=5e-6, 1 epoch.
4. Merge → n80 vs Tok331102 @ eb8bf9a… (live king).

## Decision rule
margin > 0.04 + gates green → Stage 5 submit path.
m ∈ [0.015, 0.04] → shortlist replicate (do not blacklist).
m≤0 or gate-fail → REFUTE + tear.

## Rent note
Patch SOFT/DEADMAN `:-` to ≥TTL−1h. UUID @$≥28/h, COUNT=8.
Use p283-safe preempt (isolated TCACHE → leave alone). mid304 for mid-n80 bare.
