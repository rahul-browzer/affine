# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H28 | high | winner-zA LoRA (**m7-init**) → m>0.04 | **open** (n80 ~15/80) |
| 2 | H30 | high | king-self LoRA (**m7-init**) → m>0.04 | **open** (bootstrap) |
| 3 | H29 | high | king-self LoRA (**TP-init**) → m>0.04 | **open** (train ~9/46) |
| — | H27 | was high | winner-zA LoRA (TP-init) | **refuted** m=−0.00792 |
| — | H23 | was low | TP×Talucampe α0.90 | **refuted** m=−0.00777 |
| — | H26 | was med | TP×kkk-af α0.90 | **refuted** m=+0.00592 |
| — | H24 | was low | TP×0ronoCris α0.90 | **refuted** m=−0.00466 |
| — | H25 | was high | TP×Radiant28/m7 α0.90 | **refuted** m=+0.00662 |
| — | H22…H1 | — | α/LoRA/SFT | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H28 — same data, m7 init (non-α)
- **Claim:** H25 α-dilution killed m7's clip-L1; keep m7 intact as init +
  same winner-zA LoRA → m>0.04. Pin `Radiant28/…m7` @ `f766293ee878`.
- **Status:** n80 attempt1 live ~15/80. Poll progress → decision.
  `s4-h28-m7-clip-l1-shape/`.

### H30 — king-self × m7 init (non-α)
- **Claim:** missing 2×2 cell: m7 init + TalentPigs king-self high-L1 z_A
  → m>0.04. Independent of H28/H29.
- **Status:** mine-h30-1 bootstrap (pip+m7 dl); 686ex uploaded; form+retry
  armed. `s4-h30-m7-king-self/`.

### H29 — king-self high clip-L1 z_A (non-α)
- **Claim:** H27 failed from mixed foreign z_A; train only TalentPigs's own
  high-L1 thoughts on TP init → m>0.04.
- **Status:** train relaunch 368ex; step~9/46 loss@5=0.666.
  `s4-h29-king-self-clip-l1/`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H27 — winner-zA LoRA on TalentPigs init
- m=−0.00792 z=−1.34 base×0.962 r=0.818 (gates OK). S_c 0.0116 < S_k 0.0192.
  `s4-h27-clip-l1-shape/results/`.

### H23 — TP×Talucampe α0.90
- m=−0.00777 z=−1.08 base×1.079 r=0.774 (gates OK). `s4-h23-tp-talucampe-a90/results/`.

### H26 — kkk-af α0.90
- m=+0.00592 z=0.92 base×1.094 r=0.762. `s4-h26-tp-kkk-a90/results/`.

### H24 — 0ronoCris α0.90
- m=−0.00466 z=−0.58 base×1.049 r=0.789. `s4-h24-tp-ronocris-a90/results/`.

### H25 — Radiant28/m7 α0.90
- m=+0.00662 z=0.76 base×1.133 r=0.711. `s4-h25-tp-adambell-m7-a90/results/`.

### H22 / H21 / H16 / H20 / H19…H1
- See archive + LESSONS. No α / plmk / leary relaunch.
