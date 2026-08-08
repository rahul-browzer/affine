# H45 — m7-init × winner-zA × LoRA r=8 (non-α)

## Claim

H28 (r16/α32) best m=+0.01095; H41 **r32** REFUTE m=+0.00533 (capacity-up
hurts). One-axis opposite: **½ LoRA rank** (r=8, α=16) → gentler shaping.

## Method

1. Data: H27 `winner_za_high_l1.jsonl` (406 ex, mean clipL1 0.089).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…`.
3. Thought-only LoRA **lr=1e-5**, **r=8/α16**, 1 epoch.
4. Merge → n80 vs TalentPigs @ `dbfbb3e2…` (mine-h45-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; r∈[0.3,4]; base× ≤ 1.25.

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; do not requeue r≤8 / r≥32 on this cell.
