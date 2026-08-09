# H119 / F24 — raw af-k1 × no-LoRA (family screen)

## Claim
F16 screens af-k1×high-Λ2 LoRA (still open). F17–F23 test unmodified
genesis/TalentPigs/kevin/pandora/diane/everest/Bittob. **Nobody screened
unmodified af-k1** as challenger vs live Tok. Prediction: n80 margin >+0.015.

## Method
1. Download `af-k1/Affine-5ECeJJpEMjW4pxM9eGyJ5ua3Sebfyr8kcVwLAdaiJLUC8pkW`
   @ `ff6eb4bc…` as chall (local path — content already published; sim-only).
2. Serve teacher + Tok king + af-k1 chall under stock eval vLLM knobs.
3. One n80 SCREEN vs Tok (`eb8bf9a…`). No LoRA, no merge, no SFT.

## Decision rule
- margin > +0.015 → CONFIRM k=4 (same raw af-k1 cell).
- margin ≤ 0 → REFUTE family; tear pod.
- 0 < margin ≤ 0.015 → shortlist / note; do not CONFIRM yet.

## Why this is a family (not a cell)
Structural change: **no adapter on a past crown**. Distinct from F16 (LoRA on
same base) and from F17–F23 (different unmodified bases).
