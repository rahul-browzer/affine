# R16 — golden-crown-init REINFORCE on teacher Reason

## Axis
Seed/reign earner **golden-crown** init + online REINFORCE with reward =
Reason (`lpC(y_C|z) − lpC(y_C|∅)`). Completes reign-chain RL sweep:
≠ R14 kevin, ≠ R15 pandora, ≠ R3/R8 Tok RL, ≠ R5b Talent FT.
Method already uses gateless Reason reward in `train_rl_l2.py`.

## Method
golden-crown @ee37f4f0 · LoRA r=16/α32 · lr=5e-6 · G=2 · max_steps=200
· data `winner_za_high_l1.jsonl` (406; prefixes+y) · train GPUs 6–7
· teacher on 0–1 before train · merge → n80 vs Tok.
Stack = H135 `train_rl_l2.py` + R16 start/bootstrap overlays (golden DL).

## Pod
`mine-r16-golden-rl-1` via fleet-rent (queue after R15). 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2089).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r16_pipeline.nohup` / `h135_train.nohup`.
