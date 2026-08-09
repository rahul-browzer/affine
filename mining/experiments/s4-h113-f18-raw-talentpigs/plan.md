# H113 / F18 — raw TalentPigs × no-LoRA (family screen)

## Claim
F10 screens TalentPigs×high-Λ2 LoRA (adapter on earner). F9/F12 showed
earner×LoRA worsens Λ2. F17 tests raw genesis; **nobody screened unmodified
TalentPigs** (reign-3, S=0.0315) as challenger vs live Tok. Prediction:
n80 margin >+0.015.

## Method
1. Download `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` as chall
   (local path — content already published; sim-only).
2. Serve teacher + Tok king + TalentPigs chall under stock eval vLLM knobs.
3. One n80 SCREEN vs Tok (`eb8bf9a…`). No LoRA, no merge, no SFT.

## Decision rule
- margin > +0.015 → CONFIRM k=4 (same raw TalentPigs cell).
- margin ≤ 0 → REFUTE family; tear pod.
- 0 < margin ≤ 0.015 → shortlist / note; do not CONFIRM yet.

## Why this is a family (not a cell)
Structural change: **no adapter on a crowned earner**. Distinct from F10
(LoRA on same base) and from F17 (raw genesis, different base).
