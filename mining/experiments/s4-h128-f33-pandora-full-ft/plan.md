# H128 / F33 — pandora-box full-FT × high-Λ2 z_A (family screen)

## Family
**F33**: dense full-FT on **past-earner pandora-box ckpt300-m4** (not LoRA).
F11 pandora×high-Λ2 LoRA refuted (m=−0.03414). F20 raw pandora refuted
(m=−0.02975). Isolates whether those failures were LoRA/raw rather than the
pandora base under dense FT.

## Claim
pandora @5218b1383952ff7a8d49b1d7b82acfe5e1bd448d init, thought-only **full
fine-tune** (no peft), freeze `model.visual.*`, lr=1e-6 1ep on 1059 high-Λ2
z_A → screen margin >+0.015 vs live Tok.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f33-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural: dense FT on pandora. Distinct from F11 (LoRA) / F20 (raw) and from
F26–F32 (other dense-FT bases).
