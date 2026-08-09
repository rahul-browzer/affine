# H120 / F25 — raw golden-crown × no-LoRA (family screen)

## Claim
F12 screened golden-crown×high-Λ2 LoRA and **refuted** (m=−0.05941).
F19 raw kevin954 also refuted (m=−0.00611). **Nobody screened unmodified
golden-crown** (reign earner `…AzSJF` @ `ee37f4f0…`) as challenger vs live
Tok. Prediction: n80 margin >+0.015.

## Method
1. Download `golden-crown/Affine-5EpvnXGu8jUAVc67oPGgJ3brR4JZqjBUSaTKhZuBoNAAzSJF`
   @ `ee37f4f0457df943d957435d7c9c24222a7ca93d` as chall (sim-only).
2. Serve teacher + Tok king + golden-crown chall under stock eval vLLM knobs.
3. One n80 SCREEN vs Tok (`eb8bf9a…`). No LoRA, no merge, no SFT.

## Decision rule
- margin > +0.015 → CONFIRM k=4 (same raw golden-crown cell).
- margin ≤ 0 → REFUTE family; tear pod.
- 0 < margin ≤ 0.015 → shortlist / note; do not CONFIRM yet.

## Why this is a family (not a cell)
Structural change: **no adapter on a past crown**. Distinct from F12 (LoRA
on same base) and from F17–F24 (different unmodified bases). Last earning
reign member not yet raw-screened.
