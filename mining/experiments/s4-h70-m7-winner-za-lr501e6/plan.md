# H70 — m7×winner-zA @ lr=5.01e-6

## Claim
H65@5.02e-6 REFUTE m=+0.01829 (2nd-best after H64@r18 +0.02509).
H42@5e-6 +0.01613. One-axis densest between them: **lr=5.01e-6**.

## Method
1. Data: H27 winner_za_high_l1.jsonl (406 ex).
2. Init: Radiant28/5eqdtdzqle-ckpt1000-m7 @ f766293ee878…
3. Thought-only LoRA r16/α32, lr=**5.01e-6**, 1 epoch.
4. Merge → n80 vs TalentPigs @ dbfbb3e2…

## Decision rule
margin > 0.04 + gates green → Stage 5; else REFUTE + tear; mark lr=5.01e-6 dead.

## Rent note
Patch SOFT/DEADMAN `:-` to ≥TTL−1h. UUID @$≥28/h, COUNT=8.
Arm preempt264 at upload.
