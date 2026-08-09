# H114 / F19 — raw kevin954 × no-LoRA (family screen)

## Claim
F9 screened kevin954×high-Λ2 LoRA and **refuted** (m=−0.01417). F17/F18
test unmodified genesis/TalentPigs. **Nobody screened unmodified kevin954**
(reign seed earner, prior S≈0.0396) as challenger vs live Tok. Prediction:
n80 margin >+0.015.

## Method
1. Download `kevin954/Affine-5dfqbbh8ev-sft` @ `3fb79cfb…` as chall
   (local path — content already published; sim-only).
2. Serve teacher + Tok king + kevin chall under stock eval vLLM knobs.
3. One n80 SCREEN vs Tok (`eb8bf9a…`). No LoRA, no merge, no SFT.

## Decision rule
- margin > +0.015 → CONFIRM k=4 (same raw kevin cell).
- margin ≤ 0 → REFUTE family; tear pod.
- 0 < margin ≤ 0.015 → shortlist / note; do not CONFIRM yet.

## Why this is a family (not a cell)
Structural change: **no adapter on a past crown**. Distinct from F9 (LoRA on
same base) and from F17/F18 (different unmodified bases).
