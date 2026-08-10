# HYPOTHESES — Reason v3
**Cap 120 lines.** Ranked table + ≤4 lines each. S\* hypotheses → `archive/legacy-sstar-v2/`.

## Ranked

| # | id | claim | status |
|---|---|---|---|
| 1 | R1 | Teacher-ref SFT / distill on current king init raises Reason margin > 3·SE | **weak** — R1 +0.0005; R1b **16/126**; R1c nsup≥100 set **ready** (176 rows) |
| 2 | R2 | Merge / continue-train recent kings for teacher-helpful z | **open** |
| 3 | R3 | Directly optimize / RL a reward = Reason (teacher lp delta) | **open** — after a clear R1 win |

## Open

### R1 — Distill thoughts that raise teacher lp(y_C)
- **Claim:** train (or select) `z` to maximize Reason; king-init LoRA/SFT is enough to clear 3·SE once L1/gates are gone.
- **Prediction (pre-register):** n80 paired margin > 3·SE vs live king on first serious screen.
- **Status:** weak / R1b in flight. R1 LoRA@8192 → margin **+0.000516** (z=0.105). R1b: max_len=16384 kept **1006/1403** but thought-nsup med **54** (only 176≥100) — likely why R1 was noise; train **16/126** @~34s/it; waiter pid80760. R1c data ready: `sft_high_reason_nsup100.jsonl` (176 rows, nsup_med=137). HF `r1lora@569a68be` not for submit.
- **Dir:** `experiments/r1-reason-distill/`.

### R2 — Multi-king merge aimed at Reason
- **Claim:** weight-space mix of high-Reason parents beats single king-init SFT.
- **Prediction:** margin > R1 on same slice family.
- **Status:** open — after R1 baseline.

### R3 — RL on Reason
- **Claim:** REINFORCE/GRPO with reward = teacher Reason on sampled z beats SFT.
- **Status:** open — after simulator is solid.

## Refuted (Reason era)
*(none yet)*

## Do not reopen from S\* legacy
Clip-L1 shaping, r∈[0.7,0.85], α-merge lotteries, king-watch, "don't raise Λ2", submit-gate 0.04 as research kill — all S\* v2. See archive if curious; do not schedule them.
