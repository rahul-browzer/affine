# HYPOTHESES — Reason v3
**Cap 120 lines.** Ranked table + ≤4 lines each. S\* hypotheses → `archive/legacy-sstar-v2/`.

## Ranked

| # | id | claim | status |
|---|---|---|---|
| 1 | R1 | Teacher-ref SFT / distill on current king init raises Reason margin > 3·SE | **REFUTED family** — R1 +0.0005; R1b −0.0135; **R1c −0.0171** (z=−2.75) |
| 2 | R2 | Merge / continue-train recent kings for teacher-helpful z | **open** — **R2ay** WEAK (+0.0093, hr_live2σ **1.02×**); **R2az** n80 live; v10 next |
| 3 | R3 | Directly optimize / RL a reward = Reason (teacher lp delta) | **open — PRIORITY** · GRPO pid**28660** steps≥17; wedge-watch pid**2176107**; post_train armed |
| 3b | R3b | GRPO alt-LR/rank (lr=2e-5 r=64 G=8) beats R3 knobs | **open** · fleet `mine-r3-grpo-2` · **p2078** uploader+boot armed |
| 4 | R4 | Full-FT (not LoRA) on high-Reason winner_za / Tok-init | **open** · fleet queue head; **p2069** auto-bootstrap armed |
| 4b | R4b | Full-FT lr/epoch family (lr=5e-6 EPOCHS=2) beats R4 knobs | **open** · fleet `mine-r4-fullft-2` · **p2080** uploader+boot armed |
| 5 | R5 | Non-king base (Genesis/Qwen) + Reason FT beats Tok-init | **open** · fleet `mine-r5-nonking-1` · **p2074** uploader+boot armed |
| 5b | R5b | Talent reign-3 full-FT (≠ Genesis R5) beats Tok-init | **open** · fleet `mine-r5-nonking-2` · **p2081** uploader+boot armed |
| 6 | R6 | Thought-format shaping raises teacher Reason | **open** · fleet `mine-r6-fmt-1` · **p2075** uploader+boot armed |
| 6b | R6b | Long-z (z>180) beats R6 short≤180 on Reason | **open** · fleet `mine-r6-fmt-2` · **p2083** uploader+boot armed |
| 7 | R7 | High-Reason data-filter curriculum FT | **open** · fleet `mine-r7-datafilt-1` · **p2076** uploader+boot armed |
| 8 | R8 | REINFORCE on Reason (alt to LoRA-GRPO) | **open** · fleet `mine-r8-reinforce-1` · **p2077** uploader+boot armed |
| 9 | R9 | Tok LoRA × expanded teacher z_C (format prior) | **open** · fleet `mine-r9-teacher-zc-1` · **p2079** uploader+boot armed |
| 10 | R10 | Tok×sbs-v2 α-merge → Reason-GRPO hybrid | **open** · fleet `mine-r10-merge-rl-1` · **p2082** uploader+boot armed |
| 11 | R11 | Online DPO on live teacher Reason (BT vs frozen base) | **open** · fleet `mine-r11-odpo-1` · **p2084** uploader+boot armed |
| 12 | R12 | Best-of-N CE on live teacher Reason (CE argmax of G=4) | **open** · fleet `mine-r12-bon-1` · **p2085** uploader+boot armed |

## Open

### R1 — Distill thoughts that raise teacher lp(y_C)
- **Claim:** train (or select) `z` to maximize Reason; king-init LoRA/SFT is enough to clear 3·SE once L1/gates are gone.
- **Prediction (pre-register):** n80 paired margin > 3·SE vs live king on first serious screen.
- **Status:** **family closed.** R1 +0.0005; R1b −0.0135 (z=−2.45); **R1c** nsup≥100 EPOCHS=6 → margin **−0.01707** (z=−2.75, hr −0.92×, n_paired=67) — worse than R1b. Artifacts: `artifacts/r1c_lora_{decision,reason_sim}.json`.
- **Dir:** `experiments/r1-reason-distill/`.

### R2 — Multi-king merge aimed at Reason
- **Claim:** weight-space mix of high-Reason parents beats single king-init SFT.
- **Prediction:** margin > R1 on same slice family; submit only if ≥ **1.5 × (2·SE)** vs Tok (live kσ=2).
- **Status:** open. **R2ay** pure sbs-v2 → margin **+0.00930** (z=2.04, hr_live2σ **1.02×**, n=79) — clears 2σ barely, **not** 1.5× submit bar (`SIGNAL_POS_BELOW_3SE` on pod kσ=3). **R2az** vvv n80 launched p2079. **v10** cached. Dir: `experiments/r2-multiking-merge/`.

