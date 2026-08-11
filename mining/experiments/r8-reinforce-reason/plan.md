# R8 — REINFORCE on Reason (alt to LoRA-GRPO)

## Axis
Online REINFORCE with reward = Reason; EMA baseline + LoRA r=64 (≠ R3
group-mean GRPO G=4 r=16). Same teacher reward, different optimizer path.

## Pod
`mine-r8-reinforce-1` via fleet-rent. 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2077).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r8_train.nohup` (`[r8-hb]` / `[r8-log]`).
