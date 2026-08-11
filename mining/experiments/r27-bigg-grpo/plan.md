# R27 — large-group Reason-GRPO (G=16)

## Axis
Same Tok-init + teacher-Reason GRPO as R3, different **group size**:
- `group_size=16` (R3 uses 4; R3b uses 8 *with* alt lr/rank)
Same lr=5e-6, LoRA r=16/α32, temp=0.8, max_len=6144, max_new=512 as R3 —
isolates G (≠ R3b which confounds G with lr/rank), not longctx (≠ R24),
not temp (≠ R25/R26), not a board-parent swap (≠ R18–R23).

Claim: larger within-prompt sample groups give cleaner teacher-Reason
advantages so LoRA updates move mean Reason farther per step than G=4.

## Pod
`mine-r27-bigg-1` via fleet-rent (queue after R26, before parent-swap axes).
8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2101).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r27_pipeline.nohup` / `r3_train.nohup` (`[r3-hb]`).
