# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.
Pre-p440 refuted prose: `archive/HYPOTHESES-pre-p440.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H121/F26 | high | Tok full-FT (not LoRA) → m>+0.015 | **open** (train ~6/60) |
| 2 | H122/F27 | high | Genesis full-FT → m>+0.015 | **open** (train) |
| 3 | H123/F28 | high | Tok full-FT × teacher_refs → m>+0.015 | **open** (bootstrap) |
| 4 | H112/F17 | high | raw genesis (no LoRA) → m>+0.015 | **open** (n80 ~53) |
| 5 | H120/F25 | high | raw golden-crown (no LoRA) → m>+0.015 | **open** (n80 ~41) |
| 6 | H117/F22 | high | raw everest12 (no LoRA) → m>+0.015 | **open** (everest DL) |
| 7 | H118/F23 | high | raw Bittob (no LoRA) → m>+0.015 | **open** (engines) |
| — | H113/F18 | — | raw TalentPigs (no LoRA) → m>+0.015 | **refuted** m=−0.03010 |
| — | H111/F16 | — | af-k1 × high-Λ2 → m>+0.015 | **refuted** m=−0.07623 |
| — | H119/F24 | — | raw af-k1 (no LoRA) → m>+0.015 | **refuted** m=−0.08673 |
| — | H116/F21 | — | raw diane613 (no LoRA) → m>+0.015 | **refuted** m=−0.07226 |
| — | H115/F20 | — | raw pandora (no LoRA) → m>+0.015 | **refuted** m=−0.02975 |
| — | H114/F19 | — | raw kevin954 (no LoRA) → m>+0.015 | **refuted** m=−0.00611 |
| — | H108/F13 | — | diane613 × high-Λ2 → m>+0.015 | **refuted** m=−0.07293 |
| — | H109/F14 | — | Bittob × high-Λ2 → m>+0.015 | **refuted** m=−0.05784 |
| — | H110/F15 | — | everest12 × high-Λ2 → m>+0.015 | **refuted** m=−0.08285 |
| — | H105/F10 | — | TalentPigs × high-Λ2 → m>+0.015 | **refuted** m=−0.03095 |
| — | H106/F11 | — | pandora × high-Λ2 → m>+0.015 | **refuted** m=−0.03414 |
| — | H107/F12 | — | golden-crown × high-Λ2 → m>+0.015 | **refuted** m=−0.05941 |
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

### H121/F26 — Tok full-FT (no LoRA)
- Dense FT Tok@eb8bf9a × 1059 high-Λ2 z_A lr=1e-6 → m>+0.015.
- mine-f26-1 gentle-fox-2c **train ~6/60** loss≈0.52. `s4-h121-f26-full-ft/`.

### H122/F27 — Genesis full-FT (no LoRA)
- Dense FT genesis@abe89194 × 1059 high-Λ2 z_A lr=1e-6 → m>+0.015 vs Tok.
- mine-f27-1 eager-orbit-15 **train** (BOOTSTRAP_DONE). `s4-h122-f27-genesis-full-ft/`.

### H123/F28 — Tok full-FT × teacher_refs z_C
- Dense FT Tok × 791 teacher_refs_shortz lr=1e-6 → m>+0.015 vs Tok.
- mine-f28-1 eager-eagle-b1 bootstrap/pip. `s4-h123-f28-teacher-refs-ft/`.

### H112/F17 — raw genesis (no LoRA)
- Unmodified genesis @abe89194 vs Tok → m>+0.015. n80 ~53/80. `s4-h112-f17-raw-genesis/`.

### H120/F25 — raw golden-crown (no LoRA)
- Unmodified golden-crown @ee37f4f0 vs Tok → m>+0.015. n80 ~41/80. `s4-h120-f25-raw-golden/`.

### H117/F22 — raw everest12 (no LoRA)
- Unmodified everest12 @a5ac5311 vs Tok → m>+0.015. everest DL ~53G. `s4-h117-f22-raw-everest12/`.

### H118/F23 — raw Bittob11040 (no LoRA)
- Unmodified Bittob @0c04fe92 vs Tok → m>+0.015. engines→n80. `s4-h118-f23-raw-bittob/`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. `experiments/s2-clip-l1-rank/`.

## Seed family queue
| F | family | next |
|---|---|---|
| F5 | Correctness-grounded z | needs verified traj |
| F17/F22/F23/F25/F26/F27/F28 | screens | **live** (7 pods) |
| — | earner×high-Λ2 LoRA | **CLOSED** F9–F16 all ≤0 |
| — | raw past-earner | **CLOSED** kevin/pandora/diane/af-k1/**TalentPigs** |

## Refuted (keep) — detail `archive/HYPOTHESES-pre-p440.md`

- **H113/F18** raw TalentPigs m=−0.03010 (p460) · **H111/F16** af-k1×Λ2 m=−0.07623
- **H119/F24** raw af-k1 m=−0.08673 · **H116/F21** raw diane m=−0.07226
- **H115/F20** raw pandora m=−0.02975 · **H114/F19** raw kevin m=−0.00611
- **H108–H110/F13–F15** earner×Λ2 · **H105/F10** TalentPigs-LoRA m=−0.031
- **H106/F11** pandora-LoRA · **H107/F12** golden · **H104/F9** kevin-LoRA
- **H100/F4** Genesis×Λ2 · **H102/F7** teacher-zC · **H103/F8** Genesis-RL
- **H101/F6** ultrashort · **H98/F1** Tok-RL · **H97/F3** r256 · **H96/H99**
- Screens live: **F17, F22, F23, F25, F26, F27, F28**. Next free slot: **F5** if traj ready.
