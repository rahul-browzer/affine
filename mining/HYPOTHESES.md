# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.
Pre-p440 refuted prose: `archive/HYPOTHESES-pre-p440.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H113/F18 | high | raw TalentPigs (no LoRA) → m>+0.015 | **open** (n80 ~70) |
| 2 | H112/F17 | high | raw genesis (no LoRA) → m>+0.015 | **open** (n80 ~16) |
| 3 | H120/F25 | high | raw golden-crown (no LoRA) → m>+0.015 | **open** (n80 ~5 retry2) |
| 4 | H117/F22 | high | raw everest12 (no LoRA) → m>+0.015 | **open** (everest DL) |
| 5 | H118/F23 | high | raw Bittob (no LoRA) → m>+0.015 | **open** (Tok DL) |
| — | H121/F26 | high | full-FT (not LoRA) → m>+0.015 | **next rent** |
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

### H113/F18 — raw TalentPigs (no LoRA)
- Unmodified TalentPigs @dbfbb3e2 vs Tok → m>+0.015 (≠F10 LoRA). n80 ~70/80. `s4-h113-f18-raw-talentpigs/`.

### H112/F17 — raw genesis (no LoRA)
- Unmodified genesis @abe89194 vs Tok → m>+0.015. n80 ~16/80. `s4-h112-f17-raw-genesis/`.

### H120/F25 — raw golden-crown (no LoRA)
- Unmodified golden-crown @ee37f4f0 vs Tok → m>+0.015. n80 ~5/80 after chall 400→retry2 e203. `s4-h120-f25-raw-golden/`.

### H117/F22 — raw everest12 (no LoRA)
- Unmodified everest12 @a5ac5311 vs Tok → m>+0.015. everest DL ~47G. `s4-h117-f22-raw-everest12/`.

### H118/F23 — raw Bittob11040 (no LoRA)
- Unmodified Bittob @0c04fe92 vs Tok → m>+0.015. Tok incomplete ~28G. `s4-h118-f23-raw-bittob/`.

### H111/F16 — af-k1 × high-Λ2 — REFUTED
- af-k1 @ff6eb4bc + high-Λ2 LoRA → m=**−0.07623** z=−7.28 λ2_c=−0.019 (p459). Gates clear. Tear mine-f16-1. `s4-h111-f16-af-k1/`.

### H119/F24 — raw af-k1 — REFUTED
- af-k1 @ff6eb4bc raw → m=**−0.08673** z=−8.14 λ2_c=−0.021 (p458). Tear mine-f24-1. `s4-h119-f24-raw-af-k1/`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. `experiments/s2-clip-l1-rank/`.

## Seed family queue
| F | family | next |
|---|---|---|
| F5 | Correctness-grounded z | needs verified traj |
| F17–F18/F22/F23/F25 | screens | **live** (5 pods) |
| F26 | full-FT (not LoRA) | **untried** — next structural rent |
| — | earner×high-Λ2 LoRA | **CLOSED** F9–F16 all ≤0 |

## Refuted (keep) — detail `archive/HYPOTHESES-pre-p440.md`

- **H111/F16** af-k1×Λ2 LoRA m=−0.07623 (p459) · **H119/F24** raw af-k1 m=−0.08673 (p458)
- **H116/F21** raw diane m=−0.07226 (p458) · **H115/F20** raw pandora m=−0.02975 (p457)
- **H114/F19** raw kevin m=−0.00611 (p455) · **H108/F13** diane m=−0.073 · **H109/F14** Bittob m=−0.058
- **H110/F15** everest m=−0.083 · **H105/F10** TalentPigs m=−0.031 · **H106/F11** pandora-LoRA m=−0.034
- **H107/F12** golden m=−0.059 · **H104/F9** kevin-LoRA m=−0.014 · **H100/F4** Genesis×Λ2 m=−0.055
- **H102/F7** teacher-zC m=−0.052 · **H103/F8** Genesis-RL m=−0.048 · **H101/F6** ultrashort m=−0.005
- **H98/F1** Tok-RL m=+0.002 · **H97/F3** r256 m=−0.015 · **H96** r9 m=+0.009 · **H99/F2** remix m=−0.002
- Screens live: **F17–F18, F22, F23, F25**. Next rent: **full-FT F26**.
