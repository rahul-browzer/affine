# HYPOTHESES — Reason v3
**Cap 120 lines.** Ranked table + ≤4 lines each. S\* hypotheses → `archive/legacy-sstar-v2/`.

## Ranked

| # | id | claim | status |
|---|---|---|---|
| 1 | R1 | Teacher-ref SFT / distill on current king init raises Reason margin > 3·SE | **REFUTED family** — R1 +0.0005; R1b −0.0135; **R1c −0.0171** (z=−2.75) |
| 2 | R2 | Merge / continue-train recent kings for teacher-helpful z | **open** — live king=**guass** reign6 (p2206); R2bm was guass-as-chall vs ckp333 |
| 3 | R3 | Directly optimize / RL a reward = Reason (teacher lp delta) | **REFUTED** · n80 m=**+0.0094** z=1.33 hr0.66× (p2127) |
| 3b | R3b | GRPO alt-LR/rank (lr=2e-5 r=64 G=8) beats R3 knobs | **REFUTED** · n80 m=**+0.00232** z=0.245 hr0.12× (p2190) |
| 24 | R24 | Tok GRPO max_len=16384 max_new=1024 beats R3 6144/512 | **open — PRIORITY** · train~89 · tmax**96210** · post**96662** n80-gate (p2221) |
| 25 | R25 | Tok GRPO temperature=1.2 beats R3 temp=0.8 | **open** · train~52 + guass :8001 · post**19722** (p2221) |
| 26 | R26 | Tok GRPO temperature=0.5 beats R3 0.8 / R25 1.2 | **open — PRIORITY** · train~76 · post**356966** (p2221) |
| 27 | R27 | Tok GRPO group_size=16 beats R3 G=4 (isolates G vs R3b) | **open** · `mine-r27-bigg-1` · p2101 armed |
| 28 | R28 | Tok GRPO lr=2e-5 beats R3 5e-6 (isolates LR vs R3b) | **open** · `mine-r28-hilr-1` · p2102 armed |
| 29 | R29 | Tok GRPO lora_r=64 beats R3 r=16 (isolates rank vs R3b) | **open** · `mine-r29-hirank-1` · p2104 armed |
| 30 | R30 | Tok GRPO lora_alpha=128 r=16 beats R3 α=32 (isolates α vs R29) | **open** · `mine-r30-hialpha-1` · p2105 armed |
| 31 | R31 | Tok GRPO lora_dropout=0.0 beats R3 drop=0.05 (isolates dropout) | **open** · `mine-r31-nodrop-1` · p2107 armed |
| 32 | R32 | Tok GRPO kl_coef=0.02 vs base beats R3 kl=0 (isolates KL) | **open** · `mine-r32-kl-1` · **p2108** armed |
| 4 | R4 | Full-FT (not LoRA) on high-Reason winner_za / Tok-init | **REFUTED** · n80 m=**−0.0077** z=−0.76 (p2116) |
| 4b | R4b | Full-FT lr/epoch family (lr=5e-6 EPOCHS=2) beats R4 knobs | **REFUTED** · n80 m=**−0.0037** z=−0.58 (p2120) |
| 5 | R5 | Non-king base (Genesis/Qwen) + Reason FT beats Tok-init | **REFUTED** · n80 m=**−0.0390** z=−3.24 (p2125) |
| 5b | R5b | Talent reign-3 full-FT (≠ Genesis R5) beats Tok-init | **open — PRIORITY** · fleet next=`mine-r5-nonking-2` (p2225 guass-armed + prestaged) |
| 6 | R6 | Thought-format shaping raises teacher Reason | **REFUTED** · n80 m=**−0.0006** z=−0.07 hr−0.04× (p2143) |
| 6b | R6b | Long-z (z>180) beats R6 short≤180 on Reason | **REFUTED** · n80 m=**−0.01014** z=−1.23 hr−0.62× (p2151) |
| 7 | R7 | High-Reason data-filter curriculum FT | **REFUTED** · n80 m=**+0.0123** z=1.978 hr0.99× vs ckp333 (p2162) |
| 8 | R8 | REINFORCE on Reason (alt to LoRA-GRPO) | **REFUTED** · n80 m=**−0.0273** z=−1.64 hr−0.82× vs ckp333 (p2158) |
| 9 | R9 | Tok LoRA × expanded teacher z_C (format prior) | **REFUTED** · n80 m=**−0.0172** z=−3.36 hr−1.68× vs ckp333 (p2189) |
| 10 | R10 | Tok×sbs-v2 α-merge → Reason-GRPO hybrid | **BLOCKED** · sbs-v2 index **403** p2224 (p2223 repo_info false OK) |
| 11 | R11 | Online DPO on live teacher Reason (BT vs frozen base) | **REFUTED** · n80 m=**−0.0055** z=−0.82 hr−0.41× vs ckp333 (p2175) |
| 12 | R12 | Best-of-N CE on live teacher Reason (CE argmax of G=4) | **REFUTED** · n80 m=**+0.00085** z=0.06 hr0.03× vs ckp333 (p2188) |
| 13 | R13 | Offline DPO on duel Reason prefs (frozen chosen/rejected) | **REFUTED** · n80 m=**−0.0191** z=−2.86 hr−1.43× vs ckp333 (p2189) |
| 14 | R14 | kevin954-init REINFORCE on teacher Reason | **REFUTED** · n80 m=**−0.0215** z=−1.14 hr−0.57× (p2194) |
| 15 | R15 | pandora-box-init REINFORCE on teacher Reason | **REFUTED** · n80 m=**−0.0268** z=−2.25 hr=−1.12× vs ckp333 (p2205) |
| 16 | R16 | golden-crown-init REINFORCE on teacher Reason | **REFUTED** · n80 m=**−0.00935** z=−1.30 hr=−0.65× vs ckp333 (p2196) |
| 17 | R17 | Qwen3-Coder base + REINFORCE on teacher Reason | **REFUTED** · n80 vs guass m=**−0.0140** z=−0.71 hr**−0.36×** (p2210; n_paired=27) |
| 18 | R18 | Pure sbs-v2-init Reason-GRPO (≠ R3 Tok / R10 merge) | **BLOCKED** · same sbs-v2 **403** p2224 · demoted from fleet QUEUE |
| 19 | R19 | TalentPigs-init Reason-GRPO (≠ R3/R5b/R18) | **open** · `mine-r19-talent-grpo-1` · p2093 armed |
| 20 | R20 | kevin954-init Reason-GRPO (≠ R3/R14 REINFORCE/R19) | **REFUTED** · vs guass n80 m=**−0.0196** z=−2.13 hr=−1.07× (p2211) |
| 21 | R21 | pandora-box-init Reason-GRPO (≠ R3/R15 REINFORCE/R20) | **open — training** · ~step**87** · post**143108** (p2221 n80-gate) |
| 22 | R22 | golden-crown-init Reason-GRPO (≠ R3/R16 REINFORCE/R18–R21) | **open** · `mine-r22-golden-grpo-1` · p2096 armed |
| 23 | R23 | diane613-init Reason-GRPO (≠ R3/R16/R18–R22) | **open** · `mine-r23-diane-grpo-1` · **p2097** armed |

