# H50 — m7-init × winner-zA × lr=7.5e-6 (non-α)

## Claim

H42 (lr=5e-6) best family m=+0.01613. H48 (lr=1e-6) band-failed
base×1.269. H46 (2.5e-6) still open. One-axis: **lr=7.5e-6** (1.5× H42)
probes whether mild intensity-up above the best cell beats it.

## Method

1. Data: H27 `winner_za_high_l1.jsonl` (406 ex).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…`.
3. Thought-only LoRA **lr=7.5e-6**, r=16/α32, 1 epoch.
4. Merge → n80 vs TalentPigs @ `dbfbb3e2…` (mine-h50-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; r∈[0.3,4]; base× ≤ 1.25.

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; do not requeue lr>7.5e-6 until H46/H42 neighborhood resolves.
