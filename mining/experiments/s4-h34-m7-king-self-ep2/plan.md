# H34 — m7-init × king-self × epochs=2 (non-α)

## Claim

H30 runs m7×king-self for 1 epoch. One-axis variant: **2 epochs**. H29
(TP×king-self@1ep) REFUTED m=−0.015; keep testing the m7-init axis (H28 best
shaping so far) with more training.

## Method

1. Data: H29 harvest `king_self_high_l1.jsonl` (fit-filter in train_lora).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…`.
3. Thought-only LoRA **lr=1e-5**, r=16/α32, **epochs=2**.
4. Merge → n80 vs live king TalentPigs @ `dbfbb3e2…` (mine-h34-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; chall mean clip-L1 ≥ **0.042**; r∈[0.3,4];
base× ≤ 1.25.

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; do not requeue α / TP-init king-self@1ep.
- Distinguish: same as H30 except epochs 1 → 2.
