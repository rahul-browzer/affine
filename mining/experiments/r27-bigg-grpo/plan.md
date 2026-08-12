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
**p2253:** warm-armed on idle TKC `mine-r4-fullft-1` (noble-orbit-9d)
after R19 SIGNAL_POS_BELOW — `warm_arm_on_r4.sh` / `lean_warm_boot.sh`.
Fleet QUEUE skips re-rent of `mine-r27-bigg-1` (next burst = R28).
Full bootstrap still via `upload_and_launch.sh` if a fresh box is needed.

## Decision
n80 vs **live guass** (reign-6); submit iff paired margin > live
`k_sigma · SE` (k=2.0). No 1.5× headroom (operator 2026-08-12).
Watch: `/root/logs/r27_pipeline.nohup` / `r3_train.nohup` (`[r3-hb]`).
