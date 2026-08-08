# H49 — m7-init × winner-zA × LoRA α=4 @ r16 (non-α)

## Claim

H43 α64 REFUTE m=+0.011; H47 tests α=8. Next α step: **α=4** (½ of H47)
at fixed r16 — continue gentler-α axis after H44 data-up REFUTE.

## Method

1. Data: H27 `winner_za_high_l1.jsonl` (406 ex).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…`.
3. Thought-only LoRA lr=1e-5, **r=16/α=4**, 1 epoch.
4. Merge → n80 vs TalentPigs @ `dbfbb3e2…` (mine-h49-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; r∈[0.3,4]; base× ≤ 1.25.

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; keep LR axes (H46/H48), not intensity-up.
