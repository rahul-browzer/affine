# HYPOTHESES — Reason v3
**Cap 120 lines.** Ranked table + ≤4 lines each. S\* hypotheses → `archive/legacy-sstar-v2/`.

## Ranked

| # | id | claim | status |
|---|---|---|---|
| 1 | R1 | Teacher-ref SFT / distill on current king init raises Reason margin > 3·SE | **weak** — R1 +0.0005; R1b train+merge **DONE**; n80 **~10/80** |
| 2 | R2 | Merge / continue-train recent kings for teacher-helpful z | **open** — premerge **DONE** max_abs_delta=0.277; α→n80 armed (waits R1) |
| 3 | R3 | Directly optimize / RL a reward = Reason (teacher lp delta) | **open** — after a clear R1 win |

## Open

### R1 — Distill thoughts that raise teacher lp(y_C)
- **Claim:** train (or select) `z` to maximize Reason; king-init LoRA/SFT is enough to clear 3·SE once L1/gates are gone.
- **Prediction (pre-register):** n80 paired margin > 3·SE vs live king on first serious screen.
- **Status:** weak / R1b n80 running. R1 LoRA@8192 → margin **+0.000516** (z=0.105). R1b: train **DONE** 19:35Z (max_len=16384, 1006 rows); merge+graft **DONE** 19:38Z; chall reloaded `/tmp/r1b_lora_merged`; n80 pid92752 @ chall~10/king~9 (slice `b6a1f946…`). Waiter 80760 → `r1b_lora_decision.json`. R1c chain armed (83033) if headroom < 1.5×. HF `r1lora@569a68be` not for submit.
- **Dir:** `experiments/r1-reason-distill/`.

### R2 — Multi-king merge aimed at Reason
- **Claim:** weight-space mix of high-Reason parents beats single king-init SFT.
- **Prediction:** margin > R1 on same slice family; submit only if ≥ **1.5 × (3·SE)** vs Tok.
- **Status:** open / premerge harvested. Equal-α Tok×Talent×kevin @ `/root/r2_out/alpha_tok_talent_kevin`: **max_abs_delta=0.27734375**, n_keys=1026, 66 GiB, identical_frac=0.439 (not weight-identical). Stamp `/root/logs/r2_premerge.done`. α→n80 waiter pid **85408** waiting R1 lane. Dir: `experiments/r2-multiking-merge/`.

### R3 — RL on Reason
- **Claim:** REINFORCE/GRPO with reward = teacher Reason on sampled z beats SFT.
- **Status:** open — after simulator is solid.

## Refuted (Reason era)
*(none yet)*

## Do not reopen from S\* legacy
Clip-L1 shaping, r∈[0.7,0.85], α-merge lotteries, king-watch, "don't raise Λ2", submit-gate 0.04 as research kill — all S\* v2. See archive if curious; do not schedule them.
