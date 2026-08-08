# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H55 | med | H42 cell @ **lr=5.5e-6** → m>0.04 | **open** (bootstrap) |
| 2 | H53 | med | H42 cell @ **lr=4e-6** → m>0.04 | **open** (n80 ~64/80) |
| 3 | H56 | med | H42 cell @ **r=24** → m>0.04 | **open** (bootstrap) |
| 4 | H51 | med | H28 cell @ **α=16 r16** → m>0.04 | **open** (n80 ~12/80) |
| 5 | H54 | low | H42 cell @ **lr=8e-6** → m>0.04 | **open** (train; H50 curve weak) |
| — | H52 | was med | H42 cell @ lr=6e-6 | **refuted** m=+0.01280 |
| — | H50 | was med | H42 cell @ lr=7.5e-6 | **refuted** m=+0.00322 |
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

### H55 — H28 @ lr=5.5e-6 (non-α)
- **Claim:** between H42 5e-6 and dead H52 6e-6 → m>0.04.
- **Status:** mine-h55-1 lunar-shark-0b bootstrap. `pass243_launch.md`.

### H53 — H28 @ lr=4e-6 (non-α)
- **Claim:** between H46 2.5e-6 and H42 5e-6 → m>0.04.
- **Status:** n80 a203 ~64/80. `s4-h53-…/results/`.

### H56 — H42 @ LoRA r=24 (non-α)
- **Claim:** open r gap (r≤8∧r≥32 dead) @ lr=5e-6 → m>0.04.
- **Status:** mine-h56-1 swift-fox-1d bootstrap. `pass243_launch.md`.

### H51 — H28 @ LoRA α=16 @ r16 (non-α)
- **Claim:** α÷2 vs H28 α32 → m>0.04.
- **Status:** n80 b203 ~12/80 (pre-freeze OK). `pass242_prefreeze_ok.md`.

### H54 — H28 @ lr=8e-6 (non-α)
- **Claim:** above dead 7.5e-6 → m>0.04 (prior; now **low prior** — H50 collapsed).
- **Status:** mine-h54-1 train. `pass241_launch.md`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H52 — m7×winner-zA @ lr=6e-6
- m=+0.01280 z=1.82 base×1.201 r=0.608. Below H42; **lr=6e-6 dead.**
  `s4-h52-…/results/pass243_n80_refute.md`.

### H50 — m7×winner-zA @ lr=7.5e-6
- m=+0.00322 z=0.47 base×1.165 r=0.741. Collapsed; **lr=7.5e-6 dead.**
  `s4-h50-…/results/pass243_n80_refute.md`.

### H49 — m7×winner-zA @ LoRA α=4
- m=+0.01174. **α=4 dead** (with α≤8). `s4-h49-…/results/`.

### H45 / H48 / H47 / H46 / H44 / H43 / H42
- r8 / lr1e-6 band / α8 / lr2.5e-6 / clip≥0.08 / α64 / lr5e-6(+0.01613 best).

### H41…H29 / H28 / H27…H1
- See archive + LESSONS. Dead: α-merge / plmk / leary / **TP×ks** /
  **m7×ks** / m7×union / **lr≤2.5e-6** / **lr=6e-6∨7.5e-6** / **lr≥3e-5** /
  **ep≥2** / **r≤8∨r≥32** / **α≤8** / **α≥64** / **clip≥0.08**.
  Open: H53@4e-6 H55@5.5e-6 H54@8e-6 H51@α16 H56@r24.
