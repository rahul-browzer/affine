# H32 — TP-init × king-self × lr=3e-5 (non-α)

## Claim

H29 runs the same cell at lr=1e-5. One-axis variant: **3× LR** on
TalentPigs init + king-self high-L1 z_A may push clip-L1 enough for m>0.04.
Completes the 2×2 with H30/H31 (m7 × {1e-5,3e-5}) and H29 (TP × 1e-5).

## Method

1. Data: H29 harvest `king_self_high_l1.jsonl` (fit-filter in train_lora).
2. Init: `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…`.
3. Thought-only LoRA **lr=3e-5**, r=16/α32, 1 epoch.
4. Merge → n80 vs live king TalentPigs @ `dbfbb3e2…` (mine-h32-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; chall mean clip-L1 ≥ **0.042**; r∈[0.3,4];
base× ≤ 1.25. Expect higher loss drop vs H29@1e-5; watch overfit /
band (TP-init usually base×≈1.0).

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; do not requeue α.
- Distinguish: same as H29 except lr 1e-5 → 3e-5.
