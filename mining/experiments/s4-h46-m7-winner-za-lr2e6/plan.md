# H46 — m7-init × winner-zA × lr=2.5e-6 (non-α)

## Claim

H42 (lr=5e-6) REFUTED but best H28-family margin yet: **m=+0.01613**
(vs H28@1e-5 m=+0.01095). Gentler LR helps. Next: **half H42 LR (2.5e-6)**.

## Method

1. Data: H27 `winner_za_high_l1.jsonl` (406 ex).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…`.
3. Thought-only LoRA **lr=2.5e-6**, r=16/α32, 1 epoch.
4. Merge → n80 vs TalentPigs @ `dbfbb3e2…` (mine-h46-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; r∈[0.3,4]; base× ≤ 1.25.

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; keep exploring gentler/data axes, not intensity-up.
