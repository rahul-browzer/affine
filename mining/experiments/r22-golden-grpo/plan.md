# R22 — golden-crown-init Reason-GRPO

## Axis
**golden-crown/Affine-5EpvnXGu8jUAVc67oPGgJ3brR4JZqjBUSaTKhZuBoNAAzSJF** (seed earner) init +
LoRA-GRPO with reward = Reason (`lpC(y_C|z) − lpC(y_C|∅)`). Distinct from:
- R3 = Tok-init GRPO
- R16 = golden REINFORCE (same parent, different method)
- R18/R19/R20/R21 = sbs / Talent / kevin / pandora GRPO
R22 asks whether the seed-earner parent under the same GRPO stack clears the live crown bar.

## Method
golden @ee37f4f0 · LoRA r=16/α32 · lr=5e-6 · G=4 · max_steps=200
· data `winner_za_high_l1.jsonl` (406; prefixes+y) · train GPUs 6–7
· teacher on 0–1 before train · Tok king for n80 · merge → n80 vs Tok.
Stack = R3 `train_reason_grpo.py` + R22 start/bootstrap overlays (golden DL).

## Pod
`mine-r22-golden-grpo-1` via fleet-rent (queue after R21). 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2096).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r22_pipeline.nohup` / `r3_train.nohup`.
