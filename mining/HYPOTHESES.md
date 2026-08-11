# HYPOTHESES — Reason v3
**Cap 120 lines.** Ranked table + ≤4 lines each. S\* hypotheses → `archive/legacy-sstar-v2/`.

## Ranked

| # | id | claim | status |
|---|---|---|---|
| 1 | R1 | Teacher-ref SFT / distill on current king init raises Reason margin > 3·SE | **REFUTED family** — R1 +0.0005; R1b −0.0135; **R1c −0.0171** (z=−2.75) |
| 2 | R2 | Merge / continue-train recent kings for teacher-helpful z | **open** — **R2d** 0.22×; **R2e/g/h REFUTE**; **R2j/i SKIP**; **R2s WEAK_SKIP**; **440 saysth** 0.73×; **R2q ~58/80**; **R2t** saysth×Talent Δ=**0.207** armed; **R2k…p/R2r** armed |
| 3 | R3 | Directly optimize / RL a reward = Reason (teacher lp delta) | **open** — after a clear R1 win |

## Open

### R1 — Distill thoughts that raise teacher lp(y_C)
- **Claim:** train (or select) `z` to maximize Reason; king-init LoRA/SFT is enough to clear 3·SE once L1/gates are gone.
- **Prediction (pre-register):** n80 paired margin > 3·SE vs live king on first serious screen.
- **Status:** **family closed.** R1 +0.0005; R1b −0.0135 (z=−2.45); **R1c** nsup≥100 EPOCHS=6 → margin **−0.01707** (z=−2.75, hr −0.92×, n_paired=67) — worse than R1b. Artifacts: `artifacts/r1c_lora_{decision,reason_sim}.json`.
- **Dir:** `experiments/r1-reason-distill/`.

### R2 — Multi-king merge aimed at Reason
- **Claim:** weight-space mix of high-Reason parents beats single king-init SFT.
- **Prediction:** margin > R1 on same slice family; submit only if ≥ **1.5 × (3·SE)** vs Tok.
- **Status:** open. Weak Tok/kevin×awesome lanes SKIPPED (Δ≪0.01). **R2d** hr **0.22×**. **R2e** Talent×awesome **REFUTED** (hr −1.18×). **R2f** WEAK_SKIP. **R2h** Tok×Talent×kevin equal-α **REFUTED** (hr −0.59×). **chal-00440 saysth** hr **0.73×** — **R2g** Talent×saysth **REFUTED** (hr −0.89×). **R2j** Talent×BKN7 **SKIPPED** (chal-00432 hr **−0.57×**). **R2i** Talent×thomp **SKIPPED** (chal-00441 **unservable**). **R2q** pure saysth-v9a **n80 RUNNING** (~58/80; pid 171850). **R2s** saysth×awesome **WEAK_SKIP** (Δ=1.53e-05). **R2t** saysth0.75×Talent0.25 (saysth layout; inverse R2g) premerge **DONE** Δ=**0.207** · merge waiter armed for post-R2q n80. **R2k…p** Reason+-gated; yield to R2q/R2t. **R2r** Talent×whoami **ARMED** (after R2q+R2t + 458 hr>0). diane/nvidia/aurora gated. Dir: `experiments/r2-multiking-merge/`.

### R3 — RL on Reason
- **Claim:** REINFORCE/GRPO with reward = teacher Reason on sampled z beats SFT.
- **Status:** open — after simulator is solid; R1b refute raises urgency if R1c also fails.

## Refuted (Reason era)
- **R1b** (2026-08-10): king-init LoRA @ max_len=16384 on 1006 high-Reason rows → margin −0.0135 vs Tok (z=−2.45). Not a crown path.
- **R1c** (2026-08-10): nsup≥100 filter (176 rows) + EPOCHS=6 → margin −0.0171 vs Tok (z=−2.75, n_paired=67). High-signal subset SFT still hurts Reason.
- **R2h** (2026-08-11): Tok×Talent×kevin equal-α (Δ=0.277) → margin −0.0211 vs Tok (z=−1.77, hr −0.59×, n=60). Multi-reign equal-α does not clear 3·SE.
- **R2g** (2026-08-11): Talent0.25×saysth0.75 (parent 440 hr 0.73×) → margin −0.0203 vs Tok (z=−2.67, hr −0.89×, n=79). Parent Reason+ does not transfer through skew-α.

## Do not reopen from S\* legacy
Clip-L1 shaping, r∈[0.7,0.85], α-merge lotteries, king-watch, "don't raise Λ2", submit-gate 0.04 as research kill — all S\* v2. See archive if curious; do not schedule them.
