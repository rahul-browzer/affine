# H31 — m7-init × king-self × lr=3e-5 (non-α)

## Claim

H30 runs the same cell at lr=1e-5. One-axis variant: **3× LR** may push
clip-L1 further without α dilution. Same data (TalentPigs king-self 686→~368)
and same m7 init (`Radiant28/…m7` @ `f766293ee878`).

## Method

1. Data: H29 harvest `king_self_high_l1.jsonl` (fit-filter in train_lora).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…`.
3. Thought-only LoRA **lr=3e-5**, r=16/α32, 1 epoch.
4. Merge → n80 vs live king TalentPigs @ `dbfbb3e2…` (mine-h31-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; chall mean clip-L1 ≥ **0.042**; r∈[0.3,4];
base× ≤ 1.25. Expect higher train loss drop vs H30@1e-5; watch overfit /
band (m7 parent base×~1.24).

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; do not requeue α.
- Distinguish: same as H30 except lr 1e-5 → 3e-5.
