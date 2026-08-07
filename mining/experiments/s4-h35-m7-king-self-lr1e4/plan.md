# H35 — m7-init × king-self × lr=1e-4 (non-α)

## Claim

H30 (m7×king-self@lr1e-5) REFUTED m=−0.00316 (near-null, gates OK,
base×1.165). H31 tests 3× LR (3e-5). One-axis variant: **10× LR = 1e-4**
to push clip-L1 shaping harder before declaring the m7×king-self@1ep cell
dead. Same data + m7 init.

## Method

1. Data: H29 harvest `king_self_high_l1.jsonl` (fit-filter in train_lora).
2. Init: `Radiant28/5eqdtdzqle-ckpt1000-m7` @ `f766293ee878…`.
3. Thought-only LoRA **lr=1e-4**, r=16/α32, 1 epoch.
4. Merge → n80 vs live king TalentPigs @ `dbfbb3e2…` (mine-h35-1).

## Prediction (pre-registered)

n80 paired margin **> 0.04**; chall mean clip-L1 ≥ **0.042**; r∈[0.3,4];
base× ≤ 1.25. Watch overfit / band (m7 parent base×~1.24; H30 was 1.165).

## Decision rule

- margin > 0.04 + gates green → Stage 5.
- Genuine REFUTE → tear pod; do not requeue α / H30 cell @1e-5 / TP×ks@1ep.
- Distinguish: same as H30 except lr 1e-5 → 1e-4; same as H31 except 3e-5 → 1e-4.
