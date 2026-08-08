# H51 — m7-init × winner-zA × LoRA α=16 @ r16 (non-α)

## Claim

H47 (α=8) REFUTED m=+0.00463; H43 (α=64) REFUTED m=+0.01123.
One-axis: **α=16** (½ of H28 α32) — mid between dead α8 and baseline α32.

## Method

1. Data: H27 `winner_za_high_l1.jsonl` (406 ex).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…`.
3. Thought-only LoRA **lr=1e-5**, **r=16/α16**, 1 epoch.
4. Merge → n80 vs TalentPigs @ `dbfbb3e2…` (mine-h51-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; r∈[0.3,4]; base× ≤ 1.25.

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; α axis on this cell then closed below α32.
