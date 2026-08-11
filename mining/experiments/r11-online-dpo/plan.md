# R11 — Online DPO on live teacher Reason

## Axis
Sample G=2 thoughts from Tok-init LoRA, label with live teacher
**Reason = lpC(y_C|z) − lpC(y_C|∅)**, DPO (β=0.1) vs frozen base.
Loss class ≠ R3 group-mean GRPO, ≠ R8 EMA REINFORCE, ≠ offline duel-pref
DPO (H138 REFUTE). S\* H139/F44 was abandoned mid-n80 (p538) — never a
Reason-v3 decision under gateless kσ=2.

## Method
Tok af10 init · LoRA r=16/α32 · lr=5e-6 · G=2 · β=0.1 · max_steps=150
· min_gap=0.005 · teacher on :8000 · train GPUs 6–7 · merge → n80 vs Tok.
Stack = H139 `train_online_dpo.py` + R11 start/bootstrap overlays.

## Pod
`mine-r11-odpo-1` via fleet-rent (queue after R6b). 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2084).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r11_pipeline.nohup` / `h139_train.nohup`.
