# H69 — m7-init × winner-zA × LoRA r=17 (non-α)

## Claim
H64@r=18 best +0.02509 (z=2.993, fails 3σ by ~6e-5). H67@r=19 open.
H62@r=20 band×1.273. One-axis: **r=17** @ lr=5e-6 / α32 (below best r18;
r≤8 dead).

## Method
1. Data: H27 winner_za_high_l1.jsonl (406 ex).
2. Init: Radiant28/5eqdtdzqle-ckpt1000-m7 @ f766293ee878…
3. Thought-only LoRA **r=17 / α32**, lr=5e-6, 1 epoch.
4. Merge → n80 vs TalentPigs @ dbfbb3e2…

## Decision rule
margin > 0.04 + gates green → Stage 5; else REFUTE + tear; mark r=17 dead.

## Rent note
Patch SOFT/DEADMAN `:-` to ≥TTL−1h. UUID @$≥28/h, COUNT=8.
Arm preempt264 at upload.
