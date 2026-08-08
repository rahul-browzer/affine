# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H100/F4 | high | Genesis-init × high-Λ2 → m>+0.015 | **open** (merge) |
| 2 | H104/F9 | high | kevin954 × high-Λ2 → m>+0.015 | **open** (bootstrap) |
| 3 | H103/F8 | high | Genesis-init × REINFORCE-L1 → m>+0.015 | **open** (RL) |
| 4 | H98/F1 | high | Tok REINFORCE self-L1lift → m>+0.015 | **open** (merge) |
| 5 | H101/F6 | high | ultrashort≤80 format → m>+0.015 | **open** (merge) |
| 6 | H102/F7 | high | Genesis × teacher z_C → m>+0.015 | **open** (merge) |
| — | H97/F3 | — | r=256 breaks LoRA ceiling | **refuted** m=−0.01506 |
| — | H96 | — | Tok-init r9 → m>0.04 | **refuted** m=+0.00913 |
| — | H99/F2 | — | high-Λ2 z_A SFT → m>+0.015 | **refuted** m=−0.00199 |
| — | H95/H94…H1 | — | winner-zA / α / merges | **refuted** (see below) |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H100 / F4 — Non-king base (Genesis-init × high-Λ2) — open
- **Claim:** Genesis @abe89194 init + 1059 high-Λ2 → m>+0.015 vs Tok.
- **Status:** CPU merge DONE; Tok Range-resume (hub1.27 no-resume) p383.
- `experiments/s4-h100-f4-genesis-base/` · `results/pass383_tok_range_resume.md`.

### H98 / F1 — Direct RL on self-L1lift — open
- **Claim:** REINFORCE reward=`clip(self L1lift,±0.1)` on thought tokens.
- **Status:** n80 attempt1 vs Tok live @21:30Z (engines 200; sampling).
- `experiments/s4-h98-f1-rl-l1/` · `results/pass382_recover264_enoent.md`.

### H101 / F6 — Ultrashort≤80 thought format — open
- **Claim:** Rewrite high-Λ2 z to ≤80-char first-sentence targets; Tok LoRA
  teaches short emit format → m>+0.015 (format axis ≠ F2 selection).
- **Status:** merge DONE; bare chall ENOENT → recover264 a1 (p383).
- `experiments/s4-h101-f6-short-format/` · `results/pass383_recover264.md`.

### H102 / F7 — Teacher z_C SFT on Genesis — open
- **Claim:** Genesis-init × 791 teacher_refs_shortz (z_C) → m>+0.015 vs Tok.
  King-init distill-on-refs already dead (H5c/H6); Genesis lets Λ2 move.
- **Status:** recover a1 mid-load king-seeded (p384); await :8002→n80.
- `experiments/s4-h102-f7-teacher-zc/` · `results/pass384_midload_seed.md`.

### H103 / F8 — Genesis-init REINFORCE-L1lift — open
- **Claim:** F1 RL recipe on Genesis (not Tok) → m>+0.015; Λ2 can move + L1 shaping.
- **Status:** `mine-f8-1` RL train live; teacher/Tok DL bg.
- `experiments/s4-h103-f8-genesis-rl/` · `results/pass377_rent.md`.

### H104 / F9 — kevin954 past-crown × high-Λ2 — open
- **Claim:** `kevin954/Affine-5dfqbbh8ev-sft` @3fb79cfb + 1059 high-Λ2 → m>+0.015.
  Orthogonal to Genesis (F4/F7/F8) and Tok (F1/F6); past crown outside both basins.
- **Status:** `mine-f9-1` bootstrap→kevin DL (rented p379).
- `experiments/s4-h104-f9-kevin-base/` · `results/pass379_rent.md`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Seed family queue (not yet rented)

| F | family | next |
|---|---|---|
| F9 | kevin954 × high-Λ2 (H104) | **live** mine-f9-1 bootstrap |
| F5 | Correctness-grounded z | needs verified trajectories first |

## Refuted (keep)

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
  **F1 RL, F4 Genesis-SFT, F6 format, F7 teacher-z_C, F8 Genesis-RL, F9 kevin-base are family screens, not cells.**
