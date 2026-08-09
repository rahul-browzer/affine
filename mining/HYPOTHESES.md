# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.
Pre-p440 refuted prose: `archive/HYPOTHESES-pre-p440.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H132/F37 | high | Tok RL teacher-Λ2 → m>+0.015 | **open** (RL steps live) |
| 2 | H124/F29 | high | golden full-FT → m>+0.015 | **open** (n80 e203 ~50) |
| 3 | H128/F33 | high | pandora full-FT → m>+0.015 | **open** (n80 ~66/80) |
| 4 | H130/F35 | high | everest full-FT → m>+0.015 | **open** (n80 ~47/80) |
| 5 | H131/F36 | high | af-k1 full-FT → m>+0.015 | **open** (n80 d203 a1) |
| 6 | H129/F34 | high | diane full-FT → m>+0.015 | **open** (n80 ~41/80) |
| 7 | H117/F22 | high | raw everest12 (no LoRA) → m>+0.015 | **open** (n80 ~32/80) |
| 8 | H127/F32 | high | TalentPigs full-FT → m>+0.015 | **open** (n80 ~15/80) |
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
- mine-f37-1 pid11123: steps 1–5 live mean_r≈0.02 (p495). `s4-h132-f37-tok-rl-l2/`.

### H124/F29 — golden-crown full-FT × high-Λ2 z_A
- Dense FT golden@ee37f4f0 × 1059 high-Λ2 z_A lr=1e-6 → m>+0.015 vs Tok.
- mine-f29-1 n80 e203. `s4-h124-f29-golden-full-ft/`.

### H127/F32 — TalentPigs full-FT × high-Λ2 z_A
- Dense FT TalentPigs@dbfbb3e2 × 1059 high-Λ2 → m>+0.015. mine-f32-1 n80.
- `s4-h127-f32-talentpigs-full-ft/`.

### H117/F22 — raw everest12 (no LoRA)
- Unmodified everest12 @a5ac5311 vs Tok → m>+0.015. mine-f22-1 n80.
- `s4-h117-f22-raw-everest12/`.

### H128–H131 / F33–F36 — past-king full-FT screens
- pandora/diane/everest n80 mid; af-k1 F36 n80 d203 launched (p495).
- Detail: `s4-h128…` … `s4-h131-f36-af-k1-full-ft/results/pass495_n80_launched.md`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. `experiments/s2-clip-l1-rank/`.

## Seed family queue
| F | family | next |
|---|---|---|
| F5 | Correctness-grounded z | needs verified traj |
| F37 | Tok RL teacher-Λ2 | **live** train |
| F22/F29/F32–F36 | screens | **live** |
| — | earner×high-Λ2 LoRA | **CLOSED** F9–F16 all ≤0 |
| — | raw past-earner/genesis | **CLOSED** (everest F22 open) |
| — | Tok/past-king full-FT×Λ2 | **DYING** F26–F31 ≤0; F29/F32–F36 screens only |

## Refuted (keep) — detail `archive/HYPOTHESES-pre-p440.md`

- **H121/F26** Tok FT m=−0.00031 · **H122/F27** Genesis FT m=−0.07068 · **H126/F31** Bittob FT m=−0.07651
- **H123/F28** Tok×teacher_refs FT m=−0.00982 · **H125/F30** kevin FT m=−0.01918
- **H118/F23** raw Bittob m=−0.08436 · **H120/F25** raw golden m=−0.06343
- **H112/F17** raw genesis m=−0.05489 · **H113/F18** raw TalentPigs m=−0.03010
- **H111/F16** af-k1×Λ2 m=−0.07623 · **H119/F24** raw af-k1 m=−0.08673
- **H116/F21** raw diane m=−0.07226 · **H115/F20** raw pandora m=−0.02975
- **H114/F19** raw kevin m=−0.00611 · **H108–H110/F13–F15** earner×Λ2
- **H105/F10** TalentPigs-LoRA · **H106–H107/F11–F12** · **H104/F9**
- **H100/F4** · **H102/F7** · **H103/F8** · **H101/F6** · **H98/F1** · **H97/F3**
- Free slots → **new orthogonal family** (not more past-king×Λ2 FT).
