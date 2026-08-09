# H140 / F45 — Tok last-N full-rank REINFORCE on teacher Λ2

## Family
**F45**: Same teacher-Λ2 REINFORCE reward as F37, but **full-rank updates on
the last N=8 transformer layers + lm_head** (freeze `model.visual.*` and
earlier layers). Not LoRA. Not CE full-FT (F26). Not BoN/DPO.

## Claim
LoRA cannot move Λ2 (LESSONS; F1/F2/F3/F37-class). Full-rank last-N updates
can; online teacher-Λ2 reward shapes those layers → screen m>+0.015 vs Tok.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Method
1. Teacher :8000 GPUs 0,1; policy on 6,7.
2. Data: prefixes + y from `winner_za_high_l1.jsonl`.
3. Unfreeze layers ≥ cutoff (last 8) + lm_head/norm; SGD lr=1e-6 mom=0.9;
   G=2; max_steps=150; max_new=256.
4. Save `/tmp/h140_full_ft_save` → symlink `full_ft` → n80 vs Tok.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f45-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural capacity change vs F37 (LoRA r16): full-rank last-N targets the
documented LoRA-Λ2 freeze. Orthogonal to F26 (CE dense FT, m=−0.00031).