### R3 — RL on Reason
- **Claim:** REINFORCE/GRPO with reward = teacher Reason on sampled z beats SFT.
- **Status:** open — GRPO pid**28660** live after p2072 force-relaunch. **p2079** step≥17 (`[r3-hb]` mean_r≈0.040). Stream+close HTTP, cached teacher tok, mid-group hb. king@**65536**. Next = steps→train.done→merge→chall→n80.

### R3b — GRPO alt-LR / rank
- **Claim:** same Reason-GRPO as R3 but lr=2e-5, LoRA r=64/α128, G=8 clears paired crown bar where R3's lr=5e-6 r=16 G=4 may not.
- **Status:** open — **p2078** `upload_and_launch.sh` + fleet-boot case for `mine-r3-grpo-2`. Waiting on 8×B300 rent. Dir: `experiments/r3b-grpo-alt/`.

### R4 — Full-FT on Reason
- **Claim:** full-parameter FT on high-Reason winner thoughts beats LoRA-GRPO / board-copy screens on paired margin.
- **Status:** open — fleet-rent queue head `mine-r4-fullft-1` (rent pid**2146782**, boot pid in STATE). On rent, `wait_bootstrap_fleet.sh` runs `upload_and_launch.sh` (H121 full-FT + `winner_za_high_l1`). Dir: `experiments/r4-fullft-reason/`.

### R4b — Full-FT lr/epoch family
- **Claim:** same Tok-init full-FT + winner_za as R4, but lr=**5e-6** + **EPOCHS=2** (R4 is 1e-6×1) clears paired crown bar where R4 may under-train.
- **Status:** open — **p2080** `upload_and_launch.sh` + fleet-boot case for `mine-r4-fullft-2`. Waiting on 8×B300 rent. Dir: `experiments/r4b-fullft-lr/`.

### R5 — Non-king Genesis full-FT
- **Claim:** Genesis-init dense FT on high-Reason `z_A` beats Tok-init (R4) on paired margin.
- **Status:** open — **p2074** `upload_and_launch.sh` + fleet-boot case for `mine-r5-nonking-1` (H122 stack @ `abe89194`, same `winner_za_high_l1` as R4). Waiting on 8×B300 rent.

### R5b — Talent reign-base full-FT
- **Claim:** TalentPigs reign-3 dense FT on same `winner_za_high_l1` beats Tok-init (R4) and Genesis (R5) on paired margin.
- **Status:** open — **p2081** `upload_and_launch.sh` + fleet-boot case for `mine-r5-nonking-2` (H122 stack + Talent overlays @ `dbfbb3e2`). Waiting on 8×B300 rent. Dir: `experiments/r5b-talent-base/`.

### R6 — Thought-format / short-z
- **Claim:** natural short non-listy `z` (keep original text) raises Reason vs king more than raw/long or H101 rewrite.
- **Status:** open — **p2075** `upload_and_launch.sh` + fleet-boot case for `mine-r6-fmt-1` (H101 stack overlay, EPOCHS=6, n=202 z≤180). ≠ H101 ultrashort rewrite REFUTE. Waiting on 8×B300 rent.

### R6b — long-thought ablate
- **Claim:** natural long non-listy `z` (z>180, n=204, med≈245) raises Reason more than R6 short≤180 on same Tok-init LoRA knobs.
- **Status:** open — **p2083** `upload_and_launch.sh` + fleet-boot case for `mine-r6-fmt-2` (H101 overlay `start_r6b.sh`). Data: `results/za_long_natural.jsonl`. Waiting on 8×B300 rent. Dir: `experiments/r6b-long-thought/`.

### R7 — top-Reason data-filter curriculum
- **Claim:** full-FT on top-250 h99 rows by Reason (min≈0.116, mean≈0.174, EPOCHS=2) beats R4's broader clip_l1 set on paired margin.
- **Status:** open — **p2076** `upload_and_launch.sh` + fleet-boot case for `mine-r7-datafilt-1` (H121 overlay `start_r7.sh`). Data: `results/winner_za_top_reason.jsonl`. Waiting on 8×B300 rent.

### R8 — EMA REINFORCE (alt to GRPO)
- **Claim:** classic REINFORCE with EMA baseline + LoRA r=64 beats R3 group-mean GRPO (G=4,r=16) on paired Reason margin.
- **Status:** open — **p2077** `upload_and_launch.sh` + fleet-boot case for `mine-r8-reinforce-1` (train `train_reason_reinforce.py`, lr=1e-5, max_steps=300). Waiting on 8×B300 rent. Dir: `experiments/r8-reinforce-reason/`.

