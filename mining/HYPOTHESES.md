# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.
Pre-p440 refuted prose: `archive/HYPOTHESES-pre-p440.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H115/F20 | high | raw pandora (no LoRA) → m>+0.015 | **open** (n80 ~60) |
| 2 | H112/F17 | high | raw genesis (no LoRA) → m>+0.015 | **open** (n80 ~48) |
| 3 | H116/F21 | high | raw diane613 (no LoRA) → m>+0.015 | **open** (n80 ~47) |
| 4 | H113/F18 | high | raw TalentPigs (no LoRA) → m>+0.015 | **open** (n80 up) |
| 5 | H119/F24 | high | raw af-k1 (no LoRA) → m>+0.015 | **open** (n80 ~15) |
| 6 | H111/F16 | high | af-k1 × high-Λ2 → m>+0.015 | **open** (n80 ~11) |
| 7 | H117/F22 | high | raw everest12 (no LoRA) → m>+0.015 | **open** (everest DL) |
| 8 | H118/F23 | high | raw Bittob (no LoRA) → m>+0.015 | **open** (king DL) |
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

### H112/F17 — raw genesis (no LoRA)
- Unmodified genesis @abe89194 vs Tok → m>+0.015. n80 ~48/80. `s4-h112-f17-raw-genesis/`.

### H113/F18 — raw TalentPigs (no LoRA)
- Unmodified TalentPigs @dbfbb3e2 vs Tok → m>+0.015 (≠F10 LoRA). p455: recover454 → promptable; n80 d203 up. `s4-h113-f18-raw-talentpigs/`.

### H115/F20 — raw pandora (no LoRA)
- Unmodified pandora @5218b138 vs Tok → m>+0.015 (≠F11 LoRA). n80 ~60/80. `s4-h115-f20-raw-pandora/`.

### H116/F21 — raw diane613 (no LoRA)
- Unmodified diane613 @ad0f3f11 vs Tok → m>+0.015 (≠F13 LoRA). n80 ~47/80. `s4-h116-f21-raw-diane/`.

### H117/F22 — raw everest12 (no LoRA)
- Unmodified everest12 @a5ac5311 vs Tok → m>+0.015 (≠F15 LoRA). everest DL ~28G. `s4-h117-f22-raw-everest12/`.

### H118/F23 — raw Bittob11040 (no LoRA)
- Unmodified Bittob @0c04fe92 vs Tok → m>+0.015 (≠F14 LoRA). king DL. `s4-h118-f23-raw-bittob/`.

### H119/F24 — raw af-k1 (no LoRA)
- Unmodified af-k1 @ff6eb4bc vs Tok → m>+0.015 (≠F16 LoRA). n80 ~15/80. `s4-h119-f24-raw-af-k1/`.

### H111/F16 — af-k1 × high-Λ2
- af-k1 @ff6eb4bc + high-Λ2 → m>+0.015. n80 ~11/80 post teacher453. `s4-h111-f16-af-k1/`.

### H114/F19 — raw kevin954 — REFUTED
- kevin954 @3fb79cfb raw → m=**−0.00611** z=−0.62 S_c=0.015≪S_k valid_c (p455). Tear mine-f19-1. `s4-h114-f19-raw-kevin/`.

### H108/F13 — diane613 × high-Λ2 — REFUTED
- diane613 @ad0f3f11 + high-Λ2 → m=**−0.07293** z=−6.59 (p454). `s4-h108-f13-diane613/`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. `experiments/s2-clip-l1-rank/`.

## Seed family queue
| F | family | next |
|---|---|---|
| F5 | Correctness-grounded z | needs verified traj |
| F16–F18/F20–F24 | screens | **live** |
| F25 | raw golden-crown (earning) | **rent next** — 12 free |
| — | earner×high-Λ2 LoRA | F9–F15/F19 dead; F16 open |

## Refuted (keep) — detail `archive/HYPOTHESES-pre-p440.md`

- **H114/F19** raw kevin m=−0.00611 (p455) · **H108/F13** diane m=−0.073 · **H109/F14** Bittob m=−0.058 · **H110/F15** everest m=−0.083
- **H105/F10** TalentPigs m=−0.031 · **H106/F11** pandora m=−0.034 · **H107/F12** golden m=−0.059 · **H104/F9** kevin-LoRA m=−0.014
- **H100/F4** Genesis×Λ2 m=−0.055 · **H102/F7** teacher-zC m=−0.052 · **H103/F8** Genesis-RL m=−0.048
- **H101/F6** ultrashort m=−0.005 · **H98/F1** Tok-RL m=+0.002 · **H97/F3** r256 m=−0.015
- **H96** winner-zA r9 m=+0.009 · **H99/F2** remix m=−0.002 · **H95…H1** α/winner-zA dead
- Screens live: **F16–F18, F20–F24**.
