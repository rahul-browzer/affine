# H132 / F37 — Tok REINFORCE on teacher Λ2 (family screen)

## Family
**F37**: Direct RL on the ranking term. F1 REINFORCE-self-L1lift refuted
(m=+0.00229; Λ2 frozen). F1's own plan deferred a **teacher-Λ2 reward**
variant — this is that family. Not SFT on harvested z; not past-king×Λ2 FT.

## Claim
Tok331102-init LoRA trained by REINFORCE on thought tokens with reward =
`Λ2 = lpC(y|z) − lpC(y|∅)` from live teacher (GLM-4.5-Air via :8000 echo)
beats Tok by screen margin >+0.015. Teacher feedback can move Λ2; self-L1
could not.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Method
1. Serve teacher on GPUs 0,1 **before** train; policy LoRA on GPUs 6,7.
2. Data: prefixes + teacher `y` from `winner_za_high_l1.jsonl` (x only).
3. LoRA r=16/α32 lr=5e-6 G=2 max_new=256 max_steps=200.
4. Reward: teacher force-echo Λ2 (no L1 clip); advantage = r − mean(r) in group.
5. Merge → n80 vs Tok.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f37-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural: optimizes teacher Λ2 online — the larger honest-panel lever —
instead of CE imitation or self-L1. Orthogonal to F1 (self reward) and to the
dying past-king full-FT×high-Λ2 class.
