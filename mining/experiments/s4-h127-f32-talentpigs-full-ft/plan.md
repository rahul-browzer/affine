# H127 / F32 — TalentPigs full-FT × high-Λ2 z_A (family screen)

## Family
**F32**: dense full-FT on **past-earner TalentPigs** (not LoRA). F10 TalentPigs×high-Λ2
LoRA refuted (m=−0.03095). F18 raw TalentPigs refuted (m=−0.03010). F26–F31 occupy
other dense-FT bases — this isolates whether LoRA/raw failure was the TalentPigs
base or the adapter/unmodified recipe.

## Claim
TalentPigs @dbfbb3e2 init, thought-only **full fine-tune** (no peft), freeze
`model.visual.*`, lr=1e-6 1ep on 1059 high-Λ2 z_A → screen margin >+0.015
vs live Tok.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f32-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural: dense FT on TalentPigs. Isolates whether F10/F18 failures were
LoRA ceiling / unmodified weights rather than the TalentPigs base itself.
