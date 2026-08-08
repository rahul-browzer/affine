# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H104/F9 | high | kevin954 × high-Λ2 → m>+0.015 | **open** (n80 ~58/80 c203) |
| 2 | H105/F10 | high | TalentPigs × high-Λ2 → m>+0.015 | **open** (bootstrap p411) |
| 3 | H100/F4 | high | Genesis-init × high-Λ2 → m>+0.015 | **open** (n80 b203; d203first) |
| 4 | H102/F7 | high | Genesis × teacher z_C → m>+0.015 | **open** (n80 e203) |
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

### H104 / F9 — kevin954 past-crown × high-Λ2 — open
- **Claim:** `kevin954/Affine-5dfqbbh8ev-sft` @3fb79cfb + 1059 high-Λ2 → m>+0.015.
  Orthogonal to Genesis (F4/F7) and Tok (F1/F6); past crown outside both basins.
- **Status:** n80 c203 ~58/80; watcher armed **d203first** (p409).
- `experiments/s4-h104-f9-kevin-base/` · `results/pass409_d203first.md`.

### H105 / F10 — TalentPigs past-crown × high-Λ2 — open
- **Claim:** `TalentPigs/affine-5ekxlcg3fx-abc` @dbfbb3e2 + 1059 high-Λ2 → m>+0.015.
  Reign-3 crown; orthogonal to Genesis/kevin/Tok basins.
- **Status:** mine-f10-1 rented p411; bootstrap/uv-pip; d203first armed at launch.
- `experiments/s4-h105-f10-talentpigs-base/` · `results/pass411_rent.md`.

### H100 / F4 — Non-king base (Genesis-init × high-Λ2) — open
- **Claim:** Genesis @abe89194 init + 1059 high-Λ2 → m>+0.015 vs Tok.
- **Status:** n80 **b203** ~18/80; watcher armed **d203first** (p410).
- `experiments/s4-h100-f4-genesis-base/` · `results/pass410_d203first.md`.

### H102 / F7 — Teacher z_C SFT on Genesis — open
- **Claim:** Genesis-init × 791 teacher_refs_shortz (z_C) → m>+0.015 vs Tok.
  King-init distill-on-refs already dead (H5c/H6); Genesis lets Λ2 move.
- **Status:** n80 **e203** ~14/80 (d203first hash rotate).
- `experiments/s4-h102-f7-teacher-zc/` · `results/pass408_d203first.md`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Seed family queue (not yet rented)

| F | family | next |
|---|---|---|
| F5 | Correctness-grounded z | needs verified trajectories first |

## Refuted (keep)

### H103 / F8 — Genesis-init REINFORCE-L1lift
- m=−0.048287 z=−5.00 vs Tok (gates OK). mean_λ2_c −0.02090 ≪ king −0.00546.
- Genesis-RL worsens Λ2; closes RL-L1 on both Tok (F1) and Genesis. **F8 closed.**
- `s4-h103-f8-genesis-rl/results/result.md`.

### H101 / F6 — Ultrashort≤80 thought format
- m=−0.004532 z=−0.57 vs Tok (gates OK). mean_λ2_c −0.00967 ≈ king −0.00895.
- Format rewrite under Tok-LoRA does not move Λ2 (same freeze as F2). **F6 closed.**
- `s4-h101-f6-short-format/results/result.md`.

### H98 / F1 — Tok REINFORCE self-L1lift
- m=+0.002291 z=0.42 vs Tok (gates OK). mean_λ2_c −0.003044 ≈ king −0.003036.
- Clip-L1 RL on Tok-init cannot move Λ2; screen ≪ +0.015. **F1 closed.**
- `s4-h98-f1-rl-l1/results/result.md`.

### H97 / F3 — LoRA r=256 ceiling break
- m=−0.015058 z=−1.84 vs Tok (gates OK). mean_λ2_c −0.00013 ≈0; king +0.00120.
- High-rank LoRA on king-init still cannot move Λ2. **F3 closed.**
- `s4-h97-f3-r256/results/result.md`.

### H96 — Tok-init × winner-zA @ r=9
- m=+0.009129 z=1.48 vs Tok (gates OK). < +0.015 CONFIRM. Last winner-zA cell.
- `s4-h96-tok-winner-za-r9/results/result.md`.

### H99 / F2 — high-Λ2 z_A SFT on Tok LoRA
- m=−0.001994 z=−0.26 vs Tok (gates OK). mean_λ2_c −0.00154 ≈ king −0.00095.
- Data-axis remix cannot move Λ2 under king-LoRA. **F2 closed.** `s4-h99-…/results/result.md`.

### H95 — Tok-init × winner-zA @ r=10
- m=+0.001489 z=0.24 vs Tok. **r=10 dead.** `s4-h95-…/results/result.md`.

### H94 — Tok-init × winner-zA @ r=11
- m=−0.013746 z=−1.59 vs Tok. **r=11 dead.**

### H91 — Tok-init × winner-zA @ r=12
- m=−0.005604 z=−0.69 vs Tok. **r=12 dead.**

### H93 — Tok-init × winner-zA @ r=15
- m=−0.007210 z=−1.44 vs Tok. **r=15 dead.**

### H92 / H90 / H88 / H89 / H87 / H86 / H85
- r13 +0.0006; r14 −0.0085; r30 +0.0014; r31 −0.0072; r29 +0.0051; r28 −0.0003; r27 −0.0082.

### H83 / H84 / H82 / H81 / H80 / H79 / H77 / H76 / H78
- r25…r17 / m7×r17–21 all dead vs Tok (best H81 +0.0088 <0.015).

### H75…H1
- See archive + LESSONS. Dead: α-merge / plmk / leary / TP×ks / m7×ks /
  m7×union / lr micro / ep≥2 / **winner-zA as a family (mean −0.004)** /
  **F2 high-Λ2-zA data remix** / **F3 r=256 LoRA ceiling** / r≤8∨=9–15∨=16–24∨≥32 /
  α≤8∨=16∨≥64 / clip≥0.08 / king-self.
  **F4 Genesis-SFT, F7 teacher-z_C, F9 kevin-base, F10 TalentPigs are family screens.**
  **F1 Tok-RL / F6 format / F8 Genesis-RL closed.**
