# H141 / F46 — Genesis last-N full-rank REINFORCE on teacher Λ2

## Family
**F46**: Cross of F38 (Genesis init × teacher-Λ2) and F45 (last-N=8 full-rank
+ lm_head, not LoRA). Train init = genesis; n80 king = Tok331102.

## Claim
LoRA cannot move Λ2 (F37/F38-class). Genesis full-FT CE failed (F27). Last-N
full-rank on Genesis under online teacher-Λ2 can move Λ2 → screen m>+0.015.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Method
1. Teacher :8000 GPUs 0,1; policy on 6,7; Tok king prewarm :8001 for n80.
2. Data: prefixes + y from `winner_za_high_l1.jsonl`.
3. Unfreeze last 8 layers + lm_head; SGD lr=1e-6; G=2; max_steps=150.
4. Save `/tmp/h141_full_ft_save` → symlink → n80 vs Tok.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f46-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural cross: non-king base (Λ2 free) × full-rank last-N capacity.
Orthogonal to F38 (LoRA), F45 (Tok-init), F27 (dense CE FT).
