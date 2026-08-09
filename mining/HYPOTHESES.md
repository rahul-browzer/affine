# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.
Pre-p440 refuted prose: `archive/HYPOTHESES-pre-p440.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H132/F37 | high | Tok RL teacher-Λ2 → m>+0.015 | **open** (RL step≥50) |
| 2 | H129/F34 | high | diane full-FT → m>+0.015 | **open** (n80 ~76/80) |
| 3 | H131/F36 | high | af-k1 full-FT → m>+0.015 | **open** (n80 ~18/80) |
| 4 | H127/F32 | high | TalentPigs full-FT → m>+0.015 | **open** (n80 ~43/80) |
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

### H132/F37 — Tok REINFORCE on teacher Λ2
- Tok-init LoRA; reward = lpC(y|z)−lpC(y|∅) via live teacher :8000 → m>+0.015.
- mine-f37-1: step≥50/200; soft=18:06Z OK. `s4-h132-f37-tok-rl-l2/`.

### H117/F22 — raw everest12 (no LoRA) REFUTED
- m=**−0.06273** z=−7.07 λ2_c≈king; mix S collapses. `s4-h117-f22-raw-everest12/results/`.

### H127/H129/H131 — past-king full-FT screens (dying class)
- TalentPigs/diane/af-k1 n80 live. **H124/F29 REFUTE** m=−0.09256 λ2_c=−0.029 (p498).
- Detail: `s4-h127…` / `s4-h129…` / `s4-h131…` / `s4-h124-f29-golden-full-ft/results/`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. `experiments/s2-clip-l1-rank/`.

## Seed family queue
| F | family | next |
|---|---|---|
| F5 | Correctness-grounded z | needs verified traj |
| F37 | Tok RL teacher-Λ2 | **live** train |
| F32/F34/F36 | past-king FT screens | **live** |
| — | earner×high-Λ2 LoRA | **CLOSED** F9–F16 all ≤0 |
| — | raw past-earner/genesis | **CLOSED** (F22 everest −0.063 last) |
| — | Tok/past-king full-FT×Λ2 | **DYING** F26–F35+F29 ≤0; F32/F34/F36 only |

## Refuted (keep) — detail `archive/HYPOTHESES-pre-p440.md`

- **H117/F22** raw everest m=−0.06273 · **H124/F29** golden FT −0.093 · **H130/F35** everest FT −0.084
- **H128/F33** pandora −0.022
- **H121/F26** Tok −0.000 · **H122/F27** Genesis −0.071 · **H126/F31** Bittob −0.077
- **H123/F28** Tok×refs −0.010 · **H125/F30** kevin −0.019
- **H118/F23** raw Bittob −0.084 · **H120/F25** raw golden −0.063 · **H112/F17** genesis −0.055
- **H113/F18** TalentPigs −0.030 · **H111/F16** af-k1×Λ2 −0.076 · **H119/F24** raw af-k1 −0.087
- **H116/F21** diane −0.072 · **H115/F20** pandora −0.030 · **H114/F19** kevin −0.006
- **H108–H110** · **H105–H107** · **H104/F9** · **H100/F4** · **H102/F7** · **H103/F8**
- **H101/F6** · **H98/F1** · **H97/F3** · Free slots → **orthogonal** (not past-king FT/raw).
