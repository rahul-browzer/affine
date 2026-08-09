# H112 / F17 — raw genesis × no-LoRA (family screen)

## Claim
Honest-panel genesis beats the king field by **+0.16**. F4/F7/F8 applied
LoRA/RL on genesis and **destroyed** Λ2 vs Tok. Nobody screened **unmodified
genesis** (no train) as challenger vs live Tok. Prediction: n80 margin >+0.015.

## Method
1. Download `dendriteholdings/albedo-qwen3.6-35b-king-genesis` @ `abe89194…`
   as chall (local path — content already published; sim-only).
2. Serve teacher + Tok king + genesis chall under stock eval vLLM knobs.
3. One n80 SCREEN vs Tok (`eb8bf9a…`). No LoRA, no merge, no SFT.

## Decision rule
- margin > +0.015 → CONFIRM k=4 (same raw genesis cell).
- margin ≤ 0 → REFUTE family; tear pod.
- 0 < margin ≤ 0.015 → shortlist / note; do not CONFIRM yet.

## Why this is a family (not a cell)
Structural change: **no adapter**. Prior genesis slots all trained; this tests
whether the base Λ2 edge survives without LoRA sabotage.
