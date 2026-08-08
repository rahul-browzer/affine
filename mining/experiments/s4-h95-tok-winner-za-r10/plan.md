# H95 — Tok-init × winner-zA @ LoRA r=10

## Claim
Tok331102-init thought-only LoRA on winner-zA high clip-L1 (406 ex), r=10/α32,
lr=5e-6, 1 epoch → paired margin >0.04 vs Tok331102 on public D n80.

## Why this cell
H90 r14 REFUTE m=−0.00847. Untested gap between dead r≤8 and live H94@r11.
Axis step ≥8 from H81@r22 (+0.008811). Non-α.

## Decision rule
- REFUTE if m≤0 or gate fail.
- Shortlist (replicate) if 0.015≤m≤0.04.
- Submit candidate if m>0.04 + gates OK.
