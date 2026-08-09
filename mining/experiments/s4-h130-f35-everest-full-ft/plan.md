# H130 / F35 — everest12 full-FT × high-Λ2 z_A (family screen)

## Family
**F35**: dense full-FT on **past-earner everest12** (not LoRA).
F15 everest×high-Λ2 LoRA refuted (m=−0.08285). F22 raw everest still open
(screen pending). Isolates whether LoRA failure was adapter ceiling rather
than the everest base under dense FT.

## Claim
everest12 @a5ac5311d32f5d96d604c14294046e27130e1b5c init, thought-only **full
fine-tune** (no peft), freeze `model.visual.*`, lr=1e-6 1ep on 1059 high-Λ2
z_A → screen margin >+0.015 vs live Tok.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f35-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural: dense FT on everest. Distinct from F15 (LoRA) / F22 (raw) and from
F26–F34 (other dense-FT bases).
