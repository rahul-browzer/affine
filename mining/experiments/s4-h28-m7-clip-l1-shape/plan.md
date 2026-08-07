# H28 — m7-init clip-L1 shaping via winner z_A

## Claim

H25 (TP×m7 α0.90) REFUTED at m=+0.00662 — linear dilution kills m7's
clip-L1 edge (parent c_clipL1=+0.0435). H27 trains the same winner-zA data
from TalentPigs init. **H28 keeps m7 intact as init** and applies the same
thought-only LoRA on the 406 high-L1 winner z_A examples — non-α, different
base than H27.

## Method

1. Data: reuse H27 harvest `winner_za_high_l1.jsonl` (406 ex, mean clipL1 0.089).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…` (H25 pin).
3. Thought-only LoRA lr=1e-5, r=16/α32, 1 epoch (same as H27).
4. Merge → n80 vs live king TalentPigs @ `dbfbb3e2…` (mine-h28-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; chall mean clip-L1 ≥ **0.042**; r∈[0.3,4];
base× ≤ 1.25. (m7 parent was base×1.242 — watch band.)

## Decision rule

- margin > 0.04 + gates green → Stage 5 submit path.
- Genuine REFUTE → tear pod; do not requeue α0.90 or m7 merges.
- Distinguish vs H27: same data/recipe, **different init** (m7 vs TalentPigs).
