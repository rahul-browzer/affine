# H143 / F48 — raw Qwen3-30B-A3B-Instruct-2507 (family screen)

## Family
**F48**: unmodified `Qwen/Qwen3-30B-A3B-Instruct-2507` @ `0d7cf23991f4…`
as challenger vs live Tok. No LoRA, no FT, no RL. Second non-Albedo base
(general Instruct MoE, not Coder, not Albedo Qwen3.5-35B).

## Claim
Λ2 is a base-model property. A text-only Qwen3-MoE Instruct outside the Albedo
basin (and orthogonal to F47 Coder) can move mean margin by >+0.015 vs Tok.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Method
1. Download Instruct-2507 + teacher GLM-Air + Tok king.
2. Serve under stock eval vLLM (tp2, max-model-len 32768, chall util=0.72).
3. One n80 SCREEN vs Tok (`eb8bf9a…`). No train.

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f48-1`.
- 0.015<m≤0.04 → CONFIRM k=4 (same raw Instruct cell).
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Structural: **different model family** (Qwen3-30B-A3B Instruct-2507, CausalLM
MoE, no Albedo SFT). Orthogonal to F47 (Coder post-train), F17–F25 raw
past-kings, and F38–F46 RL/DPO/BoN/lastN on Albedo.
