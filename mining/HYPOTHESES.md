# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H25 | high | TP×Radiant28/m7 α0.90 → m>0.04 | **open** (n80 live; best clipL1) |
| 2 | H26 | med | TP×kkk-af α0.90 → m>0.04 | **open** (bootstrap DL) |
| 3 | H23 | low | TP×Talucampe α0.90 | **open** (merge ~14/16) |
| 4 | H24 | low | TP×0ronoCris α0.90 | **open** (chall Triton relaunch) |
| — | H22 | was med | TP×kevin α0.90 | **refuted** m=−0.01179 |
| — | H21 | was low | TP×sft2 α0.75 | **refuted** m=−0.00682 |
| — | H20/H19…H1 | — | α/LoRA/SFT | **refuted** |
| 5 | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H25 — TalentPigs × Radiant28 ckpt1000-m7 α0.90
- **Claim:** c_clipL1=+0.0435 → merge m>0.04.
- **Status:** n80 live after king recover (pass 166). `s4-h25-tp-adambell-m7-a90/`.

### H26 — TalentPigs × bluecolor777/kkk-af α0.90
- **Claim:** mid clipL1 lottery. Bootstrap on mine-h26-1. `s4-h26-tp-kkk-a90/`.

### H23 / H24
- H23 merge~14/16. H24 false-probe + chall `__triton_launcher` death → relaunch.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H22 — kevin α0.90
- m=−0.01179 z=−1.58 base×1.045 r=0.777. `s4-h22-tp-kevin-a90/results/`.

### H21 — sft2 α0.75
- m=−0.00682 z=−0.70 base×**1.001** (band cleared) r=0.790. α0.75≠always band-fail.
  `s4-h21-tp-sft2/results/`.

### H16 / H20 / H19…H1
- plmk +0.0097 — never relaunch. See archive + LESSONS.
