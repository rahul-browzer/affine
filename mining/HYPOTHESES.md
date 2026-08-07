# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H27 | high | winner-zA LoRA (TP-init) → clipL1≥0.042, m>0.04 | **open** (n80 ~3/80) |
| 2 | H28 | high | winner-zA LoRA (**m7-init**) → m>0.04 | **open** (train ~43/51) |
| 3 | H23 | low | TP×Talucampe α0.90 | **open** (king recover178) |
| — | H26 | was med | TP×kkk-af α0.90 | **refuted** m=+0.00592 |
| — | H24 | was low | TP×0ronoCris α0.90 | **refuted** m=−0.00466 |
| — | H25 | was high | TP×Radiant28/m7 α0.90 | **refuted** m=+0.00662 |
| — | H22 | was med | TP×kevin α0.90 | **refuted** m=−0.01179 |
| — | H21 | was low | TP×sft2 α0.75 | **refuted** m=−0.00682 |
| — | H20/H19…H1 | — | α/LoRA/SFT | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H27 — clip-L1 shape via high-L1 winner z_A (TalentPigs init)
- **Claim:** SFT on challenger z_A with clipL1≥0.04 (n=406) from top
  clip-L1 duels, TalentPigs-init thought LoRA lr=1e-5 → m>0.04.
- **Status:** merge OK non-id; chall:8002 up; n80 ~3/80; form watcher re-scp'd.
  `s4-h27-clip-l1-shape/`.

### H28 — same data, m7 init (non-α)
- **Claim:** H25 α-dilution killed m7's clip-L1; keep m7 intact as init +
  same winner-zA LoRA → m>0.04. Pin `Radiant28/…m7` @ `f766293ee878`.
- **Status:** TRAIN ~43/51 loss≈0.36–0.41. `s4-h28-m7-clip-l1-shape/`.

### H23
- King died mid CUDA-graph (Triton `.so`); recover178 launched 18:44Z.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H26 — kkk-af α0.90
- m=+0.00592 z=0.92 base×1.094 r=0.762 (gates OK). `s4-h26-tp-kkk-a90/results/`.

### H24 — 0ronoCris α0.90
- m=−0.00466 z=−0.58 base×1.049 r=0.789 (gates OK). `s4-h24-tp-ronocris-a90/results/`.

### H25 — Radiant28/m7 α0.90
- m=+0.00662 z=0.76 base×1.133 r=0.711 (gates OK). Best clip-L1 B still
  lottery. `s4-h25-tp-adambell-m7-a90/results/`.

### H22 — kevin α0.90
- m=−0.01179 z=−1.58 base×1.045 r=0.777. `s4-h22-tp-kevin-a90/results/`.

### H21 — sft2 α0.75
- m=−0.00682 z=−0.70 base×**1.001** (band cleared) r=0.790.
  `s4-h21-tp-sft2/results/`.

### H16 / H20 / H19…H1
- plmk +0.0097 — never relaunch. See archive + LESSONS.
