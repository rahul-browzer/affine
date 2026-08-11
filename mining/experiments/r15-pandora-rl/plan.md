# R15 — pandora-box-init REINFORCE on teacher Reason

## Axis
Past-earner **pandora-box** reign-1 init + online REINFORCE with reward =
Reason (`lpC(y_C|z) − lpC(y_C|∅)`). Isolates reign-1 × RL:
≠ R14 kevin-REINFORCE, ≠ R3/R8 Tok RL, ≠ H128 pandora full-FT (S\* refute),
≠ R5b Talent FT. Method already uses gateless Reason reward in `train_rl_l2.py`.

## Method
pandora @5218b138 · LoRA r=16/α32 · lr=5e-6 · G=2 · max_steps=200
· data `winner_za_high_l1.jsonl` (406; prefixes+y) · train GPUs 6–7
· teacher on 0–1 before train · merge → n80 vs Tok.
Stack = H135 `train_rl_l2.py` + R15 start/bootstrap overlays (pandora DL).

## Pod
`mine-r15-pandora-rl-1` via fleet-rent (queue after R14). 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2088).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r15_pipeline.nohup` / `h135_train.nohup`.