### R9 — Tok LoRA × expanded teacher z_C
- **Claim:** thought-only LoRA on **expanded** teacher_refs (1329; not shortz) teaches teacher-shaped z that raises Reason vs Tok; ≠ H102/H123/R1.
- **Prediction:** n80 paired margin ≥ **1.5 × (2·SE)** vs Tok.
- **Status:** open — **p2079** `upload_and_launch.sh` + fleet-boot case for `mine-r9-teacher-zc-1` (H99 stack overlay; r=32/α64 lr=1e-5 EPOCHS=3 max_len=16384). Waiting on 8×B300 rent. Dir: `experiments/r9-teacher-zc/`.

### R10 — merge + Reason-GRPO hybrid
- **Claim:** Tok×sbs-v2 α0.5 merge as GRPO init beats Tok-init GRPO (R3) and merge-only n80 (R2) on paired Reason margin.
- **Prediction:** n80 paired margin ≥ **1.5 × (2·SE)** vs Tok after merge→GRPO.
- **Status:** open — **p2082** `upload_and_launch.sh` + fleet-boot case for `mine-r10-merge-rl-1`. Waiting on 8×B300 rent. Dir: `experiments/r10-merge-rl/`.

### R11 — Online DPO on teacher Reason
- **Claim:** sample G=2 z from Tok-LoRA, label with live teacher Reason, DPO (β=0.1) vs frozen base clears paired crown bar where GRPO/REINFORCE/offline-DPO may stall.
- **Prediction:** n80 paired margin ≥ **1.5 × (2·SE)** vs Tok.
- **Status:** open — **p2084** `upload_and_launch.sh` + fleet-boot case for `mine-r11-odpo-1` (H139 stack overlay; S\* F44 abandoned mid-n80, never Reason-v3 decision). Waiting on 8×B300 rent. Dir: `experiments/r11-online-dpo/`.

### R12 — Best-of-N CE on teacher Reason
- **Claim:** sample G=4 z, CE only the argmax teacher-Reason thought — moves mean more than GRPO/REINFORCE when group rewards cluster.
- **Prediction:** n80 paired margin ≥ **1.5 × (2·SE)** vs Tok.
- **Status:** open — **p2085** `upload_and_launch.sh` + fleet-boot case for `mine-r12-bon-1` (H137 `train_bon_l2.py` overlay). Waiting on 8×B300 rent. Dir: `experiments/r12-bon-reason/`.

## Refuted (Reason era)
- Older Talent-skew / board-parent REFUTEs (R2h–R2am family) → `archive/` / prior status.log; do not re-blend.
- **R1b** (2026-08-10): king-init LoRA @ max_len=16384 on 1006 high-Reason rows → margin −0.0135 vs Tok (z=−2.45). Not a crown path.
- **R1c** (2026-08-10): nsup≥100 filter (176 rows) + EPOCHS=6 → margin −0.0171 vs Tok (z=−2.75, n_paired=67). High-signal subset SFT still hurts Reason.
- **R2ao** (2026-08-11): pure Tok af17 → margin **−0.00072** vs Tok af10 (z=−0.22, hr **−0.074×**, n=80). Near-parity, not crown; Stage-5 SKIP → R2ap h44.
- **R2ap** (2026-08-11): pure kevin954 h44 → margin **+0.00414** vs Tok (z=0.98, hr **0.327×**, n=80). Weak positive ≪1.5×; Stage-5 SKIP → R2aq now.
- **R2aq** (2026-08-11): pure tojointhecommunity …-now → margin **+0.00795** vs Tok (z=2.32, hr **0.773×**, n=80). Best pure signal yet; clears live 2·SE (1.16×) but not submit bar; Stage-5 SKIP → R2ar iynocr2p.
- **R2aw** (2026-08-11): chal-00494 mt1 **unservable** (`Glm4MoeForCausalLM`, ~59 GiB, no visual) — SKIP before prefetch; not Qwen3.5 MoE VLM.
- **R2ar** (2026-08-11): chal-00490 iynocr2p **unservable** — index lists 1026 keys but shards miss 50 (shard00002: 0/50 claimed keys present). vLLM "weights were not initialized"; SKIP; do not re-sim.
- **R2av** (2026-08-11): pure Bittoby1040 `…-v2` → margin **−0.00027** vs Tok (z=−0.065, hr_live2σ **−0.033×**, n=80). King-noise; Stage-5 SKIP → R2ax tt.
- **R2ay** (2026-08-11): pure sbs-v2 → margin **+0.00930** vs Tok (z=2.04, hr_live2σ **1.02×**, n=79). Weak positive; Stage-5 SKIP → R2az vvv.

## Do not reopen from S\* legacy
Clip-L1 shaping, r∈[0.7,0.85], α-merge lotteries, king-watch, "don't raise Λ2", submit-gate 0.04 as research kill — all S\* v2. See archive if curious; do not schedule them.
