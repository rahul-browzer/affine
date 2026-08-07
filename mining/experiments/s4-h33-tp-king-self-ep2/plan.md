# H33 — TP-init × king-self × epochs=2 (non-α)

## Claim

H29 runs the same cell for 1 epoch (lr=1e-5). One-axis variant: **2 epochs**
may push clip-L1 further on the same king-self thoughts. Same data (TalentPigs
king-self 686→~368 fit-filtered) and same TP init (`TalentPigs/…abc` @
`dbfbb3e2…`).

## Method

1. Data: H29 harvest `king_self_high_l1.jsonl` (fit-filter in train_lora).
2. Init: live king TalentPigs @ `dbfbb3e2…`.
3. Thought-only LoRA **lr=1e-5**, r=16/α32, **epochs=2**.
4. Merge → n80 vs live king on mine-h33-1.

## Prediction (pre-registered)

n80 paired margin **> 0.04**; chall mean clip-L1 ≥ **0.042**; r∈[0.3,4];
base× ≤ 1.25. Expect lower final train loss than H29@1ep; watch overfit /
king-similarity.

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; do not requeue α / winner-zA lottery.
- Distinguish: same as H29 except epochs 1 → 2.
