# H126 / F31 — Bittob11040 full-FT × high-Λ2 z_A (family screen)

## Family
**F31**: dense full-FT on **past-earner Bittob11040** (not LoRA). F14 Bittob×high-Λ2
LoRA refuted (m=−0.05784). F23 raw Bittob still screening. F26–F30 occupy
Tok/Genesis/teacher-refs/golden/kevin dense-FT — this is the next earner base.

## Claim
Bittob @0c04fe92 init, thought-only **full fine-tune** (no peft), freeze
`model.visual.*`, lr=1e-6 1ep on 1059 high-Λ2 z_A → screen margin >+0.015
vs live Tok.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f31-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural: dense FT on Bittob. Isolates whether F14's LoRA ceiling (not the
Bittob base) was the failure mode. Orthogonal to live F23 raw-Bittob screen.
