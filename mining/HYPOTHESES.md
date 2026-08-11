# HYPOTHESES — Reason v3
**Cap 120 lines.** Ranked table + ≤4 lines each. S\* hypotheses → `archive/legacy-sstar-v2/`.

## Ranked

| # | id | claim | status |
|---|---|---|---|
| 1 | R1 | Teacher-ref SFT / distill on current king init raises Reason margin > 3·SE | **REFUTED family** — R1 +0.0005; R1b −0.0135; **R1c −0.0171** (z=−2.75) |
| 2 | R2 | Merge / continue-train recent kings for teacher-helpful z | **open** — **R2ax** tt n80 ~46/80; **R2ay/R2az** armed; **v10** cached `@07bc3392` |
| 3 | R3 | Directly optimize / RL a reward = Reason (teacher lp delta) | **open — PRIORITY** · p2068: GRPO pid**23755** step≥25; king@65536; post_train armed |
| 4 | R4 | Full-FT (not LoRA) on high-Reason winner_za / Tok-init | **open** · fleet queue head `mine-r4-fullft-1` (B300×8=0) |
| 5 | R5 | Non-king base (Genesis/Qwen) + Reason FT beats Tok-init | **open** · fleet `mine-r5-nonking-1` |
| 6 | R6 | Thought-format shaping raises teacher Reason | **open** · fleet `mine-r6-fmt-1` |
| 7 | R7 | High-Reason data-filter curriculum FT | **open** · fleet `mine-r7-datafilt-1` |
| 8 | R8 | REINFORCE on Reason (alt to LoRA-GRPO) | **open** · fleet `mine-r8-reinforce-1` |

## Open

### R1 — Distill thoughts that raise teacher lp(y_C)
- **Claim:** train (or select) `z` to maximize Reason; king-init LoRA/SFT is enough to clear 3·SE once L1/gates are gone.
- **Prediction (pre-register):** n80 paired margin > 3·SE vs live king on first serious screen.
- **Status:** **family closed.** R1 +0.0005; R1b −0.0135 (z=−2.45); **R1c** nsup≥100 EPOCHS=6 → margin **−0.01707** (z=−2.75, hr −0.92×, n_paired=67) — worse than R1b. Artifacts: `artifacts/r1c_lora_{decision,reason_sim}.json`.
- **Dir:** `experiments/r1-reason-distill/`.

### R2 — Multi-king merge aimed at Reason
- **Claim:** weight-space mix of high-Reason parents beats single king-init SFT.
- **Prediction:** margin > R1 on same slice family; submit only if ≥ **1.5 × (3·SE)** vs Tok.
- **Status:** open. **R2d** 0.22×; many Talent-skew REFUTEs (e/g/h/q/t/l/n/o/p/r/ab/ac/ad/**am −1.39×**). **R2an SKIP_BOARD** cp13. **R2ao REFUTE** af17 **−0.074×**. **R2ap WEAK_SKIP** h44 **0.327×**. **R2aq WEAK_SKIP** pure-now **0.773×**. **R2ar SKIP_UNSERVABLE** iynocr2p (cache purged p2066). **R2as WEAK_SKIP** pure-726. **R2at WEAK_SKIP** hope11 hr **0.97×**. **R2au REFUTE** sft4. **R2av REFUTE** Bittoby-v2. **R2ax** tt n80 ~34/80. **R2ay** sbs-v2 armed. **R2az** vvv armed. **v10** prefetch `0pentensor/…-awesome-v10@07bc3392` (chal-00498). Host-hist→504. Dir: `experiments/r2-multiking-merge/`.

### R3 — RL on Reason
- **Claim:** REINFORCE/GRPO with reward = teacher Reason on sampled z beats SFT.
- **Status:** open — GRPO pid**23755** (p2063 relaunch); step≥25 (mean_r oscillates; step20≈0.044). King@**65536**. Next = train.done → merge → chall → n80.

### R4 — Full-FT on Reason
- **Claim:** full-parameter FT on high-Reason winner thoughts beats LoRA-GRPO / board-copy screens on paired margin.
- **Status:** open — fleet-rent queue head `mine-r4-fullft-1` (pid**2146782**, target 13 mines). Bootstrap after `fleet-rent/artifacts/rented_mine-r4-fullft-1.json`. Dir: `experiments/r4-fullft-reason/`.

### R5–R8 — fleet axes (armed p2068)
- **R5** non-king base · **R6** thought-format · **R7** data-filter · **R8** REINFORCE — plans under `experiments/r{5..8}-*/`; pods via `experiments/fleet-rent/wait_fleet_b300.sh`.

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
- **R2ab** (2026-08-11): Talent0.25×sky0.75 → margin **−0.0508** vs Tok (z=−4.76, hr **−1.59×**, n=77). Board sky ~0.46× does not crown via Talent skew; Stage-5 SKIP; blend purged.
- **R2ac** (2026-08-11): Talent0.25×google0.75 → margin **−0.03126** vs Tok (z=−2.94, hr **−0.978×**, n=80). Pure-parent local 0.641× does not transfer via Talent skew; Stage-5 SKIP; blend purged.
- **R2ad** (2026-08-11): Talent0.25×pig0.75 → margin **−0.03694** vs Tok (z=−3.54, hr **−1.18×**, n=80). Board pig 0.58× does not crown via Talent skew; Stage-5 SKIP; blend purged.
- **R2am** (2026-08-11): Talent0.25×sbs-v1:0.75 n80#2 → margin **−0.04052** vs Tok (z=−4.18, hr **−1.39×**, n=80). Stage-5 SKIP; blend purged.
- **R2ao** (2026-08-11): pure Tok af17 → margin **−0.00072** vs Tok af10 (z=−0.22, hr **−0.074×**, n=80). Near-parity, not crown; Stage-5 SKIP → R2ap h44.
- **R2ap** (2026-08-11): pure kevin954 h44 → margin **+0.00414** vs Tok (z=0.98, hr **0.327×**, n=80). Weak positive ≪1.5×; Stage-5 SKIP → R2aq now.
- **R2aq** (2026-08-11): pure tojointhecommunity …-now → margin **+0.00795** vs Tok (z=2.32, hr **0.773×**, n=80). Best pure signal yet; clears live 2·SE (1.16×) but not submit bar; Stage-5 SKIP → R2ar iynocr2p.
- **R2aw** (2026-08-11): chal-00494 mt1 **unservable** (`Glm4MoeForCausalLM`, ~59 GiB, no visual) — SKIP before prefetch; not Qwen3.5 MoE VLM.
- **R2ar** (2026-08-11): chal-00490 iynocr2p **unservable** — index lists 1026 keys but shards miss 50 (shard00002: 0/50 claimed keys present). vLLM "weights were not initialized"; SKIP; do not re-sim.
- **R2av** (2026-08-11): pure Bittoby1040 `…-v2` → margin **−0.00027** vs Tok (z=−0.065, hr_live2σ **−0.033×**, n=80). King-noise; Stage-5 SKIP → R2ax tt.

## Do not reopen from S\* legacy
Clip-L1 shaping, r∈[0.7,0.85], α-merge lotteries, king-watch, "don't raise Λ2", submit-gate 0.04 as research kill — all S\* v2. See archive if curious; do not schedule them.
