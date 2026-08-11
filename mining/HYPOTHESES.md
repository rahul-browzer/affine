# HYPOTHESES — Reason v3
**Cap 120 lines.** Ranked table + ≤4 lines each. S\* hypotheses → `archive/legacy-sstar-v2/`.

## Ranked

| # | id | claim | status |
|---|---|---|---|
| 1 | R1 | Teacher-ref SFT / distill on current king init raises Reason margin > 3·SE | **REFUTED family** — R1 +0.0005; R1b −0.0135; **R1c −0.0171** (z=−2.75) |
| 2 | R2 | Merge / continue-train recent kings for teacher-helpful z | **open** — R2bd **UNSERVABLE** → **R2be armed** (hope12@fea71676; chal-00508) |
| 3 | R3 | Directly optimize / RL a reward = Reason (teacher lp delta) | **open — PRIORITY** · GRPO pid**28660** step≥135; wedge-watch; post_train armed |
| 3b | R3b | GRPO alt-LR/rank (lr=2e-5 r=64 G=8) beats R3 knobs | **open** · `mine-r3-grpo-2` · p2078 armed |
| 24 | R24 | Tok GRPO max_len=16384 max_new=1024 beats R3 6144/512 | **open** · `mine-r24-longctx-1` · p2098 armed |
| 25 | R25 | Tok GRPO temperature=1.2 beats R3 temp=0.8 | **open** · `mine-r25-hitemp-1` · p2099 armed |
| 26 | R26 | Tok GRPO temperature=0.5 beats R3 0.8 / R25 1.2 | **open** · `mine-r26-lotemp-1` · p2100 armed |
| 27 | R27 | Tok GRPO group_size=16 beats R3 G=4 (isolates G vs R3b) | **open** · `mine-r27-bigg-1` · p2101 armed |
| 28 | R28 | Tok GRPO lr=2e-5 beats R3 5e-6 (isolates LR vs R3b) | **open** · `mine-r28-hilr-1` · p2102 armed |
| 29 | R29 | Tok GRPO lora_r=64 beats R3 r=16 (isolates rank vs R3b) | **open** · `mine-r29-hirank-1` · p2104 armed |
| 30 | R30 | Tok GRPO lora_alpha=128 r=16 beats R3 α=32 (isolates α vs R29) | **open** · `mine-r30-hialpha-1` · p2105 armed |
| 31 | R31 | Tok GRPO lora_dropout=0.0 beats R3 drop=0.05 (isolates dropout) | **open** · `mine-r31-nodrop-1` · p2107 armed |
| 32 | R32 | Tok GRPO kl_coef=0.02 vs base beats R3 kl=0 (isolates KL) | **open** · `mine-r32-kl-1` · **p2108** armed |
| 4 | R4 | Full-FT (not LoRA) on high-Reason winner_za / Tok-init | **REFUTED** · n80 m=**−0.0077** z=−0.76 (p2116) |
| 4b | R4b | Full-FT lr/epoch family (lr=5e-6 EPOCHS=2) beats R4 knobs | **open** · on `mine-r4-fullft-1` train pid**25058** (p2116) |
| 5 | R5 | Non-king base (Genesis/Qwen) + Reason FT beats Tok-init | **open** · `mine-r5-nonking-1` · p2074 armed |
| 5b | R5b | Talent reign-3 full-FT (≠ Genesis R5) beats Tok-init | **open** · `mine-r5-nonking-2` · p2081 armed |
| 6 | R6 | Thought-format shaping raises teacher Reason | **open** · `mine-r6-fmt-1` · p2075 armed |
| 6b | R6b | Long-z (z>180) beats R6 short≤180 on Reason | **open** · `mine-r6-fmt-2` · p2083 armed |
| 7 | R7 | High-Reason data-filter curriculum FT | **open** · `mine-r7-datafilt-1` · p2076 armed |
| 8 | R8 | REINFORCE on Reason (alt to LoRA-GRPO) | **open** · `mine-r8-reinforce-1` · p2077 armed |
| 9 | R9 | Tok LoRA × expanded teacher z_C (format prior) | **open** · `mine-r9-teacher-zc-1` · p2079 armed |
| 10 | R10 | Tok×sbs-v2 α-merge → Reason-GRPO hybrid | **open** · `mine-r10-merge-rl-1` · p2082 armed |
| 11 | R11 | Online DPO on live teacher Reason (BT vs frozen base) | **open** · `mine-r11-odpo-1` · p2084 armed |
| 12 | R12 | Best-of-N CE on live teacher Reason (CE argmax of G=4) | **open** · `mine-r12-bon-1` · p2085 armed |
| 13 | R13 | Offline DPO on duel Reason prefs (frozen chosen/rejected) | **open** · `mine-r13-odpo-1` · p2086 armed |
| 14 | R14 | kevin954-init REINFORCE on teacher Reason | **open** · `mine-r14-kevin-rl-1` · p2087 armed |
| 15 | R15 | pandora-box-init REINFORCE on teacher Reason | **open** · `mine-r15-pandora-rl-1` · p2088 armed |
| 16 | R16 | golden-crown-init REINFORCE on teacher Reason | **open** · `mine-r16-golden-rl-1` · p2089 armed |
| 17 | R17 | Qwen3-Coder base + REINFORCE on teacher Reason | **open** · `mine-r17-coder-rl-1` · p2091 armed |
| 18 | R18 | Pure sbs-v2-init Reason-GRPO (≠ R3 Tok / R10 merge) | **open** · `mine-r18-sbs-grpo-1` · p2092 armed |
| 19 | R19 | TalentPigs-init Reason-GRPO (≠ R3/R5b/R18) | **open** · `mine-r19-talent-grpo-1` · p2093 armed |
| 20 | R20 | kevin954-init Reason-GRPO (≠ R3/R14 REINFORCE/R19) | **open** · `mine-r20-kevin-grpo-1` · p2094 armed |
| 21 | R21 | pandora-box-init Reason-GRPO (≠ R3/R15 REINFORCE/R20) | **open** · `mine-r21-pandora-grpo-1` · p2095 armed |
| 22 | R22 | golden-crown-init Reason-GRPO (≠ R3/R16 REINFORCE/R18–R21) | **open** · `mine-r22-golden-grpo-1` · p2096 armed |
| 23 | R23 | diane613-init Reason-GRPO (≠ R3/R16/R18–R22) | **open** · `mine-r23-diane-grpo-1` · **p2097** armed |

