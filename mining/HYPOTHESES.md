# HYPOTHESES — Reason v3
**Cap 120 lines.** Ranked table + ≤4 lines each. S\* hypotheses → `archive/legacy-sstar-v2/`.

## Ranked

| # | id | claim | status |
|---|---|---|---|
| 1 | R1 | Teacher-ref SFT / distill on current king init raises Reason margin > 3·SE | **REFUTED family** — R1 +0.0005; R1b −0.0135; **R1c −0.0171** (z=−2.75) |
| 2 | R2 | Merge / continue-train recent kings for teacher-helpful z | **open** — **R2bj** SIGNAL_POS vs Tok; **R2bk** n80~15/80 saysth vs ckp333; **R2bl** Bittoby v3 armed (p2156) |
| 3 | R3 | Directly optimize / RL a reward = Reason (teacher lp delta) | **REFUTED** · n80 m=**+0.0094** z=1.33 hr0.66× (p2127) |
| 3b | R3b | GRPO alt-LR/rank (lr=2e-5 r=64 G=8) beats R3 knobs | **open — PRIORITY** · live on `mine-r3-grpo-1` (p2127) |
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
| 4b | R4b | Full-FT lr/epoch family (lr=5e-6 EPOCHS=2) beats R4 knobs | **REFUTED** · n80 m=**−0.0037** z=−0.58 (p2120) |
| 5 | R5 | Non-king base (Genesis/Qwen) + Reason FT beats Tok-init | **REFUTED** · n80 m=**−0.0390** z=−3.24 (p2125) |
| 5b | R5b | Talent reign-3 full-FT (≠ Genesis R5) beats Tok-init | **open** · `mine-r5-nonking-2` · p2081 armed |
| 6 | R6 | Thought-format shaping raises teacher Reason | **REFUTED** · n80 m=**−0.0006** z=−0.07 hr−0.04× (p2143) |
| 6b | R6b | Long-z (z>180) beats R6 short≤180 on Reason | **REFUTED** · n80 m=**−0.01014** z=−1.23 hr−0.62× (p2151) |
| 7 | R7 | High-Reason data-filter curriculum FT | **open — live** · train~10/28 on `mine-r4`; n80 defaults→ckp333 (p2159) |
| 8 | R8 | REINFORCE on Reason (alt to LoRA-GRPO) | **REFUTED** · n80 m=**−0.0273** z=−1.64 hr−0.82× vs ckp333 (p2158) |
| 9 | R9 | Tok LoRA × expanded teacher z_C (format prior) | **open — live** · train~96/354 + post waits train→**R2bk**→merge→n80 vs ckp333 (p2155) |
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
- **R2ba–be** WEAK/UNSERVABLE. **R2bf REFUTE** p2133: n80 m=**−0.00206** z=−0.57 SE=0.00363 hr=−0.19× (dpo2@90ea78ff; chal-00511) → Stage-5 SKIP.
- **R2bg REFUTE** p2140: n80 m=**−0.00191** z=−0.38 SE=0.00507 hr=−0.19× vs live 2·SE (cp1266@68d1daa2; chal-00514) → Stage-5 SKIP.
- **R2bh** live: pure `IntoLayer/Affine-5g94ihdxwu-v1@9b6bc52c…` (chal-00516) chall reload after R2bg; n80 pending. Dir: `experiments/r2-multiking-merge/`.
- **R2bh** IntoLayer n80: m=+0.00378 SE=0.00326 z=1.16; live 2σ thr=0.00651 hr=0.58× → REFUTE p2145.
- **R2bi UNSERVABLE** p2147: thrivepath mt2@22a5d514 arch=`Glm4MoeForCausalLM` — vLLM weight-init fail; skip Glm4Moe board parents.
- **R2bj** vs Tok af10: m=**+0.00427** SE=0.00533 z=0.80 hr0.27×(3σ) / 0.40×(live 2σ) → SIGNAL_POS_BELOW (p2155). Not crown.
- **R2bk** live p2155: same saysth@6e13f365 vs reign-5 **ckp333** on retargeted :8001 (fresh slice). Dec `r2bk_saysth_ckp333_decision.json`.

### R3 — RL on Reason
- **REFUTED** p2127: n80 m=+0.0094 SE=0.00706 z=1.33 < k=2 (hr0.66×); Stage-5 SKIP. Adapter `/root/r3/train_r3_final`. Dir: `experiments/r3-reason-grpo/`.

### R3b — GRPO alt-LR/rank (PRIORITY)
- Same reward/data as R3; knobs lr=**2e-5** r=**64**/α128 G=**8**. p2127 launched on warm `mine-r3-grpo-1` (T/K up; GPUs6–7). Dir: `experiments/r3b-grpo-alt/`.

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
- **p2158 live** on warm `mine-r4-fullft-1`: Tok full-FT top-250 Reason rows, EPOCHS=2 lr=1e-6; post→ckp333. Train `h121_train.nohup`. Dir: `experiments/r7-data-filter/`.

### R8 — REINFORCE on Reason
- **REFUTED** p2158: n80 m=**−0.0273** SE=0.0167 z=−1.64 hr=−0.82× vs ckp333 — Stage-5 SKIP. Dir: `experiments/r8-reinforce-reason/`.

### R24–R32 — structural GRPO knobs (fleet-queued)
- One isolation each vs R3: R24 max_len=16384/new=1024; R25 temp=1.2; R26 temp=0.5; R27 G=16; R28 lr=2e-5; R29 r=64; R30 α=128; R31 drop=0; R32 kl=0.02. Dirs: `experiments/r24…r32-*-grpo/`.

### Fleet axes waiting on 8×B300 (R24 first)
- Live: crown R2bk+R9 · R3b GRPO · **R7** datafilt. Queue: **R24** → R25–R32 …. Submit iff hr ≥ 1.5×(2·SE).

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
