# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H100/F4 | high | Genesis-init × high-Λ2 → m>+0.015 | **open** (merge) |
| 2 | H98/F1 | high | REINFORCE self-L1lift → m>+0.015 | **open** (train) |
| 3 | H97/F3 | high | r=256 breaks LoRA ceiling → m>+0.015 | **open** (n80) |
| 4 | H96 | med | Tok-init r9 → m>0.04 | **open** (n80 live) |
| — | H99/F2 | — | high-Λ2 z_A SFT → m>+0.015 | **refuted** m=−0.00199 |
| — | H95/H94…H1 | — | winner-zA / α / merges | **refuted** (see below) |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H100 / F4 — Non-king base (Genesis-init × high-Λ2) — open
- **Claim:** Genesis @abe89194 init + 1059 high-Λ2 → m>+0.015 vs Tok.
- **Status:** train DONE; **merge writing** (~23 GiB); Tok DL ~16 GiB.
- `experiments/s4-h100-f4-genesis-base/` · `results/pass370_train_merge.md`.

### H98 / F1 — Direct RL on self-L1lift — open
- **Claim:** REINFORCE reward=`clip(self L1lift,±0.1)` on thought tokens.
- **Status:** TRAIN ~step140/200; T/K 200; await train→merge→n80.
- `experiments/s4-h98-f1-rl-l1/` · `results/pass362_king332_refire.md`.

### H97 / F3 — LoRA r=256 ceiling break — open
- **Claim:** r=256/α512 Tok-init × winner-zA can move Λ2.
- **Status:** **n80 ~54/80** a203 + mid304.
- `experiments/s4-h97-f3-r256/` · `results/pass367_n80_mid304.md`.

### H96 — Tok-init r9 — open (draining)
- Last winner-zA cell; retire on resolve; **do not** launch more r-neighbours.
- H96 n80~70/80 b203 + mid304.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Seed family queue (not yet rented)

| F | family | next |
|---|---|---|
| F5 | Correctness-grounded z | needs verified trajectories first |
| F6 | Thought format/length axis | **next rent** (F5 blocked) |

## Refuted (keep)

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
  **F2 high-Λ2-zA data remix** / r≤8∨=11–15∨=16–24∨≥32-as-cell / α≤8∨=16∨≥64 /
  clip≥0.08 / king-self.
  **F3 r=256 and F1 RL are new family screens, not neighbour cells.**
