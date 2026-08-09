# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H112/F17 | high | raw genesis (no LoRA) → m>+0.015 | **open** (bootstrap p439) |
| 2 | H105/F10 | high | TalentPigs × high-Λ2 → m>+0.015 | **open** (n80 f203 ~3/80) |
| 3 | H106/F11 | high | pandora × high-Λ2 → m>+0.015 | **open** (n80 d203 ~14/80) |
| 4 | H108/F13 | high | diane613 × high-Λ2 → m>+0.015 | **open** (n80 ~26/80) |
| 5 | H109/F14 | high | Bittob11040 × high-Λ2 → m>+0.015 | **open** (n80 d203 ~11/80) |
| 6 | H110/F15 | high | everest12 × high-Λ2 → m>+0.015 | **open** (n80 ~15/80) |
| 7 | H111/F16 | high | af-k1 × high-Λ2 → m>+0.015 | **open** (bootstrap) |
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
| — | H95/H94…H1 | — | winner-zA / α / merges | **refuted** (see below) |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H105 / F10 — TalentPigs × high-Λ2 — open
- **Claim:** TalentPigs @dbfbb3e2 + 1059 high-Λ2 → m>+0.015.
- **Status:** n80 f203 ~3/80 vs Tok. `experiments/s4-h105-f10-talentpigs-base/`.

### H106 / F11 — pandora-box × high-Λ2 — open
- **Claim:** pandora @5218b138 + 1059 high-Λ2 → m>+0.015.
- **Status:** p437 n80 d203 (killed a203 longwait). `s4-h106-f11-pandora-base/`.

### H108 / F13 — diane613 × high-Λ2 — open
- **Claim:** diane613 @ad0f3f11 + 1059 high-Λ2 → m>+0.015.
- **Status:** n80 sim alive. `experiments/s4-h108-f13-diane613/`.

### H109 / F14 — Bittob11040 × high-Λ2 — open
- **Claim:** Bittob11040 @0c04fe92 + 1059 high-Λ2 → m>+0.015.
- **Status:** n80 d203 ~8/80. `experiments/s4-h109-f14-bittob/`.

### H110 / F15 — everest12 × high-Λ2 — open
- **Claim:** everest12 @a5ac5311 + 1059 high-Λ2 → m>+0.015 vs Tok.
- **Status:** n80 f203 ~4/80. `s4-h110-f15-everest12/`.

### H111 / F16 — af-k1 × high-Λ2 — open
- **Claim:** af-k1 @ff6eb4bc + 1059 high-Λ2 → m>+0.015 vs Tok.
- **Status:** bootstrap. `experiments/s4-h111-f16-af-k1/`.

### H112 / F17 — raw genesis (no LoRA) — open
- **Claim:** unmodified genesis @abe89194 vs Tok → m>+0.015 (honest panel +0.16).
- **Status:** bootstrap (p439 rent). `experiments/s4-h112-f17-raw-genesis/`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Seed family queue
| F | family | next |
|---|---|---|
| F5 | Correctness-grounded z | needs verified traj |
| F17 | raw genesis no-LoRA | **screening** (mine-f17-1) |
| — | earner×high-Λ2 LoRA | **queue exhausted** (reign set done) |

## Refuted (keep)

### H107 / F12 — golden-crown × high-Λ2
- m=−0.059411 z=−6.64 vs Tok (gates OK). mean_λ2_c −0.01093 ≪ king −0.00303.
- Earner-base under high-Λ2 LoRA worsens Λ2. **F12 closed.**
- `s4-h107-f12-golden-crown/results/result.md`.

### H104 / F9 — kevin954 × high-Λ2
- m=−0.014171 z=−1.14 vs Tok (gates OK). mean_λ2_c −0.01352 ≪ king −0.00228.
- Past-crown base under high-Λ2 LoRA still worsens Λ2. **F9 closed.**
- `s4-h104-f9-kevin-base/results/result.md`.

### H100 / F4 — Genesis-init × high-Λ2
- m=−0.054885 z=−5.93 vs Tok (gates OK). mean_λ2_c −0.01886 ≪ king −0.00394.
- Same Genesis Λ2 failure as F7/F8. **F4 closed.**
- `s4-h100-f4-genesis-base/results/result.md`.

### H102 / F7 — Teacher z_C SFT on Genesis
- m=−0.051935 z=−5.72. mean_λ2_c −0.01977 ≪ king −0.00416. **F7 closed.**
- `s4-h102-f7-teacher-zc/results/result.md`.

### H103 / F8 — Genesis-init REINFORCE-L1lift
- m=−0.048287 z=−5.00. mean_λ2_c −0.02090 ≪ king −0.00546. **F8 closed.**
- `s4-h103-f8-genesis-rl/results/result.md`.

### H101 / F6 — Ultrashort≤80 thought format
- m=−0.004532 z=−0.57. mean_λ2_c ≈ king. **F6 closed.**
- `s4-h101-f6-short-format/results/result.md`.

### H98 / F1 — Tok REINFORCE self-L1lift
- m=+0.002291 z=0.42. Λ2 frozen. **F1 closed.**
- `s4-h98-f1-rl-l1/results/result.md`.

### H97 / F3 — LoRA r=256 ceiling break
- m=−0.015058 z=−1.84. Rank≠base. **F3 closed.**
- `s4-h97-f3-r256/results/result.md`.

### H96 — Tok-init × winner-zA @ r=9
- m=+0.009129 z=1.48 < +0.015 CONFIRM. Last winner-zA cell.
- `s4-h96-tok-winner-za-r9/results/result.md`.

### H99 / F2 — high-Λ2 z_A SFT on Tok LoRA
- m=−0.001994 z=−0.26. Data remix ≠ Λ2 under king-LoRA. **F2 closed.**

### H95…H1
- Dead: α/plmk/TP/m7/union/lr/ep≥2/**winner-zA (−0.004)**/F1–F4/F6–F9/F12.
  Screens live: **F10–F11/F13–F17**. Archive + LESSONS.
