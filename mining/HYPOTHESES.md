# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H100/F4 | high | Genesis-init × high-Λ2 → m>+0.015 | **open** (n80 d203 p417) |
| 2 | H102/F7 | high | Genesis × teacher z_C → m>+0.015 | **open** (n80 e203 ~48/80) |
| 3 | H104/F9 | high | kevin954 × high-Λ2 → m>+0.015 | **open** (n80 d203 ~22/80) |
| 4 | H105/F10 | high | TalentPigs × high-Λ2 → m>+0.015 | **open** (train ~25/60) |
| 5 | H106/F11 | high | pandora × high-Λ2 → m>+0.015 | **open** (train; kingDL af10) |
| 6 | H107/F12 | high | golden-crown × high-Λ2 → m>+0.015 | **open** (train) |
| 7 | H108/F13 | high | diane613 × high-Λ2 → m>+0.015 | **open** (bootstrap p418) |
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

### H100 / F4 — Non-king base (Genesis-init × high-Λ2) — open
- **Claim:** Genesis @abe89194 init + 1059 high-Λ2 → m>+0.015 vs Tok.
- **Status:** p417 killed stale longwait c203; n80 **d203** live (d203first).
- `experiments/s4-h100-f4-genesis-base/` · `results/pass417_kill_stale_c203.md`.

### H102 / F7 — Teacher z_C SFT on Genesis — open
- **Claim:** Genesis-init × 791 teacher_refs_shortz (z_C) → m>+0.015 vs Tok.
  King-init distill-on-refs already dead (H5c/H6); Genesis lets Λ2 move.
- **Status:** n80 **e203** ~47–48/80 (nearest screen).
- `experiments/s4-h102-f7-teacher-zc/` · `results/pass408_d203first.md`.

### H104 / F9 — kevin954 past-crown × high-Λ2 — open
- **Claim:** `kevin954/Affine-5dfqbbh8ev-sft` @3fb79cfb + 1059 high-Λ2 → m>+0.015.
  Orthogonal to Genesis (F4/F7) and Tok (F1/F6); past crown outside both basins.
- **Status:** n80 **d203** ~20–22/80 engines 200.
- `experiments/s4-h104-f9-kevin-base/` · `results/pass412_c203_h32_d203.md`.

### H105 / F10 — TalentPigs past-crown × high-Λ2 — open
- **Claim:** `TalentPigs/affine-5ekxlcg3fx-abc` @dbfbb3e2 + 1059 high-Λ2 → m>+0.015.
  Reign-3 crown; orthogonal to Genesis/kevin/Tok basins.
- **Status:** train live pre-ckpt (GPU6 util~57%); d203first armed.
- `experiments/s4-h105-f10-talentpigs-base/` · `results/pass413_train_launched.md`.

### H106 / F11 — pandora-box past-crown × high-Λ2 — open
- **Claim:** `pandora-box/Affine-5eqdtdzqle-ckpt300-m4` @5218b138 + 1059 high-Λ2 → m>+0.015.
  Reign-1 crown; unused as LoRA train base (H2 only α-merged it).
- **Status:** train live pre-ckpt; teacher+king af10 DL done.
- `experiments/s4-h106-f11-pandora-base/` · `results/pass415_af10_fix.md`.

### H107 / F12 — golden-crown reign-earner × high-Λ2 — open
- **Claim:** `golden-crown/Affine-5Epvn…` @ee37f4f0 + 1059 high-Λ2 → m>+0.015.
  Rolling-set earner; unused as LoRA train base.
- **Status:** train live (post golden-crown DL).
- `experiments/s4-h107-f12-golden-crown/` · `results/pass416_rent.md`.

### H108 / F13 — diane613 reign-earner × high-Λ2 — open
- **Claim:** `diane613/Affine-5CQL…` @ad0f3f11 + 1059 high-Λ2 → m>+0.015.
  Rolling-set earner; H9 only α-merged it (α dead); unused as LoRA train base.
- **Status:** mine-f13-1 rented; bootstrap pip→diane613 DL (p418).
- `experiments/s4-h108-f13-diane613/` · `results/pass418_rent.md`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Seed family queue
| F | family | next |
|---|---|---|
| F5 | Correctness-grounded z | needs verified traj |
| F14 | Bittob11040 / everest12 / af-k1 | after screen or burn headroom |

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

### H95…H85 — Tok-init winner-zA r cells (all dead)
- r10 +0.0015; r11 −0.0137; r12 −0.0056; r15 −0.0072; r13 +0.0006; r14 −0.0085;
  r30 +0.0014; r31 −0.0072; r29 +0.0051; r28 −0.0003; r27 −0.0082.

### H83…H76 — m7×r17–21 / Tok r17–25
- All dead vs Tok (best H81 +0.0088 <0.015). Detail → archive.

### H75…H1
- Dead: α/plmk/leary/TP/m7/union/lr/ep≥2/**winner-zA family (−0.004)**/
  F2/F3/r-cells/α-cells/clip≥0.08/king-self. See archive + LESSONS.
  **Screens live: F4/F7/F9/F10/F11/F12/F13.** Closed: F1/F6/F8.
