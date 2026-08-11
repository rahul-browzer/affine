# R20 — kevin954-init Reason-GRPO

## Axis
**kevin954/Affine-5dfqbbh8ev-sft** (reign-2) init + LoRA-GRPO with reward = Reason
(`lpC(y_C|z) − lpC(y_C|∅)`). Distinct from:
- R3 = Tok-init GRPO
- R14 = kevin REINFORCE (same parent, different method)
- R18 = sbs-v2 GRPO
- R19 = Talent-init GRPO
R20 asks whether the reign-2 parent under the same GRPO stack clears the live crown bar.

## Method
kevin @6a5815fa · LoRA r=16/α32 · lr=5e-6 · G=4 · max_steps=200
· data `winner_za_high_l1.jsonl` (406; prefixes+y) · train GPUs 6–7
· teacher on 0–1 before train · Tok king for n80 · merge → n80 vs Tok.
Stack = R3 `train_reason_grpo.py` + R20 start/bootstrap overlays (kevin DL).

## Pod
`mine-r20-kevin-grpo-1` via fleet-rent (queue after R19). 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2094).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r20_pipeline.nohup` / `r3_train.nohup`.
