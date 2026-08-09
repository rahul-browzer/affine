# H129 / F34 — diane613 full-FT × high-Λ2 z_A (family screen)

## Family
**F34**: dense full-FT on **past-earner diane613** (not LoRA).
F13 diane×high-Λ2 LoRA refuted (m=−0.07293). F21 raw diane refuted
(m=−0.07226). Isolates whether those failures were LoRA/raw rather than the
diane base under dense FT.

## Claim
diane613 @ad0f3f116e44dc5154ca3f72b933faaefc4905fa init, thought-only **full
fine-tune** (no peft), freeze `model.visual.*`, lr=1e-6 1ep on 1059 high-Λ2
z_A → screen margin >+0.015 vs live Tok.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f34-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural: dense FT on diane. Distinct from F13 (LoRA) / F21 (raw) and from
F26–F33 (other dense-FT bases).
