# H43 — m7-init × winner-zA × LoRA α=64 (non-α)

## Claim

H28 (r16/α32) m=+0.01095. H41 tests r=32/α64. This isolates **α scaling
at fixed r=16**: α=64 (2× H28) without doubling rank.

## Method

1. Data: H27 `winner_za_high_l1.jsonl` (406 ex).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…`.
3. Thought-only LoRA lr=1e-5, **r=16/α64**, 1 epoch.
4. Merge → n80 vs TalentPigs @ `dbfbb3e2…` (mine-h43-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; r∈[0.3,4]; base× ≤ 1.25.

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; do not requeue α-merge / king-self family.
