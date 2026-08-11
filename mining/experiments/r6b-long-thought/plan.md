# R6b — long-thought vs short-thought ablate

## Axis
Same Tok-init thought-only LoRA as R6, but train on **natural long** `z`
(`z_chars > 180`, non-listy, n=204, med≈245) from `winner_za_high_l1`.
Complement of R6 short≤180 — format-length ablate, not a parent swap.
Keeps original z text (≠ H101 ultrashort rewrite REFUTE).

## Method
Tok af10 init · thought-only LoRA r=16/α32 · lr=5e-6 · **EPOCHS=6**
· merge → n80 vs Tok.
Stack = `s4-h101-f6-short-format` bootstrap with `start_r6b.sh` overlay.

## Pod
`mine-r6-fmt-2` via fleet-rent (queue after R10). 8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2083).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r6b_pipeline.nohup` / `h101_train.nohup`.
