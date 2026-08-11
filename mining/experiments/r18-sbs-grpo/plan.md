# R18 — pure sbs-v2-init Reason-GRPO

## Axis
**ammazon/Affine-5dvqtektxx-sbs-v2** init + LoRA-GRPO with reward = Reason
(`lpC(y_C|z) − lpC(y_C|∅)`). Distinct from:
- R2ay = pure sbs-v2 screen only (WEAK +0.0093, no train)
- R3 = Tok-init GRPO
- R10 = Tok×sbs α-merge → GRPO
R18 asks whether the WEAK parent alone, under GRPO, clears the crown bar.

## Method
sbs-v2 @6f1b8e68 · LoRA r=16/α32 · lr=5e-6 · G=4 · max_steps=200
· data `winner_za_high_l1.jsonl` (406; prefixes+y) · train GPUs 6–7
· teacher on 0–1 before train · Tok king for n80 · merge → n80 vs Tok.
Stack = R3 `train_reason_grpo.py` + R18 start/bootstrap overlays (sbs DL).

## Pod
`mine-r18-sbs-grpo-1` via fleet-rent (queue after R17). 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2092).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r18_pipeline.nohup` / `r3_train.nohup`.
