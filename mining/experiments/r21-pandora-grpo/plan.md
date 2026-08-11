# R21 — pandora-box-init Reason-GRPO

## Axis
**pandora-box/Affine-5eqdtdzqle-ckpt300-m4** (reign-1) init + LoRA-GRPO with reward = Reason
(`lpC(y_C|z) − lpC(y_C|∅)`). Distinct from:
- R3 = Tok-init GRPO
- R15 = pandora REINFORCE (same parent, different method)
- R18/R19/R20 = sbs / Talent / kevin GRPO
R21 asks whether the reign-1 parent under the same GRPO stack clears the live crown bar.

## Method
pandora @5218b138 · LoRA r=16/α32 · lr=5e-6 · G=4 · max_steps=200
· data `winner_za_high_l1.jsonl` (406; prefixes+y) · train GPUs 6–7
· teacher on 0–1 before train · Tok king for n80 · merge → n80 vs Tok.
Stack = R3 `train_reason_grpo.py` + R21 start/bootstrap overlays (pandora DL).

## Pod
`mine-r21-pandora-grpo-1` via fleet-rent (queue after R20). 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2095).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r21_pipeline.nohup` / `r3_train.nohup`.
