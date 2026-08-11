# R31 — zero-dropout Reason-GRPO (isolate LoRA dropout)

## Axis
Same Tok-init + teacher-Reason GRPO as R3, different **LoRA dropout**:
- `lora_dropout=0.0` (R3 hardcodes / defaults **0.05**)
Same lr=5e-6, r=16, α=32, G=4, temp=0.8, max_len=6144, max_new=512 as R3 —
isolates adapter dropout alone (≠ R24–R30 knobs, ≠ R3b bundle, ≠ R18–R23
parent-swap).

Claim: removing LoRA dropout lets the adapter fit teacher-helpful thoughts
farther than R3's 0.05 regularizer (mean Reason up).

## Pod
`mine-r31-nodrop-1` via fleet-rent (queue after R30, before parent-swap axes).
8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2107).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r31_pipeline.nohup` / `r3_train.nohup` (`[r3-hb]`).
