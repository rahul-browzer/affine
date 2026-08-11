# R32 — KL-regularized Reason-GRPO (isolate KL coef)

## Axis
Same Tok-init + teacher-Reason GRPO as R3, different **KL vs base**:
- `kl_coef=0.02` (R3 / R24–R31 default **0.0** — no KL term)
Same lr=5e-6, r=16, α=32, drop=0.05, G=4, temp=0.8, max_len=6144,
max_new=512 as R3 — isolates KL alone (≠ R24–R31 knobs, ≠ R3b bundle,
≠ R8 EMA-REINFORCE, ≠ R18–R23 parent-swap).

Claim: a small KL to the frozen base (adapter-disabled) keeps thoughts near
the king prior while still climbing teacher Reason, beating unregularized R3.

## Pod
`mine-r32-kl-1` via fleet-rent (queue after R31, before parent-swap axes).
8×B300 prefer. TTL 24h.
Uploader: `upload_and_launch.sh` (fleet-boot case, pass 2108).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
Watch: `/root/logs/r32_pipeline.nohup` / `r3_train.nohup` (`[r3-hb]`).
Trainer: `--kl-coef` on `train_reason_grpo.py`.
