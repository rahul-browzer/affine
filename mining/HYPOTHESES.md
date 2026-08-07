# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H27 | high | winner-zA LoRA → clipL1≥0.042, m>0.04 | **open** (train live) |
| 2 | H25 | high | TP×Radiant28/m7 α0.90 → m>0.04 | **open** (n80 ~42/80) |
| 3 | H24 | low | TP×0ronoCris α0.90 | **open** (n80 ~2/80) |
| 4 | H26 | med | TP×kkk-af α0.90 → m>0.04 | **open** (merge ~4/16) |
| 5 | H23 | low | TP×Talucampe α0.90 | **open** (B300 FA patched; engines reload) |
| — | H22 | was med | TP×kevin α0.90 | **refuted** m=−0.01179 |
| — | H21 | was low | TP×sft2 α0.75 | **refuted** m=−0.00682 |
| — | H20/H19…H1 | — | α/LoRA/SFT | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H27 — clip-L1 shape via high-L1 winner z_A
- **Claim:** SFT on challenger z_A with clipL1≥0.04 (n=406, mean 0.089) from
  top clip-L1 duels, TalentPigs-init thought LoRA lr=1e-5 → m>0.04.
- **Status:** TRAIN_LAUNCHED pid=2428 GPUs6,7. `s4-h27-clip-l1-shape/`.

### H25 — TalentPigs × Radiant28 ckpt1000-m7 α0.90
- **Claim:** c_clipL1=+0.0435 → merge m>0.04. n80 ~42/80.
- **Status:** `s4-h25-tp-adambell-m7-a90/`.

### H24 / H26 / H23
- H24: probe=ok 17:44Z; n80 live. H26 kkk.done merge~4/16.
  H23: B300 sm_103 FA assert patched (pass170); engines reloading.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H22 — kevin α0.90
- m=−0.01179 z=−1.58 base×1.045 r=0.777. `s4-h22-tp-kevin-a90/results/`.

### H21 — sft2 α0.75
- m=−0.00682 z=−0.70 base×**1.001** (band cleared) r=0.790.
  `s4-h21-tp-sft2/results/`.

### H16 / H20 / H19…H1
- plmk +0.0097 — never relaunch. See archive + LESSONS.
