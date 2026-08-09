# H118 / F23 — raw Bittob11040 × no-LoRA (family screen)

## Claim
F14 screens Bittob×high-Λ2 LoRA (still open). F17–F22 test unmodified
genesis/TalentPigs/kevin954/pandora/diane/everest. **Nobody screened unmodified
Bittob11040** as challenger vs live Tok. Prediction: n80 margin >+0.015.

## Method
1. Download `Bittob11040/Affine_5DSW4cTwQt2U8rck6mFN1nNqoj37j1waqwszQDuz2zh9zC7z`
   @ `0c04fe92ce952ffb13af69f3218d5e13cb571df5` as chall (local path — sim-only).
2. Serve teacher + Tok king + Bittob chall under stock eval vLLM knobs.
3. One n80 SCREEN vs Tok (`eb8bf9a…`). No LoRA, no merge, no SFT.

## Decision rule
- margin > +0.015 → CONFIRM k=4 (same raw Bittob cell).
- margin ≤ 0 → REFUTE family; tear pod.
- 0 < margin ≤ 0.015 → shortlist / note; do not CONFIRM yet.

## Why this is a family (not a cell)
Structural change: **no adapter on a past crown**. Distinct from F14 (LoRA on
same base) and from F17–F22 (different unmodified bases).
