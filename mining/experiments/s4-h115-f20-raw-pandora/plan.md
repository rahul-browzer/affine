# H115 / F20 — raw pandora × no-LoRA (family screen)

## Claim
F11 screens pandora×high-Λ2 LoRA (still open). F17–F19 test unmodified
genesis/TalentPigs/kevin954. **Nobody screened unmodified pandora-box
ckpt300-m4** (reign-1 earner) as challenger vs live Tok. Prediction:
n80 margin >+0.015.

## Method
1. Download `pandora-box/Affine-5eqdtdzqle-ckpt300-m4` @ `5218b138…` as chall
   (local path — content already published; sim-only).
2. Serve teacher + Tok king + pandora chall under stock eval vLLM knobs.
3. One n80 SCREEN vs Tok (`eb8bf9a…`). No LoRA, no merge, no SFT.

## Decision rule
- margin > +0.015 → CONFIRM k=4 (same raw pandora cell).
- margin ≤ 0 → REFUTE family; tear pod.
- 0 < margin ≤ 0.015 → shortlist / note; do not CONFIRM yet.

## Why this is a family (not a cell)
Structural change: **no adapter on a past crown**. Distinct from F11 (LoRA on
same base) and from F17–F19 (different unmodified bases).
