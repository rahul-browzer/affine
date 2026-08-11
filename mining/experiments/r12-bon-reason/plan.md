# R12 — Best-of-N CE on live teacher Reason

## Axis
Sample G=4 thoughts from Tok-init LoRA, score each with live teacher
**Reason = lpC(y_C|z) − lpC(y_C|∅)**, CE-update **only the argmax** z.
Loss class ≠ R3 group-mean GRPO, ≠ R8 EMA REINFORCE, ≠ R11 online DPO.
S\* H137/F42 used the same reward under Λ2 naming — never a gateless
Reason-v3 n80 decision under live kσ=2.

## Method
Tok af10 init · LoRA r=16/α32 · lr=5e-6 · G=4 · max_steps=150
· teacher on :8000 · train GPUs 6–7 · merge → n80 vs Tok.
Stack = H137 `train_bon_l2.py` + R12 start/bootstrap overlays.

## Pod
`mine-r12-bon-1` via fleet-rent (queue after R11). 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2085).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r12_pipeline.nohup` / `h137_train.nohup`.
