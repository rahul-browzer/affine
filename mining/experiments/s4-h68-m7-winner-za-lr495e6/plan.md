# H68 — m7×winner-zA @ lr=4.95e-6

## Claim
H42@5e-6 best +0.01613; H53@4e-6 REFUTE −0.00885; H46@2.5e-6 +0.00802.
One-axis: **lr=4.95e-6** (just under peak, densest low side vs H65@5.02).

## Method
1. Data: H27 winner_za_high_l1.jsonl (406 ex).
2. Init: Radiant28/5eqdtdzqle-ckpt1000-m7 @ f766293ee878…
3. Thought-only LoRA r16/α32, lr=**4.95e-6**, 1 epoch.
4. Merge → n80 vs TalentPigs @ dbfbb3e2…

## Decision rule
margin > 0.04 + gates green → Stage 5; else REFUTE + tear; mark lr=4.95e-6 dead.

## Rent note
Patch SOFT/DEADMAN `:-` to ≥TTL−1h. UUID @$≥28/h, COUNT=8.
Arm preempt264 at upload. Queue behind H67 (r=19) on first free slot;
rent H68 on the next free after H67, or if H67 already live.