## Open (detail)

### R1 — Distill (family closed)
- R1 +0.0005; R1b −0.0135; **R1c −0.0171** (z=−2.75). Dir: `experiments/r1-reason-distill/`.

### R2 — Multi-king merge
- **R2ba–be** WEAK/UNSERVABLE. **R2bf REFUTE** p2133: n80 m=**−0.00206** z=−0.57 SE=0.00363 hr=−0.19× (dpo2@90ea78ff; chal-00511) → Stage-5 SKIP.
- **R2bg REFUTE** p2140: n80 m=**−0.00191** z=−0.38 SE=0.00507 hr=−0.19× vs live 2·SE (cp1266@68d1daa2; chal-00514) → Stage-5 SKIP.
- **R2bh** live: pure `IntoLayer/Affine-5g94ihdxwu-v1@9b6bc52c…` (chal-00516) chall reload after R2bg; n80 pending. Dir: `experiments/r2-multiking-merge/`.
- **R2bh** IntoLayer n80: m=+0.00378 SE=0.00326 z=1.16; live 2σ thr=0.00651 hr=0.58× → REFUTE p2145.
- **R2bi UNSERVABLE** p2147: thrivepath mt2@22a5d514 arch=`Glm4MoeForCausalLM` — vLLM weight-init fail; skip Glm4Moe board parents.
- **R2bj** vs Tok af10: m=**+0.00427** SE=0.00533 z=0.80 hr0.27×(3σ) / 0.40×(live 2σ) → SIGNAL_POS_BELOW (p2155). Not crown.
- **R2bk REFUTE** p2160: saysth@6e13f365 vs ckp333 m=**+0.00041** SE=0.00324 z=0.13 hr0.06×(live 2σ) → Stage-5 SKIP. Artifacts `r2bk_saysth_ckp333_*.json`.
- **R2bl REFUTE** p2166: Bittoby1040/…-v3@6901350c vs ckp333 n80 m=**−0.00204** SE=0.00425 z=−0.48 hr=−0.24×(live 2σ) → Stage-5 SKIP. Artifacts `r2bl_bittoby_v3_decision.json` / `r2bl_bittoby_v3_result.md`.
- **R2bm REFUTE** p2176: `ttttxxxxsada/…-guass@e86758f5` vs ckp333 n80 m=**−0.00568** SE=0.00381 z=−1.49 hr=−0.74×(live 2σ) → Stage-5 SKIP. Artifacts `r2bm_tttt_guass_decision.json` / `r2bm_tttt_guass_p2176_harvest.json`.
- **R2bn REFUTE** p2186: pure `athena2634/…-alloy` vs ckp333 n80 m=**−0.00733** SE=0.00472 z=−1.55 hr=−0.78×(live 2σ) → Stage-5 SKIP. Artifacts `r2bn_alloy_decision.json` / `r2bn_alloy_p2186_harvest.json`.

