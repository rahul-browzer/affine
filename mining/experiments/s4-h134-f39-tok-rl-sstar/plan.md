# H134 / F39 — Tok REINFORCE on full S* mix (family screen)

## Family
**F39**: Online REINFORCE with reward = the frozen ranking term
`S = Λ2 + clip(L1lift, ±0.1)`. F37 optimizes Λ2 only; F1 optimized
self-L1 only (REFUTE +0.002). Neither optimizes the actual score.

## Claim
Tok-init LoRA trained by REINFORCE on full mix reward beats Tok by
screen margin >+0.015.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Method
1. Teacher on GPUs 0,1; policy LoRA on 6,7; Tok base @eb8bf9a.
2. Data: prefixes + teacher `y` from `winner_za_high_l1.jsonl` (x only).
3. LoRA r=16/α32 lr=5e-6 G=2 max_new=256 max_steps=200.
4. Reward: teacher Λ2 + policy clip(L1lift, ±0.1); advantage = r − mean(r).
5. Merge → n80 vs Tok.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f39-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural: reward = actual S* mix. Orthogonal to F37 (Λ2-only reward) and
F1 (L1-only). Not past-king FT / not raw past-earner.
