# H47 — m7-init × winner-zA × LoRA α=8 @ r16 (non-α)

## Claim

H43 (α=64 @ r16) REFUTED m=+0.01123. Capacity-up on α hurts/neutral.
One-axis opposite: **α=8** (¼ of H28 α32) at fixed r16 → gentler shaping.

## Method

1. Data: H27 `winner_za_high_l1.jsonl` (406 ex).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…`.
3. Thought-only LoRA **lr=1e-5**, **r=16/α8**, 1 epoch.
4. Merge → n80 vs TalentPigs @ `dbfbb3e2…` (mine-h47-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; r∈[0.3,4]; base× ≤ 1.25.

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; do not requeue α≤8 / α≥64 on this cell.
