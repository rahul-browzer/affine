# R26 — low-temperature Reason-GRPO

## Axis
Same Tok-init + teacher-Reason GRPO as R3, different **sampling temperature**:
- `temperature=0.5` (R3 / R24 / R3b use 0.8; R25 uses 1.2)
Same lr=5e-6, LoRA r=16/α32, G=4, max_len=6144, max_new=512 as R3 —
not longctx (≠ R24), not lr/rank (≠ R3b), not hitemp (≠ R25), not a
board-parent swap (≠ R18–R23).

Claim: cooler thought sampling concentrates mass on teacher-helpful modes so
within-group Reason advantages are less noisy than temp=0.8 R3 / 1.2 R25.

## Pod
`mine-r26-lotemp-1` via fleet-rent (queue after R25, before parent-swap axes).
8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2100).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r26_pipeline.nohup` / `r3_train.nohup` (`[r3-hb]`).
