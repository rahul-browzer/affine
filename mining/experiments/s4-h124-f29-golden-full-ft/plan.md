# H124 / F29 — golden-crown full-FT × high-Λ2 z_A (family screen)

## Family
**F29**: dense full-FT on **past-earner golden-crown** (not LoRA). F12
golden×high-Λ2 LoRA refuted (m=−0.059); F25 screens raw golden in parallel.
F26/F27 already occupy Tok/Genesis dense-FT bases — this is the third base
under the dense-FT recipe.

## Claim
golden-crown @ee37f4f0 init, thought-only **full fine-tune** (no peft), freeze
`model.visual.*`, lr=1e-6 1ep on 1059 high-Λ2 z_A → screen margin >+0.015
vs live Tok.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f29-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural: dense FT on a different earner base than Tok/Genesis. Isolates
whether LoRA was the F12 failure mode (adapter ceiling) vs golden base itself.
