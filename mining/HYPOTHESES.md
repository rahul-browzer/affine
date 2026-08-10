# HYPOTHESES — Reason v3
**Cap 120 lines.** Ranked table + ≤4 lines each. S\* hypotheses → `archive/legacy-sstar-v2/`.

## Ranked

| # | id | claim | status |
|---|---|---|---|
| 1 | R1 | Teacher-ref SFT / distill on current king init raises Reason margin > 3·SE | **weak/refuted variants** — R1 +0.0005; **R1b REFUTE −0.0135**; R1c train **~88/132** |
| 2 | R2 | Merge / continue-train recent kings for teacher-helpful z | **open** — R2/R2b/R2c wait; **R2d pure awesome-v6** n80 waiter **104051** |
| 3 | R3 | Directly optimize / RL a reward = Reason (teacher lp delta) | **open** — after a clear R1 win |

## Open

### R1 — Distill thoughts that raise teacher lp(y_C)
- **Claim:** train (or select) `z` to maximize Reason; king-init LoRA/SFT is enough to clear 3·SE once L1/gates are gone.
- **Prediction (pre-register):** n80 paired margin > 3·SE vs live king on first serious screen.
- **Status:** R1 LoRA@8192 → +0.000516 (noise). **R1b** @16384/1006rows → **REFUTE** margin **−0.01349** (z=−2.45, headroom −0.82×, n_paired=75) — longer-ctx SFT hurt vs Tok. R1c (nsup≥100, EPOCHS=6) **~88/132** training; merge/R2 waiters armed; HF ~423 GiB purged for Stage-5 push. Artifacts: `artifacts/r1b_lora_{decision,reason_sim}.json`.
- **Dir:** `experiments/r1-reason-distill/`.

### R2 — Multi-king merge aimed at Reason
- **Claim:** weight-space mix of high-Reason parents beats single king-init SFT.
- **Prediction:** margin > R1 on same slice family; submit only if ≥ **1.5 × (3·SE)** vs Tok.
- **Status:** open. R2 equal-α Talent/kevin waiter **99246**; R2b equal-α Tok×awesome **DONE** Δ=0.006 n80 **101161**. **R2c** skew PREMERGE DONE Δ=0.009 n80 **102560**. **R2d** pure awesome-v6 chall material + n80 waiter **104051** (waits R2c; tests published hr≈0.92× without Tok dilution). Artifacts: `launch_r2d_awesome_reload_sim.sh`. Dir: `experiments/r2-multiking-merge/`.

### R3 — RL on Reason
- **Claim:** REINFORCE/GRPO with reward = teacher Reason on sampled z beats SFT.
- **Status:** open — after simulator is solid; R1b refute raises urgency if R1c also fails.

## Refuted (Reason era)
- **R1b** (2026-08-10): king-init LoRA @ max_len=16384 on 1006 high-Reason rows → margin −0.0135 vs Tok (z=−2.45). Not a crown path.

## Do not reopen from S\* legacy
Clip-L1 shaping, r∈[0.7,0.85], α-merge lotteries, king-watch, "don't raise Λ2", submit-gate 0.04 as research kill — all S\* v2. See archive if curious; do not schedule them.
