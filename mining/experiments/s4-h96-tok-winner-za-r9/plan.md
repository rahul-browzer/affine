# H96 — Tok-init × winner-zA @ LoRA r=9

## Claim
Tok331102-init thought-only LoRA on winner-zA high clip-L1 (406 ex), r=9/α32,
lr=5e-6, 1 epoch → paired margin >0.04 vs Tok331102 on public D n80.

## Why this cell
H92 r13 REFUTE m=+0.000618 (null). Untested gap cell between dead r≤8 and
live H95@r10. Axis step from H81@r22. Non-α.

## Decision rule
- REFUTE if m≤0 or gate fail.
- Shortlist (replicate) if 0.015≤m≤0.04.
- Submit candidate if m>0.04 + gates OK.
