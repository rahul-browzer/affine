# R24 — long-context / full-thought Reason-GRPO

## Axis
Same Tok-init + teacher-Reason GRPO as R3, different **context / thought budget**:
- `max_len=16384` (R3 uses 6144)
- `max_new=1024` (R3 uses 512; live contract `max_thought_tokens=1024`)
Same lr=5e-6, LoRA r=16/α32, G=4 as R3 — not an LR/rank family (≠ R3b)
and not a board-parent swap (≠ R18–R23).

Claim: training at the live thought budget + longer prefixes raises paired
Reason margin vs Tok more than short-ctx R3.

## Pod
`mine-r24-longctx-1` via fleet-rent (queue after R3b, before parent-swap axes).
8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2098).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r24_pipeline.nohup` / `r3_train.nohup` (`[r3-hb]`).
