# H57 — m7×winner-zA @ lr=5.25e-6

## Claim
Peak neighbour of H42 (best +0.01613 @ 5e-6). H53@4e-6 went negative (−0.00885);
H55@5.5e-6 still open. lr=5.25e-6 probes the ridge between 5e-6 and 5.5e-6.

## Method
Same cell as H28/H42: Radiant28/m7 init, winner_za_high_l1 406ex, thought-only
LoRA r16/α32, 1 epoch, lr=**5.25e-6**. n80 vs TalentPigs king.

## Decision rule
- SUBMIT if paired margin > 0.04 and gates pass.
- REFUTE if margin ≤ 0.04 (or invalid / band fail).
