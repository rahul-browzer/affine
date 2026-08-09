# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.
Pre-p440 refuted prose: `archive/HYPOTHESES-pre-p440.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H142/F47 | high | raw Qwen3-Coder-30B vs Tok → m>+0.015 | **open** (n80 d203 @1/80) |
| 2 | H141/F46 | high | Genesis last-N full-rank RL-Λ2 → m>+0.015 | **open** (lastN RL train) |
| 3 | H140/F45 | high | Tok last-N full-rank RL-Λ2 → m>+0.015 | **open** (lastN RL) |
| 4 | H139/F44 | high | Tok online DPO teacher-Λ2 → m>+0.015 | **open** (online-DPO train) |
| 5 | H137/F42 | high | Tok BoN-CE teacher-Λ2 → m>+0.015 | **open** (BoN train) |
| 6 | H136/F41 | high | TalentPigs RL teacher-Λ2 → m>+0.015 | **open** (n80 @11/80 d203) |
| 7 | H135/F40 | high | kevin RL teacher-Λ2 → m>+0.015 | **open** (n80 @30/80 b203) |
| 8 | H134/F39 | high | Tok RL full S* mix → m>+0.015 | **open** (n80 @1/80) |
| 9 | H133/F38 | high | Genesis RL teacher-Λ2 → m>+0.015 | **open** (n80 @59/80) |
| — | H138/F43 | — | Tok offline DPO duel-Λ2 → m>+0.015 | **refuted** m=−0.00966 |
| — | H132/F37 | — | Tok RL teacher-Λ2 → m>+0.015 | **refuted** m=−0.00047 |
| — | H131/F36 | — | af-k1 full-FT → m>+0.015 | **refuted** m=−0.06667 |
| — | H127/F32 | — | TalentPigs full-FT → m>+0.015 | **refuted** m=−0.02626 |
| — | H129/F34 | — | diane full-FT → m>+0.015 | **refuted** m=−0.06281 |
| — | H117/F22 | — | raw everest12 (no LoRA) → m>+0.015 | **refuted** m=−0.06273 |
| — | H124/F29 | — | golden full-FT → m>+0.015 | **refuted** m=−0.09256 |
| — | H130/F35 | — | everest full-FT → m>+0.015 | **refuted** m=−0.08429 |
| — | H128/F33 | — | pandora full-FT → m>+0.015 | **refuted** m=−0.02161 |
| — | H121/F26 | — | Tok full-FT → m>+0.015 | **refuted** m=−0.00031 |
| — | H122/F27 | — | Genesis full-FT → m>+0.015 | **refuted** m=−0.07068 |
| — | H126/F31 | — | Bittob full-FT → m>+0.015 | **refuted** m=−0.07651 |
| — | H123/F28 | — | Tok full-FT × teacher_refs → m>+0.015 | **refuted** m=−0.00982 |
| — | H125/F30 | — | kevin full-FT → m>+0.015 | **refuted** m=−0.01918 |
| — | H118/F23 | — | raw Bittob (no LoRA) → m>+0.015 | **refuted** m=−0.08436 |
| — | H120/F25 | — | raw golden-crown (no LoRA) → m>+0.015 | **refuted** m=−0.06343 |
| — | H112/F17 | — | raw genesis (no LoRA) → m>+0.015 | **refuted** m=−0.05489 |
| — | H113/F18 | — | raw TalentPigs (no LoRA) → m>+0.015 | **refuted** m=−0.03010 |
| — | H111/F16 | — | af-k1 × high-Λ2 → m>+0.015 | **refuted** m=−0.07623 |
| — | H119/F24 | — | raw af-k1 (no LoRA) → m>+0.015 | **refuted** m=−0.08673 |
| — | H116/F21 | — | raw diane613 (no LoRA) → m>+0.015 | **refuted** m=−0.07226 |
| — | H115/F20 | — | raw pandora (no LoRA) → m>+0.015 | **refuted** m=−0.02975 |
| — | H114/F19 | — | raw kevin954 (no LoRA) → m>+0.015 | **refuted** m=−0.00611 |
| — | H108–H110 | — | earner×high-Λ2 LoRA | **refuted** |
| — | H105–H107 | — | TalentPigs/pandora/golden×Λ2 | **refuted** |
| — | H104/F9 | — | kevin954 × high-Λ2 → m>+0.015 | **refuted** m=−0.01417 |
| — | H100/F4 | — | Genesis-init × high-Λ2 → m>+0.015 | **refuted** m=−0.05488 |
| — | H102/F7 | — | Genesis × teacher z_C → m>+0.015 | **refuted** m=−0.05194 |
| — | H103/F8 | — | Genesis-init × REINFORCE-L1 → m>+0.015 | **refuted** m=−0.04829 |
| — | H101/F6 | — | ultrashort≤80 format → m>+0.015 | **refuted** m=−0.00453 |
| — | H98/F1 | — | Tok REINFORCE self-L1lift → m>+0.015 | **refuted** m=+0.00229 |
| — | H97/F3 | — | r=256 breaks LoRA ceiling | **refuted** m=−0.01506 |
| — | H96 | — | Tok-init r9 → m>0.04 | **refuted** m=+0.00913 |
| — | H99/F2 | — | high-Λ2 z_A SFT → m>+0.015 | **refuted** m=−0.00199 |
| — | H95…H1 | — | winner-zA / α / merges | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

## Open

### H142/F47 — raw Qwen3-Coder-30B-A3B-Instruct
- Unmodified Coder @ `b2cff646…` vs Tok; no train. First non-Albedo base.
- mine-f47-1 n80 d203 LIVE @1/80 (p525 king health after shm hang). `s4-h142-f47-raw-qwen3-coder/`.

### H141/F46 — Genesis last-N full-rank REINFORCE on teacher Λ2
- Cross F38×F45: Genesis init, last-N=8 full-rank + lm_head, teacher-Λ2.
- mine-f46-1 bootstrap. `s4-h141-f46-genesis-lastn-rl-l2/`.

### H140/F45 — Tok last-N full-rank REINFORCE on teacher Λ2
- Unfreeze last 8 layers + lm_head; SGD lr=1e-6; same Λ2 reward as F37.
- lastN RL train. mine-f45-1. `s4-h140-f45-tok-lastn-rl-l2/`.

### H139/F44 — Tok online DPO on teacher Λ2
- Tok-init LoRA; G=2; teacher-Λ2 labels; DPO β=0.1 → m>+0.015.
- train live. mine-f44-1.

### H138/F43 — Tok offline DPO on duel Λ2 prefs — REFUTED
- m=−0.00966 z=−1.31; λ2_c −0.0115 vs king −0.0062; gates clear. `s4-h138-f43-tok-dpo-l2/`.

### H137/F42 — Tok Best-of-N CE on teacher Λ2
- BoN train. mine-f42-1.

### H136/F41 — TalentPigs REINFORCE on teacher Λ2
- n80 @11/80 d203. mine-f41-1.

### H135/F40 — kevin954 REINFORCE on teacher Λ2
- n80 @30/80 b203. mine-f40-1.

### H134/F39 — Tok REINFORCE on full S* mix
- n80 @1/80 a203. mine-f39-1.

### H133/F38 — Genesis REINFORCE on teacher Λ2
- n80 @59/80 a203. mine-f38-1.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. `experiments/s2-clip-l1-rank/`.

## Seed family queue
| F | family | next |
|---|---|---|
| F5 | Correctness-grounded z | needs verified traj |
| F47 | raw Qwen3-Coder (non-Albedo) | **live** n80 d203 |
| F46 | Genesis last-N full-rank RL-Λ2 | **live** bootstrap |
| F45 | Tok last-N full-rank RL-Λ2 | **live** train |
| F44 | Tok online DPO teacher-Λ2 | **live** train |
| F42–F38 | BoN/RL screens | n80 or train |
| — | Tok offline DPO duel-Λ2 | **CLOSED** F43 m=−0.00966 |
| — | Tok LoRA RL teacher-Λ2 | **CLOSED** F37 m=−0.00047 |
| — | past-king full-FT×Λ2 | **CLOSED** F26–F36 all ≤0 |
| — | earner×high-Λ2 LoRA | **CLOSED** F9–F16 all ≤0 |
| — | raw past-earner/genesis | **CLOSED** |

## Refuted (keep) — detail `archive/HYPOTHESES-pre-p440.md`

- **H138/F43** offline DPO duel-Λ2 −0.00966 · **H132/F37** Tok LoRA RL −0.00047 · **H131/F36** af-k1 FT −0.067
- **H117/F22** raw everest −0.063 · **H124/F29** golden FT −0.093 · **H130/F35** everest FT −0.084
- **H121–H126/H123/H125** full-FT class ≤0 · **H118/F23** raw Bittob −0.084
- **H120/F25** raw golden −0.063 · **H112/F17** genesis −0.055 · **H113/F18** TalentPigs −0.030
- **H111/F16** af-k1×Λ2 −0.076 · **H119/F24** raw af-k1 −0.087 · **H116/F21** diane −0.072
- **H115/F20** pandora −0.030 · **H114/F19** kevin −0.006 · **H108–H110** · **H105–H107**
- **H104/F9** · **H100/F4** · **H102/F7** · **H103/F8** · **H101/F6** · **H98/F1** · **H97/F3**
- Free slots → **orthogonal** (not RL-Λ2 base/BoN cell; not past-king FT/raw).
