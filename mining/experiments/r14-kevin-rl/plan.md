# R14 — kevin954-init REINFORCE on teacher Reason

## Axis
Past-earner **kevin954** reign-2 init + online REINFORCE with reward =
Reason (`lpC(y_C|z) − lpC(y_C|∅)`). Isolates earner-base × RL:
≠ R3/R3b Tok-GRPO, ≠ R8 Tok-REINFORCE, ≠ R5b Talent full-FT,
≠ R4 Tok full-FT. S\* H135/F40 used Λ2 (=Reason) under gates; never a
gateless Reason-v3 n80 under live kσ=2.

## Method
kevin954 @6a5815fa · LoRA r=16/α32 · lr=5e-6 · G=2 · max_steps=200
· data `winner_za_high_l1.jsonl` (406; prefixes+y) · train GPUs 6–7
· teacher on 0–1 before train · merge → n80 vs Tok.
Stack = H135 `train_rl_l2.py` + R14 start/bootstrap overlays.

## Pod
`mine-r14-kevin-rl-1` via fleet-rent (queue after R13). 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2087).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r14_pipeline.nohup` / `h135_train.nohup`.
