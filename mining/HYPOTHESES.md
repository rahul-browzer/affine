# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H25 | high | TP×Radiant28/m7 α0.90 → m>0.04 | **open** (n80; best clipL1) |
| 2 | H21 | low | TP×sft2 α0.75 → m>0.04 | **open** (n80; α0.75 band risk) |
| 3 | H22 | med | TP×kevin α0.90 → m>0.04 | **open** (n80) |
| 4 | H26 | med | TP×kkk-af α0.90 → m>0.04 | **staged** (lottery; mid clipL1) |
| 5 | H23 | low | TP×Talucampe α0.90 | **open** (DL) |
| 6 | H24 | low | TP×0ronoCris α0.90 | **open** (engines) |
| — | H20 | was med | TP×leary α0.90 | **refuted** m=−0.01168 |
| — | H19/H18/H17/H16 | — | α0.90/0.75 | **refuted** (H16 plmk +0.0097) |
| — | H15–H7 / H6–H1 / H4 | — | band/LoRA/SFT/r-band | **refuted** |
| 7 | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H25 — TalentPigs × Radiant28 ckpt1000-m7 α0.90
- **Claim:** chal-00331 +0.018; **c_clipL1=+0.0435** (best TP-era) → merge m>0.04.
- **Status:** n80 live. `experiments/s4-h25-tp-adambell-m7-a90/`.

### H26 — TalentPigs × bluecolor777/kkk-af α0.90 (staged lottery)
- **Claim:** chal-00262 +0.024 (pre-TP); c_clipL1=+0.0288 mid-pack.
- **Status:** scripts ready; next free slot if no better shaping recipe.

### H21 / H22 / H23 / H24
- H21 n80 ~33/80; H22 ~14/80; H23 DL; H24 engines→n80.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/` (pass 164).

## Refuted (keep)

### H16 — plmk α0.90 (do not requeue)
- m=+0.00970 z=1.48 base×1.146. Parent still high clipL1 (+0.0389) — merge
  did not transfer. **Never relaunch TP×plmk α0.90.**

### H20 / H19 / H18 / H17 / H15–H7 / H6 / H5c / H5b / H5 / H1v2 / H1 / H2 / H4
- See `archive/HYPOTHESES-full-2026-08-07.md` + LESSONS recipes block.
