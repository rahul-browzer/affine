# H125 / F30 — kevin954 full-FT × high-Λ2 z_A (family screen)

## Family
**F30**: dense full-FT on **past-earner kevin954** (not LoRA). F9 kevin×high-Λ2
LoRA refuted (m=−0.014); F19 raw kevin refuted (m=−0.006 — least-bad raw).
F26–F29 occupy Tok/Genesis/teacher-refs/golden dense-FT — this is the next
earner base under the dense-FT recipe.

## Claim
kevin954 @3fb79cfb init, thought-only **full fine-tune** (no peft), freeze
`model.visual.*`, lr=1e-6 1ep on 1059 high-Λ2 z_A → screen margin >+0.015
vs live Tok.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f30-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural: dense FT on kevin (best raw past-earner). Isolates whether F9's
LoRA ceiling (not the kevin base) was the failure mode.