### R3 — RL on Reason
- **REFUTED** p2127: n80 m=+0.0094 SE=0.00706 z=1.33 < k=2 (hr0.66×); Stage-5 SKIP. Adapter `/root/r3/train_r3_final`. Dir: `experiments/r3-reason-grpo/`.

### R3b — GRPO alt-LR/rank
- **REFUTED** p2190: n80 m=**+0.00232** SE=0.00945 z=0.245 hr**0.12×**(live 2σ) → Stage-5 SKIP. Dir: `experiments/r3b-grpo-alt/`.

### R4 — Full-FT
- **REFUTED** p2116: n80 m=−0.0077 z=−0.76 (salvage ckpt-26 lr1e-6 ep1). Dir: `experiments/r4-fullft-reason/` + `s4-h121-f26-full-ft/`.

### R4b — Full-FT lr/epoch
- **REFUTED** p2120: n80 m=**−0.0037** z=−0.58 SE=0.0064 (lr5e-6 ep2) — Tok full-FT family closed. Pod retargeted → **R5**. Dir: `experiments/r4b-fullft-lr/`.

### R5 — Non-king Genesis
- **REFUTED** p2125: n80 m=**−0.0390** z=−3.24 SE=0.0120 (hr≪0) — Genesis full-FT vs Tok closed. Retarget `mine-r4-fullft-1` → R6. Dir: `experiments/r5-nonking-base/` + `s4-h122-f27-genesis-full-ft/`.

### R6 / R6b — thought-length format
- **R6 REFUTED** p2143: short≤180 LoRA n80 m=**−0.0006** z=−0.07 SE=0.0088 (hr−0.04×) — Stage-5 SKIP. Dir: `experiments/r6-short-format/`.
- **R6b REFUTED** p2151: natural long-z LoRA n80 m=**−0.01014** z=−1.23 SE=0.00825 (hr−0.62×) — format family closed. Dir: `experiments/r6b-long-thought/`.

