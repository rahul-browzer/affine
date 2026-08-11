# R6 — thought-format for teacher Reason

## Axis
Shape `z_A` length/structure so teacher
`lpC(y_C|z) − lpC(y_C|∅)` rises. Format-only; not a board-copy merge.

**This cell (p2075):** natural short non-listy filter (`z_chars ≤ 180`,
n=202, med≈103) from `winner_za_high_l1` — keeps original z text.
**Not** H101 ultrashort≤80 rewrite (REFUTE Λ2 flat 2026-08-08).

## Method
Tok af10 init · thought-only LoRA r=16/α32 · lr=5e-6 · **EPOCHS=6**
(≈150 opt-steps on 202 rows @ grad_accum=8) · merge → n80 vs Tok.
Stack = `s4-h101-f6-short-format` bootstrap with `start_r6.sh` overlay.

## Pod
`mine-r6-fmt-1` via fleet-rent. 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot wired p2075).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
