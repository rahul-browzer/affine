# R6 — thought-format for teacher Reason

## Axis
Shape `z_A` length/structure so teacher
`lpC(y_C|z) − lpC(y_C|∅)` rises. Format-only; not a board-copy merge.

**This cell (p2075):** natural short non-listy filter (`z_chars ≤ 180`,
n=202, med≈103) from `winner_za_high_l1` — keeps original z text.
**Not** H101 ultrashort≤80 rewrite (REFUTE Λ2 flat 2026-08-08).

## Method
Tok af10 init · thought-only LoRA r=16/α32 · lr=5e-6 · **EPOCHS=6**
· **max_len=16384** (p2126: 8192 kept 33/202; 16384→121/202) · merge → n80 vs Tok.
Stack = `s4-h101-f6-short-format` bootstrap with `start_r6.sh` overlay.

## Pod
**Live p2126:** retargeted onto `mine-r4-fullft-1` (R5 REFUTE closed; B300×8=0).
Fleet-rent next = `mine-r7-datafilt-1` (do not re-rent R6).
Uploader: `upload_and_launch.sh` (fleet-boot wired p2075).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
