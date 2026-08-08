# H97 / F3 — Break LoRA ceiling @ r=256 (Tok-init × winner-zA)

## Family
**F3** (operator 2026-08-08): full FT or rank ≥256. Not a winner-zA rank
micro-sweep cell — prior cells capped at r≤31; H41@r32 was m7-init and dead.
Claim: Λ2 is a base-model property; r≈18 cannot move it; r=256 can.

## Claim
Tok331102-init thought-only LoRA on winner-zA (406 ex), **r=256/α512**,
lr=5e-6, 1 epoch → n80 paired margin >0.015 vs Tok (screen). Confirm k=4
if screen clears +0.015.

## Prediction (pre-registered)
Screen mean margin **> +0.015** (family-hit bar). Submit needs >0.04.

## Decision rule
- m≤0 or gate fail → REFUTE family cell; tear `mine-f3-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.
