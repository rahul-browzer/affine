# R29 — high-rank Reason-GRPO (isolate LoRA r)

## Axis
Same Tok-init + teacher-Reason GRPO as R3, different **LoRA rank**:
- `lora_r=64` / `lora_alpha=128` (R3 uses r=16/α32; R3b uses r=64 *with* lr=2e-5 and G=8)
Same lr=5e-6, G=4, temp=0.8, max_len=6144, max_new=512 as R3 —
isolates rank (≠ R3b which confounds r with lr+G), not HiLR (≠ R28),
not longctx (≠ R24), not temp (≠ R25/R26), not G (≠ R27), not a
board-parent swap (≠ R18–R23).

Claim: a higher LoRA rank alone moves mean Reason farther than R3's r=16
without needing the R3b lr/G swap.

## Pod
`mine-r29-hirank-1` via fleet-rent (queue after R28, before parent-swap axes).
8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2104).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r29_pipeline.nohup` / `r3_train.nohup` (`[r3-hb]`).
