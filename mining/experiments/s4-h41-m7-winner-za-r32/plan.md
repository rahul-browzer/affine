# H41 — m7-init × winner-zA × LoRA r=32 (non-α)

## Claim

H28 (m7×winner-zA@r16/α32@lr1e-5@1ep) best so far m=+0.01095. One-axis
variant: **2× LoRA rank** (r=32, α=64) for more shaping capacity.

## Method

1. Data: H27 `winner_za_high_l1.jsonl` (406 ex, mean clipL1 0.089).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…`.
3. Thought-only LoRA **lr=1e-5**, **r=32/α64**, 1 epoch.
4. Merge → n80 vs TalentPigs @ `dbfbb3e2…` (mine-h41-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; r∈[0.3,4]; base× ≤ 1.25.

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; do not requeue H28@r16 / TP×ks / α.
