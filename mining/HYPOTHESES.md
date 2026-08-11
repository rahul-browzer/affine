# HYPOTHESES — Reason v3
**Cap 120 lines.** Ranked table + ≤4 lines each. S\* hypotheses → `archive/legacy-sstar-v2/`.

## Ranked

| # | id | claim | status |
|---|---|---|---|
| 1 | R1 | Teacher-ref SFT / distill on current king init raises Reason margin > 3·SE | **REFUTED family** — R1 +0.0005; R1b −0.0135; **R1c −0.0171** (z=−2.75) |
| 2 | R2 | Merge / continue-train recent kings for teacher-helpful z | **open** — **R2ay** WEAK (+0.0093); **R2az REFUTE** m≈0; **R2ba** awesome-v10 n80 loading |
| 3 | R3 | Directly optimize / RL a reward = Reason (teacher lp delta) | **open — PRIORITY** · GRPO pid**28660** step≥50; wedge-watch; post_train armed |
| 3b | R3b | GRPO alt-LR/rank (lr=2e-5 r=64 G=8) beats R3 knobs | **open** · `mine-r3-grpo-2` · p2078 armed |
| 4 | R4 | Full-FT (not LoRA) on high-Reason winner_za / Tok-init | **open** · `mine-r4-fullft-1` · p2069 armed |
| 4b | R4b | Full-FT lr/epoch family (lr=5e-6 EPOCHS=2) beats R4 knobs | **open** · `mine-r4-fullft-2` · p2080 armed |
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
| 19 | R19 | TalentPigs-init Reason-GRPO (≠ R3/R5b/R18) | **open** · `mine-r19-talent-grpo-1` · **p2093** armed |

## Open (detail)

### R1 — Distill (family closed)
- R1 +0.0005; R1b −0.0135; **R1c −0.0171** (z=−2.75). Dir: `experiments/r1-reason-distill/`.

### R2 — Multi-king merge
- **R2ay** +0.00930 (hr 1.02×) WEAK. **R2az** m≈−3e−5 REFUTE. **R2ba** pure awesome-v10 n80 **5/80**. Dir: `experiments/r2-multiking-merge/`.

### R3 — RL on Reason (PRIORITY)
- GRPO pid**28660** step≥65; reward=teacher Reason; next train.done→merge→n80. Dir: `experiments/r3-reason-grpo/`.

### Fleet axes waiting on 8×B300 (R3b–R19)
- One pod/axis; uploaders+boot cases armed. Decision: n80 vs Tok; submit iff hr ≥ 1.5×(2·SE).
- **R3b** alt GRPO knobs · **R4/R4b** full-FT · **R5/R5b** Genesis/Talent FT · **R6/R6b** short/long-z · **R7** top-Reason filter · **R8** EMA REINFORCE · **R9** teacher z_C · **R10** merge+GRPO · **R11** online DPO · **R12** BoN-CE · **R13** offline DPO · **R14** kevin RL · **R15** pandora RL · **R16** golden RL · **R17** Qwen3-Coder RL · **R18** pure sbs-v2 GRPO · **R19** Talent-init GRPO @dbfbb3e2 (`experiments/r19-talent-grpo/`).

## Refuted (Reason era)
- Older Talent-skew / board-parent REFUTEs (R2h–R2am) → `archive/` / status.log; do not re-blend.
- **R1b/R1c:** king-init LoRA −0.0135 / nsup≥100 −0.0171 vs Tok — SFT family closed.
- **R2ao/ap/aq:** af17 −0.0007; kevin h44 +0.004; …-now +0.008 (≪1.5×) — SKIP.
- **R2aw/ar:** mt1 / iynocr2p **unservable** — SKIP.
- **R2av/ay/az:** Bittoby v2 −0.0003; sbs-v2 **+0.0093** WEAK; **vvv m≈0 REFUTE** → R2ba awesome-v10.

## Do not reopen from S\* legacy
Clip-L1 shaping, r∈[0.7,0.85], α-merge lotteries, king-watch, "don't raise Λ2", submit-gate 0.04 — S\* v2 only.
