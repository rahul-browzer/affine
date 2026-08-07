# H36 — m7-init × UNION(winner-zA ∪ king-self) (non-α)

## Claim

H28 (m7×winner-zA) best so far m=+0.01095; H30/H31 (m7×king-self@1ep)
near-null (−0.003 / +0.000). One-axis new data: **train on the union** of
both high clip-L1 z_A sets under the same m7 init @ lr=1e-5 / 1ep. Distinct
from H35 (king-self@1e-4) and H34 (king-self@ep2).

## Method

1. Data: concat winner_za_high_l1.jsonl ∪ king_self_high_l1.jsonl (deduped).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…`.
3. Thought-only LoRA lr=1e-5, r=16/α32, 1 epoch.
4. Merge → n80 vs TalentPigs @ `dbfbb3e2…` (mine-h36-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; r∈[0.3,4]; base× ≤ 1.25.

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; do not requeue α / exact H28 / H30@1e-5.
