# H121 / F26 — Tok full-FT (not LoRA) × high-Λ2 z_A (family screen)

## Family
**F26**: first non-LoRA train family. LoRA-on-anything (incl. r=256 F3) left
Λ2 frozen; mechanical claim is low-rank adapters cannot move the teacher-side
term. Dense full-FT of language weights on the same high-Λ2 data is the
direct test of that bottleneck.

## Claim
Tok331102 init, thought-only **full fine-tune** (no peft), freeze
`model.visual.*`, lr=1e-6 1ep on 1059 high-Λ2 z_A → screen margin >+0.015
vs live Tok.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f26-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural: dense weight updates vs every prior LoRA cell. Same data as F2
(refuted under LoRA) so a hit isolates the adapter bottleneck.
