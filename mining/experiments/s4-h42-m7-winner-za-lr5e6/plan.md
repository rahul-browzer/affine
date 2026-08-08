# H42 — m7-init × winner-zA × lr=5e-6 (non-α)

## Claim

H28 (lr=1e-5) best m=+0.01095. H37 (1e-4) and H38 (ep2) REFUTED near-null.
Opposite LR axis: **half H28 LR (5e-6)** — less overwrite of m7 prior.

## Method

1. Data: H27 `winner_za_high_l1.jsonl` (406 ex).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…`.
3. Thought-only LoRA **lr=5e-6**, r=16/α32, 1 epoch.
4. Merge → n80 vs TalentPigs @ `dbfbb3e2…` (mine-h42-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; r∈[0.3,4]; base× ≤ 1.25.

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; do not requeue H28@1e-5 / higher-LR / ep≥2.