### R7 — data-filter curriculum
- **REFUTED** p2162: n80 m=**+0.0123** SE=0.00623 z=1.978 < 2σ (hr_crown 0.99× / submit 0.66×) vs ckp333 — Stage-5 SKIP. Dir: `experiments/r7-data-filter/`.

### R8 — REINFORCE on Reason
- **REFUTED** p2158: n80 m=**−0.0273** SE=0.0167 z=−1.64 hr=−0.82× vs ckp333 — Stage-5 SKIP. Dir: `experiments/r8-reinforce-reason/`.

### R14 — kevin954-init REINFORCE
- **REFUTED** p2194: n80 m=**−0.0215** SE=0.0189 z=−1.14 hr−0.57× vs ckp333. Dir: `experiments/r14-kevin-rl/results/`.

### R15 / R16 / R20 / R24 — PRIORITY
- **R15 REFUTED** p2205: n80 m=**−0.0268** SE=0.0119 z=−2.25 hr=−1.12× vs ckp333 (chall z̄=670 vs king 373). Dir: `experiments/r15-pandora-rl/`.
- **R16** REFUTED p2196. Dir: `experiments/r16-golden-rl/`.
- **R20 REFUTE** vs guass m=−0.0196 z=−2.13 (p2211). Dir: `experiments/r20-kevin-grpo/`.
- **R24** Tok LongCtx-GRPO on `mine-r3` pid**88309** max_len=16384/new=1024 (p2205). Dir: `experiments/r24-longctx-grpo/`.

### R10 / R11 / R12 / R13
- **R10/R18 BLOCKED** p2224: `ammazon/…-sbs-v2@6f1b8e68` `repo_info` public but index **403** — demoted; fleet next=**R5b**.
- **R11 REFUTED** p2175: online-DPO n80 m=**−0.0055** SE=0.00671 z=−0.82 hr−0.41× vs ckp333 (n=76). Stage-5 SKIP.
- **R12 REFUTED** p2188: BoN-CE n80 m=**+0.00085** SE=0.0143 z=0.06 hr0.03× vs ckp333. Stage-5 SKIP.
- **R13 REFUTED** p2189: offline-DPO n80 m=**−0.0191** z=−2.86 hr−1.43× vs ckp333. Stage-5 SKIP.

### R24–R32 — structural GRPO knobs (fleet-queued)
- One isolation each vs R3: R24 max_len=16384/new=1024; R25 temp=1.2; R26 temp=0.5; R27 G=16; R28 lr=2e-5; R29 r=64; R30 α=128; R31 drop=0; R32 kl=0.02. Dirs: `experiments/r24…r32-*-grpo/`.

### Fleet axes waiting on 8×B300
- Live: **R24** R3 · **R21** R4 · **R25**/R26 B200. Queue: **R5b** → R19 → R22 → R23 → R27–R32. Submit iff hr ≥ 1.5×(2·SE).

## Refuted (Reason era)
- Older Talent-skew / board-parent REFUTEs (R2h–R2am) → `archive/` / status.log; do not re-blend.
- **R8:** REINFORCE-on-Reason −0.027 vs ckp333 (p2158) — closed.
- **R6/R6b:** short≤180 −0.0006; long-z −0.010 — thought-length format closed.
- **R1b/R1c:** king-init LoRA −0.0135 / nsup≥100 −0.0171 vs Tok — SFT family closed.
- **R2ao/ap/aq:** af17 −0.0007; kevin h44 +0.004; …-now +0.008 (≪1.5×) — SKIP.
- **R2aw/ar:** mt1 / iynocr2p **unservable** — SKIP.
- **R2av/ay/az/ba:** Bittoby v2 −0.0003; sbs-v2 **+0.0093** WEAK; **vvv m≈0 REFUTE**; awesome-v10 **+0.007 WEAK** → R2bb next board parent.

## Do not reopen from S\* legacy
Clip-L1 shaping, r∈[0.7,0.85], α-merge lotteries, king-watch, "don't raise Λ2", submit-gate 0.04 — S\* v2 only.
