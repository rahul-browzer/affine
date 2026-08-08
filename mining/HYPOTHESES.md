# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H54 | med | H42 cell @ **lr=8e-6** → m>0.04 | **open** (bootstrap→train) |
| 2 | H50 | med | H42 cell @ **lr=7.5e-6** → m>0.04 | **open** (n80 a203 ~60/80) |
| 3 | H52 | med | H42 cell @ **lr=6e-6** → m>0.04 | **open** (n80 a203 ~54/80) |
| 4 | H53 | med | H42 cell @ **lr=4e-6** → m>0.04 | **open** (n80 a203 ~44/80) |
| 5 | H51 | med | H28 cell @ **α=16 r16** → m>0.04 | **open** (p241 pre-freeze) |
| — | H49 | was low | H28 cell @ α=4 | **refuted** m=+0.01174 |
| — | H45 | was med | H28 cell @ lora r=8 | **refuted** m=+0.00819 |
| — | H48 | was med | H42 cell @ lr=1e-6 | **refuted** band×1.269 |
| — | H47 | was med | H28 cell @ α=8 | **refuted** m=+0.00463 |
| — | H46 | was med | H42 cell @ lr=2.5e-6 | **refuted** m=+0.00802 |
| — | H44 | was med | H28 @ clipL1≥0.08 data | **refuted** m=−0.00017 |
| — | H43 | was med | H28 @ α=64 | **refuted** m=+0.01123 |
| — | H42 | was med | H28 @ lr=5e-6 | **refuted** m=+0.01613 |
| — | H41…H37 | — | r32 / ep / lr↑ | **refuted** |
| — | H36…H29 | — | union / ks / TP×ks | **refuted** |
| — | H28 | was high | winner-zA LoRA (m7-init) | **refuted** m=+0.01095 |
| — | H27…H1 | — | α/LoRA/SFT | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H54 — H28 @ lr=8e-6 (non-α)
- **Claim:** above H50 7.5e-6 (below dead ≥3e-5) → m>0.04.
- **Status:** mine-h54-1 calm-matrix-9c bootstrap pid=939. `pass241_launch.md`.

### H50 — H28 @ lr=7.5e-6 (non-α)
- **Claim:** 1.5× H42 → m>0.04.
- **Status:** n80 a203 ~60/80. `s4-h50-…/results/`.

### H52 — H28 @ lr=6e-6 (non-α)
- **Claim:** just above H42 5e-6 → m>0.04.
- **Status:** n80 a203 ~54/80. `s4-h52-…/results/`.

### H53 — H28 @ lr=4e-6 (non-α)
- **Claim:** between H46 2.5e-6 and H42 5e-6 → m>0.04.
- **Status:** n80 a203 ~44/80. `s4-h53-…/results/`.

### H51 — H28 @ LoRA α=16 @ r16 (non-α)
- **Claim:** α÷2 vs H28 α32 → m>0.04.
- **Status:** p240 a1_w1 ENOENT despite 45s settle; p241 king-seed +
  pre-freeze before w1. `pass241_chall_prefreeze.md`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H49 — m7×winner-zA @ LoRA α=4
- m=+0.01174 z=1.83 base×1.236 r=0.594. **α=4 dead** (with α≤8).
  `s4-h49-…/results/pass241_n80_refute.md`.

### H45 — m7×winner-zA @ LoRA r=8
- m=+0.00819 z=1.19 base×1.234 r=0.579. **r≤8 dead** (with r≥32).
  `s4-h45-m7-winner-za-r8/results/`.

### H48 — m7×winner-zA @ lr=1e-6
- INVALID base×**1.269** > 1.25. **lr≤1e-6 dead (band).**
  `s4-h48-m7-winner-za-lr1e6/results/`.

### H47 — m7×winner-zA @ LoRA α=8
- m=+0.00463 z=0.64 base×1.209 r=0.642. Weaker than H28; **α≤8 dead.**
  `s4-h47-m7-winner-za-a8/results/`.

### H46 — m7×winner-zA @ lr=2.5e-6
- m=+0.00802 z=1.04 base×1.182 r=0.727. Below H42; **lr≤2.5e-6 dead.**
  `s4-h46-m7-winner-za-lr2e6/results/`.

### H44 — m7×winner-zA @ clipL1≥0.08 data
- m=−0.00017. Data-up kills signal. `s4-h44-…/results/`.

### H43 — m7×winner-zA @ LoRA α=64
- m=+0.01123. Below H42; α↑ no help. `s4-h43-…/results/`.

### H42 — m7×winner-zA @ lr=5e-6
- m=+0.01613 z=1.78. **Best H28-family** but <0.04. `s4-h42-…/results/`.

### H41 / H40 / H39 / H38 / H37
- r32 / ep3 / lr3e-5 / ep2 / lr1e-4 all ≤ H28 or ops-dead.

### H36…H29 / H28 / H27…H1
- See archive + LESSONS. No α-merge / plmk / leary / **TP×ks** /
  **m7×ks** / m7×union / **lr≤2.5e-6** / **lr≥3e-5** / **ep≥2** /
  **r≤8∨r≥32** / **α≤8** / **α≥64** / **clip≥0.08**. H51 α16 still open.
