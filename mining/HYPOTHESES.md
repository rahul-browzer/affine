# HYPOTHESES — Reason v3
**Cap 120 lines.** Ranked table + ≤4 lines each. S\* hypotheses → `archive/legacy-sstar-v2/`.

## Ranked

| # | id | claim | status |
|---|---|---|---|
| 1 | R1 | Teacher-ref SFT / distill on current king init raises Reason margin > 3·SE | **REFUTED family** — R1 +0.0005; R1b −0.0135; **R1c −0.0171** (z=−2.75) |
| 2 | R2 | Merge / continue-train recent kings for teacher-helpful z | **open** — **R2d** 0.22×; **R2e/g/h/q/t/l/n/o/p/r REFUTE**; **R2ag REFUTE −0.52×**; **R2j/i/k SKIP**; **R2s/R2u WEAK_SKIP**; **R2v** 0.39×; **R2w** board-skip 0.40×; **R2ae SKIP_GATED**; **R2af/R2x SKIP_BOARD** v8; **R2y SKIP_UNSERVABLE**; **R2ah/R2z SKIP_BOARD** v9 hr0.21×; **R2ai RESET**; **R2aj SKIP_BOARD** sky hr0.459×; **R2ak** local **0.641×** / board470 **0.094×**; **R2al SKIP_BOARD** 471 hr**0.580×**; **R2ab** n80 ~67/80; **R2ac** wait R2ab; **R2ad** premerge DONE Δ0.626 wait R2ac; **R2am** Talent×sbs-v1 EAGER (gate 480); **R2aa** stubbed |
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
- **Status:** open. Weak Tok/kevin×awesome / saysth×awesome / **saysth×kevin** lanes SKIPPED (Δ≪0.01). **R2d** hr **0.22×**. **R2e/g/h/q/t/l/n/o/p/r REFUTED**. **R2ag** pure tpc9 **REFUTE −0.52×** (p1992). **R2j/i/k SKIPPED**. **R2s/R2u WEAK_SKIP**. **R2v** pure sft3 local hr **0.39×**. **R2w** asdf **SKIP_BOARD** 0.40×. **R2ae** sth **SKIP_GATED**. **R2af/R2x SKIP_BOARD** v8. **R2y SKIP_UNSERVABLE** (463). **R2ah/R2z SKIP_BOARD** chal-00467 v9 hr **0.21×**. **R2ai SKIP_BOARD** chal-00468 sbs-v0 hr **0.018×**. **R2aj SKIP_BOARD** chal-00469 sky hr **0.459×**. **R2ak** pure google local hr **0.641×**; board chal-00470 hr **0.094×**. **R2al SKIP_BOARD** (p2014): local ABORT@70/80; board 471 pig hr **0.580×**. **R2ab** Talent×sky n80 **RUNNING** ~67/80. **R2ac** wait R2ab (holding-stamp yield). **R2ad** Talent×pig Δ=**0.626** waits R2ac. **R2am** (p2016) Talent×sbs-v1 EAGER α-merge CPU; DONE gated on chal-00480 Reason+. **R2aa** stubbed. Dir: `experiments/r2-multiking-merge/`.

### R3 — RL on Reason
- **Claim:** REINFORCE/GRPO with reward = teacher Reason on sampled z beats SFT.
- **Status:** open — after simulator is solid; R1b refute raises urgency if R1c also fails.

## Refuted (Reason era)
- **R1b** (2026-08-10): king-init LoRA @ max_len=16384 on 1006 high-Reason rows → margin −0.0135 vs Tok (z=−2.45). Not a crown path.
- **R1c** (2026-08-10): nsup≥100 filter (176 rows) + EPOCHS=6 → margin −0.0171 vs Tok (z=−2.75, n_paired=67). High-signal subset SFT still hurts Reason.
- **R2h** (2026-08-11): Tok×Talent×kevin equal-α (Δ=0.277) → margin −0.0211 vs Tok (z=−1.77, hr −0.59×, n=60). Multi-reign equal-α does not clear 3·SE.
- **R2g** (2026-08-11): Talent0.25×saysth0.75 (parent 440 hr 0.73×) → margin −0.0203 vs Tok (z=−2.67, hr −0.89×, n=79). Parent Reason+ does not transfer through skew-α.
- **R2q** (2026-08-11): pure saysth-v9a local n80 → margin −0.00657 vs Tok (z=−1.05, hr −0.35×, n=79). Published 440 hr 0.73× does not replay as crown candidate on our slice.
- **R2t** (2026-08-11): saysth0.75×Talent0.25 (saysth layout, Δ=0.207) → margin **−0.02341** vs Tok (z=−2.80, hr **−0.93×**, n=78). Inverse of R2g also loses; do not re-blend saysth×Talent.
- **R2l** (2026-08-11): Talent0.25×sft3:0.75 → margin **−0.03068** vs Tok (z=−2.67, hr **−0.89×**, n=79). Parent board/local ~0.37–0.39× does not lift via Talent skew; Stage-5 SKIP.
- **R2n** (2026-08-11): Talent0.25×asdf:0.75 → margin **−0.02323** vs Tok (z=−3.21, hr **−1.07×**, n=80). Board parent 0.40× does not crown via Talent skew; Stage-5 SKIP; blend purged.
- **R2o** (2026-08-11): Talent0.25×zeus:0.75 → margin **−0.02860** vs Tok (z=−3.31, hr **−1.10×**, n=79). Board parent 0.25× does not crown via Talent skew; Stage-5 SKIP; blend purged.
- **R2p** (2026-08-11): Talent0.25×sth:0.75 → margin **−0.02821** vs Tok (z=−2.78, hr **−0.93×**, n=80). Board parent 0.79× (best DL Reason+) does not crown via Talent skew; Stage-5 SKIP; blend purged.
- **R2r** (2026-08-11): Talent0.25×whoami:0.75 → margin **−0.03351** vs Tok (z=−4.29, hr **−1.43×**, n=80). Board parent 0.39× does not crown via Talent skew; Stage-5 SKIP; blend purged.
- **R2af/R2x** (2026-08-11): board chal-00462 awesome-v8 hr **−0.04×** → SKIP pure-v8 n80 + Talent×v8 (no local gather).
- **R2y** (2026-08-11): chal-00463 tpc9 **unservable** (vLLM load fail) → hr=None → SKIP Talent×tpc9 + purge blend; local R2ag n80 still runs.
- **R2ag** (2026-08-11): pure tpc9 local n80 → margin **−0.0105** (z=−1.56, hr **−0.52×**, n=79). Board-unservable parent also loses locally; Stage-5 SKIP.
- **R2ah/R2z** (2026-08-11): board chal-00467 awesome-v9 hr **0.21×** → SKIP pure-v9 n80 mid-load + Talent×v9 (R2w sub-1.5× board-first).

## Do not reopen from S\* legacy
Clip-L1 shaping, r∈[0.7,0.85], α-merge lotteries, king-watch, "don't raise Λ2", submit-gate 0.04 as research kill — all S\* v2. See archive if curious; do not schedule them.