## Open (detail)

### R1 — Distill (family closed)
- R1 +0.0005; R1b −0.0135; **R1c −0.0171** (z=−2.75). Dir: `experiments/r1-reason-distill/`.

### R2 — Multi-king merge
- **R2ba** WEAK +0.007. **R2bb** WEAK. **R2bc+R2bd** UNSERVABLE (weight-init). **R2be** p2118 armed: Shatoria hope12@fea71676… chal-00508 (next dpo2 chal-00511). Dir: `experiments/r2-multiking-merge/`.

### R3 — RL on Reason (PRIORITY)
- GRPO pid**28660** step≥167/200; reward=teacher Reason; next train.done→merge→n80. Dir: `experiments/r3-reason-grpo/`.

### R4 — Full-FT
- **REFUTED** p2116: n80 m=−0.0077 z=−0.76 (salvage ckpt-26 lr1e-6 ep1). Retargeted pod → **R4b**. Dir: `experiments/r4-fullft-reason/` + `s4-h121-f26-full-ft/`.

### R4b — Full-FT lr/epoch
- p2116: launched on `mine-r4-fullft-1` (killed TKC) lr=**5e-6** EPOCHS=**2** pid**25058**; post_train+form-decision armed. Watch `/root/logs/h121_train.nohup`. Dir: `experiments/r4b-fullft-lr/`.

### R24 — Long-context / full-thought GRPO
- Tok-init; max_len=**16384** max_new=**1024** (live thought budget); same lr/r/G as R3.
- Pod `mine-r24-longctx-1`; queue after R3b (ahead of parent-swap). Dir: `experiments/r24-longctx-grpo/`.

