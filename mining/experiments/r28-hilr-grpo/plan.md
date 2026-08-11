# R28 — high-LR Reason-GRPO (isolate lr)

## Axis
Same Tok-init + teacher-Reason GRPO as R3, different **learning rate**:
- `lr=2e-5` (R3 uses 5e-6; R3b uses 2e-5 *with* r=64 and G=8)
Same r=16/α32, G=4, temp=0.8, max_len=6144, max_new=512 as R3 —
isolates LR (≠ R3b which confounds lr with rank+G), not longctx (≠ R24),
not temp (≠ R25/R26), not G (≠ R27), not a board-parent swap (≠ R18–R23).

Claim: a higher LR alone moves mean Reason farther per step than R3's 5e-6
without needing the R3b rank/G swap.

## Pod
`mine-r28-hilr-1` via fleet-rent (queue after R27, before parent-swap axes).
8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2102).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r28_pipeline.nohup` / `r3_train.nohup` (`[r3-hb]`).
