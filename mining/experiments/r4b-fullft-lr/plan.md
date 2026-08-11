# R4b — full-FT lr/epoch family

## Axis
Same Tok-init dense full-FT + `winner_za_high_l1` as R4, different optimizer
budget: lr=**5e-6** (5× R4's 1e-6) and **EPOCHS=2**. Structural LR/epoch
family — not a cosmetic parent swap.

## Pod
`mine-r4-fullft-2` via fleet-rent (queue after R9). 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2080).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r4b_pipeline.nohup` / `h121_train.nohup`.
