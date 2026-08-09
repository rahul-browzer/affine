# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.
Pre-p440 refuted prose: `archive/HYPOTHESES-pre-p440.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H132/F37 | high | Tok RL teacher-Λ2 → m>+0.015 | **open** (RL step≥35) |
| 2 | H124/F29 | high | golden full-FT → m>+0.015 | **open** (n80 e203 SIM) |
| 3 | H117/F22 | high | raw everest12 (no LoRA) → m>+0.015 | **open** (n80 SIM) |
| 4 | H129/F34 | high | diane full-FT → m>+0.015 | **open** (n80 SIM) |
| 5 | H131/F36 | high | af-k1 full-FT → m>+0.015 | **open** (n80 SIM) |
| 6 | H127/F32 | high | TalentPigs full-FT → m>+0.015 | **open** (n80 SIM) |
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

### H132/F37 — Tok REINFORCE on teacher Λ2
- Tok-init LoRA; reward = lpC(y|z)−lpC(y|∅) via live teacher :8000 → m>+0.015.
- mine-f37-1: step≥35; soft=18:06Z OK. `s4-h132-f37-tok-rl-l2/`.

### H124/F29 — golden-crown full-FT × high-Λ2 z_A
- Dense FT golden@ee37f4f0 × 1059 high-Λ2 z_A lr=1e-6 → m>+0.015 vs Tok.
- mine-f29-1 n80 e203 SIM. `s4-h124-f29-golden-full-ft/`.

### H127/F32 — TalentPigs full-FT × high-Λ2 z_A
- Dense FT TalentPigs@dbfbb3e2 × 1059 high-Λ2 → m>+0.015. mine-f32-1 n80 SIM.
- `s4-h127-f32-talentpigs-full-ft/`.

### H117/F22 — raw everest12 (no LoRA)
- Unmodified everest12 @a5ac5311 vs Tok → m>+0.015. mine-f22-1 n80 SIM.
- `s4-h117-f22-raw-everest12/`.

### H129/H131 / F34/F36 — past-king full-FT screens
- diane/af-k1 n80 SIM. **H128/F33 REFUTE** −0.0216; **H130/F35 REFUTE** −0.0843 (p497).
- Detail: `s4-h129…` / `s4-h131-f36-af-k1-full-ft/`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. `experiments/s2-clip-l1-rank/`.

## Seed family queue
| F | family | next |
|---|---|---|
| F5 | Correctness-grounded z | needs verified traj |
| F37 | Tok RL teacher-Λ2 | **live** train |
| F22/F29/F32/F34/F36 | screens | **live** |
| — | earner×high-Λ2 LoRA | **CLOSED** F9–F16 all ≤0 |
| — | raw past-earner/genesis | **CLOSED** (everest F22 open) |
| — | Tok/past-king full-FT×Λ2 | **DYING** F26–F31+F33+F35 ≤0; F29/F32/F34/F36 screens only |

## Refuted (keep) — detail `archive/HYPOTHESES-pre-p440.md`

- **H130/F35** everest FT m=−0.08429 · **H128/F33** pandora −0.02161 · **H121/F26** Tok −0.00031
- **H122/F27** Genesis −0.07068 · **H126/F31** Bittob −0.07651 · **H123/F28** Tok×refs −0.00982
- **H125/F30** kevin −0.01918
- **H118/F23** raw Bittob −0.084 · **H120/F25** raw golden −0.063 · **H112/F17** genesis −0.055
- **H113/F18** TalentPigs −0.030 · **H111/F16** af-k1×Λ2 −0.076 · **H119/F24** raw af-k1 −0.087
- **H116/F21** diane −0.072 · **H115/F20** pandora −0.030 · **H114/F19** kevin −0.006
- **H108–H110** · **H105–H107** · **H104/F9** · **H100/F4** · **H102/F7** · **H103/F8**
- **H101/F6** · **H98/F1** · **H97/F3** · Free slots → **orthogonal family** (not past-king FT).
