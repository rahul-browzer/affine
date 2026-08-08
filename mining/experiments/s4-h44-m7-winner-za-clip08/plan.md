# H44 — m7-init × winner-zA clipL1≥0.08 (non-α data axis)

## Claim

H28 used all 406 winner-zA ex (mean clipL1 0.089). H39 mid-LR REFUTE m=+0.005.
**Stricter data** (clipL1≥0.08 → 305 ex, mean 0.098) at H28 hyperparams
(lr=1e-5, r16/α32, 1ep) → cleaner clip-L1 shaping → m>0.04.

## Method

1. Data: filter H27 `winner_za_high_l1.jsonl` to clipL1≥0.08 (305 rows).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…`.
3. Thought-only LoRA lr=1e-5, r=16/α32, 1 epoch (identical to H28).
4. Merge → n80 vs TalentPigs @ `dbfbb3e2…` (mine-h44-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; r∈[0.3,4]; base× ≤ 1.25.

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; do not requeue full-406 @ same hyperparams as sole lever.
