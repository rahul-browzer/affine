# H131 / F36 — af-k1 full-FT × high-Λ2 z_A (family screen)

## Family
**F36**: dense full-FT on **past-earner af-k1** (not LoRA). F16 af-k1×high-Λ2
LoRA refuted (m=−0.07623). F24 raw af-k1 refuted (m=−0.08673). F26–F35 occupy
other dense-FT bases — this isolates whether LoRA/raw failure was the af-k1
base or the adapter/unmodified recipe.

## Claim
af-k1 @ff6eb4bc init, thought-only **full fine-tune** (no peft), freeze
`model.visual.*`, lr=1e-6 1ep on 1059 high-Λ2 z_A → screen margin >+0.015
vs live Tok.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f36-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural: dense FT on af-k1. Isolates whether F16/F24 failures were
LoRA ceiling / unmodified weights rather than the af-k1 base itself.
