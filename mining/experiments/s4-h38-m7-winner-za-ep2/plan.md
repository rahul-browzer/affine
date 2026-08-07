# H38 — m7-init × winner-zA × epochs=2 (non-α)

## Claim

H28 (m7×winner-zA@lr1e-5@1ep) m=+0.01095. One-axis variant: **2× epochs**
on the same cell (same LR) — independent of H37's LR axis.

## Method

1. Data: H27 harvest `winner_za_high_l1.jsonl` (406 ex).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…`.
3. Thought-only LoRA lr=1e-5, r=16/α32, **epochs=2**.
4. Merge → n80 vs TalentPigs @ `dbfbb3e2…` (mine-h38-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; r∈[0.3,4]; base× ≤ 1.25.

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; do not requeue H28@1ep / TP×ks / α.
