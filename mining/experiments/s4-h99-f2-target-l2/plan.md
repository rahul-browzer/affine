# H99 / F2 — Target Λ2 via high-Λ2 z_A harvest (family screen)

## Family
**F2** (operator 2026-08-08): Target Λ2, not clip-L1. Not a winner-zA
rank cell. Prior family selected z_A by clip-L1≥0.04 (406 ex, mean family
−0.004). F2 selects by teacher Λ2 = lpC(y_C|z_A)−lpC(y_C|∅) ≥ 0.02.

## Claim
Tok331102-init thought-only LoRA (r=16/α32, lr=5e-6, 1 ep) on **1059**
high-Λ2 z_A examples (mean Λ2 0.086; 688 turns absent from clip-L1 set;
overlap only 35%) beats Tok by screen margin >+0.015. Data axis leaves the
clip-L1 basin; rank stays at default r=16 (F3 already screens r=256).

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Decision rule
- m≤0 or gate fail → REFUTE family cell; tear `mine-f2-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.
