# H29 — king-self high clip-L1 z_A (non-α)

## Claim

H27 REFUTED (m=−0.00792): mixed-source winner-zA (kevin/m7/Tok/…) on
TalentPigs init. Mixing foreign thought styles may have confused the LoRA.
**H29 keeps TalentPigs init** but trains only on TalentPigs's *own* high
clip-L1 thoughts: `king_rows` from post-crown duels where TalentPigs@dbfbb
is king, plus crown `chal-00284` challenger rows.

## Method

1. Harvest (host CPU): clipL1≥0.04, z≤300, drop listy → **686** ex
   (mean clipL1 0.0885, z p50 192). See `results/harvest_stats.json`.
2. TalentPigs-init thought-only LoRA lr=1e-5, r=16/α32, 1 epoch.
3. Merge → n80 vs live king TalentPigs @ `dbfbb3e2…` (mine-h29-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; chall mean clip-L1 ≥ **0.042**; r∈[0.3,4];
base× ≤ 1.25.

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; do not requeue mixed winner-zA on TP init.
- Distinguish vs H27: **same init, different data** (king-self vs mixed).
- Distinguish vs H28: **same recipe family, different init+data** (TP+king-self
  vs m7+mixed winner-zA).