### R25 — High-temperature GRPO
- Tok-init; **temperature=1.2** (R3 uses 0.8); same len/new/lr/r/G as R3.
- Pod `mine-r25-hitemp-1`; queue after R24. Dir: `experiments/r25-hitemp-grpo/`.

### R26 — Low-temperature GRPO
- Tok-init; **temperature=0.5** (R3 0.8 / R25 1.2); same len/new/lr/r/G as R3.
- Pod `mine-r26-lotemp-1`; queue after R25. Dir: `experiments/r26-lotemp-grpo/`.

### R27 — Large-group GRPO
- Tok-init; **group_size=16** (R3 G=4; R3b G=8 *with* alt lr/rank); same temp/lr/r/len as R3.
- Isolates G — not confounded with R3b knobs. Pod `mine-r27-bigg-1`; queue after R26.
- Dir: `experiments/r27-bigg-grpo/`.

### R28 — High-LR GRPO
- Tok-init; **lr=2e-5** (R3 5e-6; R3b 2e-5 *with* r=64 G=8); same r/G/temp/len as R3.
- Isolates LR — not confounded with R3b knobs. Pod `mine-r28-hilr-1`; queue after R27.
- Dir: `experiments/r28-hilr-grpo/`.

### R29 — High-rank GRPO
- Tok-init; **lora_r=64** / α128 (R3 r=16/α32; R3b r=64 *with* lr=2e-5 G=8); same lr/G/temp/len as R3.
- Isolates rank — not confounded with R3b knobs. Pod `mine-r29-hirank-1`; queue after R28.
- Dir: `experiments/r29-hirank-grpo/`.

### R30 — High-α GRPO
- Tok-init; **lora_r=16** / **α128** (R3 α=32; R29 raises r with α/r=2 held); same lr/G/temp/len as R3.
- Isolates α scale — not confounded with R29 rank. Pod `mine-r30-hialpha-1`; queue after R29.
- Dir: `experiments/r30-hialpha-grpo/`.

### R31 — Zero-dropout GRPO
- Tok-init; **lora_dropout=0.0** (R3 default **0.05**); same lr/r/α/G/temp/len as R3.
- Isolates adapter dropout. Pod `mine-r31-nodrop-1`; queue after R30.
- Dir: `experiments/r31-nodrop-grpo/`. Trainer: `--lora-dropout` on `train_reason_grpo.py`.

### R32 — KL-regularized GRPO
- Tok-init; **kl_coef=0.02** vs adapter-disabled base (R3 **kl=0**); same lr/r/α/drop/G/temp/len.
- Isolates KL. Pod `mine-r32-kl-1`; queue after R31. Dir: `experiments/r32-kl-grpo/`.
- Trainer: `--kl-coef` on `train_reason_grpo.py`.

### Fleet axes waiting on 8×B300 (R3b–R32; R4 live)
- One pod/axis; uploaders+boot cases armed. Decision: n80 vs Tok; submit iff hr ≥ 1.5×(2·SE).
- **R4** full-FT **live** · **R3b** alt GRPO · **R24–R32** structural GRPO · **R4b/R5…** rest of queue.

## Refuted (Reason era)
- Older Talent-skew / board-parent REFUTEs (R2h–R2am) → `archive/` / status.log; do not re-blend.
- **R1b/R1c:** king-init LoRA −0.0135 / nsup≥100 −0.0171 vs Tok — SFT family closed.
- **R2ao/ap/aq:** af17 −0.0007; kevin h44 +0.004; …-now +0.008 (≪1.5×) — SKIP.
- **R2aw/ar:** mt1 / iynocr2p **unservable** — SKIP.
- **R2av/ay/az/ba:** Bittoby v2 −0.0003; sbs-v2 **+0.0093** WEAK; **vvv m≈0 REFUTE**; awesome-v10 **+0.007 WEAK** → R2bb next board parent.

## Do not reopen from S\* legacy
Clip-L1 shaping, r∈[0.7,0.85], α-merge lotteries, king-watch, "don't raise Λ2", submit-gate 0.04 — S\* v2 only.
