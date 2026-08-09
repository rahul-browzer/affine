# H123 / F28 — Tok full-FT × teacher_refs z_C (family screen)

## Family
**F28**: dense full-FT on **frontier teacher thoughts** (`teacher_refs_shortz`),
not miner winner-z_A. F26 tests dense FT on high-Λ2 z_A; F7 tested teacher z_C
under Genesis-LoRA (refuted). This isolates data axis under the dense-FT recipe.

## Claim
Tok331102 init, thought-only **full fine-tune** (no peft), freeze
`model.visual.*`, lr=1e-6 1ep on 791 `teacher_refs_shortz` → screen margin
>+0.015 vs live Tok.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f28-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural: dense FT × teacher z_C (frontier distillation target handed out in
duel records). Orthogonal to F26 (same recipe, winner-z_A data) and F7 (same
data, Genesis-LoRA).
