# H55 — m7-init × winner-zA × lr=5.5e-6 (non-α)

## Claim

H42 (lr=5e-6) best family m=+0.01613. H50@7.5e-6 REFUTED m=+0.00322 —
higher lr collapses. One-axis: **lr=5.5e-6** (between H42 5e-6 and H52 6e-6)
probes whether the peak sits slightly above 5e-6.

## Method

1. Data: H27 `winner_za_high_l1.jsonl` (406 ex).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…`.
3. Thought-only LoRA **lr=5.5e-6**, r=16/α32, 1 epoch.
4. Merge → n80 vs TalentPigs @ `dbfbb3e2…` (mine-h55-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; r∈[0.3,4]; base× ≤ 1.25.

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; mark lr=5.5e-6 dead; do not requeue.
