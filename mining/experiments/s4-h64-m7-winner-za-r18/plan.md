# H64 — m7-init × winner-zA × LoRA r=18 (non-α)

## Claim
H42 (r=16) best +0.01613; H56@r=24 REFUTE m=+0.00140; H62@r=20 open.
One-axis: **r=18** @ lr=5e-6 / α32 (between r16 and open r20).

## Method
1. Data: H27 winner_za_high_l1.jsonl (406 ex).
2. Init: Radiant28/5eqdtdzqle-ckpt1000-m7 @ f766293ee878…
3. Thought-only LoRA **r=18 / α32**, lr=5e-6, 1 epoch.
4. Merge → n80 vs TalentPigs @ dbfbb3e2…

## Decision rule
margin > 0.04 + gates green → Stage 5; else REFUTE + tear; mark r=18 dead.

## Rent note
Patch SOFT/DEADMAN `:-` to ≥TTL−1h. UUID @$≥28/h, COUNT=8.
