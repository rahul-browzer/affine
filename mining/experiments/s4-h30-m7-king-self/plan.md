# H30 — m7-init × king-self high clip-L1 z_A (non-α)

## Claim

2×2 cell missing from H27–H29:
| | winner-zA (mixed) | king-self (TalentPigs) |
|---|---|---|
| TalentPigs init | H27 REFUTE m=−0.00792 | H29 open |
| m7 init | H28 open | **H30** |

H30 keeps m7 intact as init (H28 axis) and trains only TalentPigs's own
high clip-L1 thoughts (H29 axis). Independent of H28/H29 outcomes.

## Method

1. Data: H29 harvest `king_self_high_l1.jsonl` (686 ex; train fit-filters
   msg_chars≤max_len×2.5 → ~368).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…`.
3. Thought-only LoRA lr=1e-5, r=16/α32, 1 epoch.
4. Merge → n80 vs live king TalentPigs @ `dbfbb3e2…` (mine-h30-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; chall mean clip-L1 ≥ **0.042**; r∈[0.3,4];
base× ≤ 1.25. (m7 parent base×1.242 — watch band.)

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; do not requeue α.
- Distinguish: same data as H29, different init (m7); same init as H28,
  different data (king-self).
