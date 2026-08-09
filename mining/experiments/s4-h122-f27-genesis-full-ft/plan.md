# H122 / F27 — Genesis full-FT (not LoRA) × high-Λ2 z_A (family screen)

## Family
**F27**: dense full-FT on **genesis** init. F26 tests dense FT on Tok; F4/F7/F8
showed Genesis-init LoRA/RL **destroy** Λ2. Nobody has dense-FT'd genesis.
Honest-panel genesis edge is +0.16 — claim: dense FT can move Λ2 without the
LoRA sabotage mode.

## Claim
Genesis @abe89194 init, thought-only **full fine-tune** (no peft), freeze
`model.visual.*`, lr=1e-6 1ep on 1059 high-Λ2 z_A → screen margin >+0.015
vs live Tok.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f27-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural: dense FT × genesis base (not Tok). Orthogonal to F26 (Tok-FT) and
F17 (raw genesis, no train). Same data as F2/F26 so a hit isolates base×recipe.
