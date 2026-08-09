# H117 / F22 — raw everest12 × no-LoRA (family screen)

## Claim
F15 screens everest12×high-Λ2 LoRA (still open). F17–F21 test unmodified
genesis/TalentPigs/kevin954/pandora/diane. **Nobody screened unmodified
everest12** as challenger vs live Tok. Prediction: n80 margin >+0.015.

## Method
1. Download `everest12/affine-5EkhZHopy9CAoUhKmVTDsyGQi7Voo9gURYPnNDiMZX1pQZxp`
   @ `a5ac5311d32f…` as chall (local path — sim-only).
2. Serve teacher + Tok king + everest12 chall under stock eval vLLM knobs.
3. One n80 SCREEN vs Tok (`eb8bf9a…`). No LoRA, no merge, no SFT.

## Decision rule
- margin > +0.015 → CONFIRM k=4 (same raw everest12 cell).
- margin ≤ 0 → REFUTE family; tear pod.
- 0 < margin ≤ 0.015 → shortlist / note; do not CONFIRM yet.

## Why this is a family (not a cell)
Structural change: **no adapter on a past crown**. Distinct from F15 (LoRA on
same base) and from F17–F21 (different unmodified bases).
