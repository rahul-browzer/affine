# R7 — high-Reason data filter curriculum

## Axis
Tok-init full-FT on **top-250** h99 rows by Reason (`lambda2` = lpC(y_C|z)−lpC(y_C|∅)),
EPOCHS=2. Distinct from R4 (clip_l1 n=406, EPOCHS=1) and R3 GRPO sampling.

## Data
`results/winner_za_top_reason.jsonl` — min_reason≈0.116, mean≈0.174 (p2076).
Source: `s4-h99-f2-target-l2/results/winner_za_high_l2.jsonl` (n=1059).

## Pod
`mine-r7-datafilt-1` via fleet-rent. 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (H121 stack + `start_r7.sh` overlay).
Fleet-boot case wired p2076.

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
