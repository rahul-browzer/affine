# R23 — diane613-init Reason-GRPO

## Axis
**diane613/Affine-5CQLBK7Mmw1vsk7eQcBok9Qn44JNU5YVrfNmZpJHPxLV271B** @ad0f3f11
(board parent) init + LoRA-GRPO with reward = Reason
(`lpC(y_C|z) − lpC(y_C|∅)`). Distinct from:
- R3 = Tok-init GRPO
- R16/R22 = golden REINFORCE / golden GRPO
- R18/R19/R20/R21 = sbs / Talent / kevin / pandora GRPO
R23 asks whether the diane613 board parent under the same GRPO stack
clears the live crown bar.

## Method
diane @ad0f3f11 · LoRA r=16/α32 · lr=5e-6 · G=4 · max_steps=200
· data `winner_za_high_l1.jsonl` (406; prefixes+y) · train GPUs 6–7
· teacher on 0–1 before train · Tok king for n80 · merge → n80 vs Tok.
Stack = R3 `train_reason_grpo.py` + R23 start/bootstrap overlays (diane DL).

## Pod
`mine-r23-diane-grpo-1` via fleet-rent (queue after R22). 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2097).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r23_pipeline.nohup` / `r3_train.nohup`.
