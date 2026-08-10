# HYPOTHESES — Reason v3
**Cap 120 lines.** Ranked table + ≤4 lines each. S\* hypotheses → `archive/legacy-sstar-v2/`.

## Ranked

| # | id | claim | status |
|---|---|---|---|
| 1 | R1 | Teacher-ref SFT / distill on current king init raises Reason margin > 3·SE | **open** — LoRA n80 live @65536 (chall~4/king~6 @17:39Z) → await `r1_lora_decision.json` |
| 2 | R2 | Merge / continue-train recent kings for teacher-helpful z | **open** |
| 3 | R3 | Directly optimize / RL a reward = Reason (teacher lp delta) | **open** — after R1 sim works |

## Open

### R1 — Distill thoughts that raise teacher lp(y_C)
- **Claim:** train (or select) `z` to maximize Reason; king-init LoRA/SFT is enough to clear 3·SE once L1/gates are gone.
- **Prediction (pre-register):** n80 paired margin > 3·SE vs live king on first serious screen.
- **Status:** open. Engines 200@65536; LoRA n80 pid76726 progressing (chall 4/80, king 6/80 @17:39Z); no ctx errors yet; decision pending.
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
