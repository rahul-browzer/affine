# R8 — REINFORCE on Reason (alt to LoRA-GRPO)

## Axis
Online REINFORCE with reward = Reason; full-rank or higher-rank LoRA vs R3
(r=16 GRPO). Distinct optimizer path on same teacher reward.

## Pod
`mine-r8-reinforce-1` via fleet-rent. 8×B300 prefer. TTL 24h.

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
