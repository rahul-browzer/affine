# H56 — m7-init × winner-zA × LoRA r=24 (non-α)

## Claim

H42 (lr=5e-6, r=16) best family m=+0.01613. r≤8 and r≥32 dead.
One-axis: **r=24** @ H42 lr=5e-6 / α32 probes the open r gap.

## Method

1. Data: H27 `winner_za_high_l1.jsonl` (406 ex).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…`.
3. Thought-only LoRA **r=24 / α32**, lr=5e-6, 1 epoch.
4. Merge → n80 vs TalentPigs @ `dbfbb3e2…` (mine-h56-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; r∈[0.3,4]; base× ≤ 1.25.

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; mark r=24 dead; do not requeue.
