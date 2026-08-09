# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.
Pre-p440 refuted prose: `archive/HYPOTHESES-pre-p440.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H112/F17 | high | raw genesis (no LoRA) → m>+0.015 | **open** (bootstrap) |
| 2 | H113/F18 | high | raw TalentPigs (no LoRA) → m>+0.015 | **open** (bootstrap) |
| 3 | H114/F19 | high | raw kevin954 (no LoRA) → m>+0.015 | **open** (bootstrap) |
| 4 | H115/F20 | high | raw pandora (no LoRA) → m>+0.015 | **open** (bootstrap) |
| 5 | H116/F21 | high | raw diane613 (no LoRA) → m>+0.015 | **open** (bootstrap p443 B200) |
| 6 | H105/F10 | high | TalentPigs × high-Λ2 → m>+0.015 | **open** (n80 ~30/80) |
| 7 | H106/F11 | high | pandora × high-Λ2 → m>+0.015 | **open** (n80 ~38/80) |
| 8 | H108/F13 | high | diane613 × high-Λ2 → m>+0.015 | **open** (n80 ~49/80) |
| 9 | H109/F14 | high | Bittob11040 × high-Λ2 → m>+0.015 | **open** (n80 ~6/80) |
| 10 | H110/F15 | high | everest12 × high-Λ2 → m>+0.015 | **open** (n80 ~40/80) |
| 11 | H111/F16 | high | af-k1 × high-Λ2 → m>+0.015 | **open** (train) |
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

### H112/F17 — raw genesis (no LoRA)
- Unmodified genesis @abe89194 vs Tok → m>+0.015. Bootstrap. `s4-h112-f17-raw-genesis/`.

### H113/F18 — raw TalentPigs (no LoRA)
- Unmodified TalentPigs @dbfbb3e2 vs Tok → m>+0.015 (≠F10 LoRA). Bootstrap. `s4-h113-f18-raw-talentpigs/`.

### H114/F19 — raw kevin954 (no LoRA)
- Unmodified kevin954 @3fb79cfb vs Tok → m>+0.015 (≠F9 LoRA). Bootstrap. `s4-h114-f19-raw-kevin/`.

### H115/F20 — raw pandora (no LoRA)
- Unmodified pandora @5218b138 vs Tok → m>+0.015 (≠F11 LoRA). Bootstrap. `s4-h115-f20-raw-pandora/`.

### H116/F21 — raw diane613 (no LoRA)
- Unmodified diane613 @ad0f3f11 vs Tok → m>+0.015 (≠F13 LoRA). Bootstrap p443 on B200. `s4-h116-f21-raw-diane/`.

### H105/F10 — TalentPigs × high-Λ2
- TalentPigs + 1059 high-Λ2 → m>+0.015. n80 ~30/80. `s4-h105-f10-talentpigs-base/`.

### H106/F11 — pandora × high-Λ2
- pandora @5218b138 + high-Λ2 → m>+0.015. n80 ~38/80. `s4-h106-f11-pandora-base/`.

### H108/F13 — diane613 × high-Λ2
- diane613 @ad0f3f11 + high-Λ2 → m>+0.015. n80 ~49/80. `s4-h108-f13-diane613/`.

### H109/F14 — Bittob × high-Λ2
- Bittob11040 @0c04fe92 + high-Λ2 → m>+0.015. n80 ~6/80. `s4-h109-f14-bittob/`.

### H110/F15 — everest12 × high-Λ2
- everest12 @a5ac5311 + high-Λ2 → m>+0.015. n80 ~40/80. `s4-h110-f15-everest12/`.

### H111/F16 — af-k1 × high-Λ2
- af-k1 @ff6eb4bc + high-Λ2 → m>+0.015. train. `s4-h111-f16-af-k1/`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. `experiments/s2-clip-l1-rank/`.

## Seed family queue
| F | family | next |
|---|---|---|
| F5 | Correctness-grounded z | needs verified traj |
| F17–F21 | raw no-LoRA screens | **screening** |
| — | next raw-base | everest12 / Bittob / af-k1 unmodified |
| — | earner×high-Λ2 LoRA | **queue exhausted** |

## Refuted (keep) — detail `archive/HYPOTHESES-pre-p440.md`

- **H107/F12** golden-crown m=−0.05941 · **H104/F9** kevin m=−0.01417
- **H100/F4** Genesis×Λ2 m=−0.05489 · **H102/F7** teacher-zC m=−0.05194
- **H103/F8** Genesis-RL m=−0.04829 · **H101/F6** ultrashort m=−0.00453
- **H98/F1** Tok-RL m=+0.00229 · **H97/F3** r256 m=−0.01506
- **H96** winner-zA r9 m=+0.00913 · **H99/F2** remix m=−0.00199
- **H95…H1** α/plmk/TP/m7/winner-zA (−0.004)/F1–F4/F6–F9/F12 dead
- Screens live: **F10–F11/F13–F21**.
