# H39 — m7-init × winner-zA × lr=3e-5 (non-α)

## Claim

H28 (m7×winner-zA@lr1e-5@1ep) best so far m=+0.01095. H37 tests 1e-4;
this fills the mid LR axis: **lr=3e-5** (3× H28, 0.3× H37).

## Method

1. Data: H27 `winner_za_high_l1.jsonl` (406 ex, mean clipL1 0.089).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…`.
3. Thought-only LoRA **lr=3e-5**, r=16/α32, 1 epoch.
4. Merge → n80 vs TalentPigs @ `dbfbb3e2…` (mine-h39-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; r∈[0.3,4]; base× ≤ 1.25.

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; do not requeue H28@1e-5 / TP×ks / α.
