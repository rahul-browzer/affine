# R30 — high-α Reason-GRPO (isolate LoRA alpha)

## Axis
Same Tok-init + teacher-Reason GRPO as R3, different **LoRA α**:
- `lora_r=16` / `lora_alpha=128` (R3 uses r=16/α32 → scale α/r=2;
  R30 keeps r=16, raises α→128 → scale=8)
Same lr=5e-6, G=4, temp=0.8, max_len=6144, max_new=512 as R3 —
isolates α scaling alone (≠ R29 which raises r with α/r held at 2),
not HiLR (≠ R28), not longctx (≠ R24), not temp (≠ R25/R26), not G
(≠ R27), not R3b's lr+r+G bundle, not a board-parent swap (≠ R18–R23).

Claim: a higher LoRA α alone (bigger adapter scale) moves mean Reason
farther than R3's α=32 without needing a rank bump.

## Pod
`mine-r30-hialpha-1` via fleet-rent (queue after R29, before parent-swap axes).
8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2105).

## Decision
n80 vs **live guass** (reign-6); submit iff paired margin > live
`k_sigma · SE` (k=2.0). No 1.5× headroom (operator 2026-08-12).
Watch: `/root/logs/r30_pipeline.nohup` / `r3_train.nohup` (`[r3-hb]`).
