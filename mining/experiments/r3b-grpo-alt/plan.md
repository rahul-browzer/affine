# R3b — GRPO alt-LR / rank family

## Axis
Same teacher-Reason GRPO as R3 (`mine-r3-grpo-1`), different optimizer knobs:
lr=**2e-5** (4× R3), LoRA **r=64/α128** (R3 is r=16/α32), group-size **G=8**.
Structural LR/rank family — not a cosmetic parent swap.

## Pod
`mine-r3-grpo-2` via fleet-rent (queue after R4–R8). 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2078).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r3_train.nohup` (`[r3-hb]` / `[r3-log]`).
