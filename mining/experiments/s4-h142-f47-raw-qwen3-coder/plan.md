# H142 / F47 — raw Qwen3-Coder-30B-A3B-Instruct (family screen)

## Family
**F47**: unmodified `Qwen/Qwen3-Coder-30B-A3B-Instruct` @ `b2cff646eb4b…`
as challenger vs live Tok. No LoRA, no FT, no RL. First non-Albedo base.

## Claim
All prior screens stayed inside Albedo Qwen3.5-35B-MoE (kings/earners).
Λ2 is a base-model property (LESSONS). A coding-native Qwen3-MoE outside that
basin can move mean margin by >+0.015 vs Tok on public D.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Method
1. Download Coder + teacher GLM-Air + Tok king.
2. Serve under stock eval vLLM (tp2, max-model-len 32768, chall util=0.72).
3. One n80 SCREEN vs Tok (`eb8bf9a…`). No train.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f47-1`.
- 0.015<m≤0.04 → CONFIRM k=4 (same raw Coder cell).
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural: **different model family** (Qwen3-Coder MoE, no Albedo SFT).
Orthogonal to F17–F25 raw past-kings, F38–F46 RL/DPO/BoN/lastN on Albedo.
