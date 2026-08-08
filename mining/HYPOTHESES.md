# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H85 | med | **Tok-init** × winner-zA@r27 → m>0.04 | **open** (n80 ~16/80) |
| 2 | H86 | med | **Tok-init** × winner-zA@r28 → m>0.04 | **open** (recover→n80) |
| 3 | H87 | med | **Tok-init** × winner-zA@r29 → m>0.04 | **open** (bootstrap) |
| 4 | H88 | med | **Tok-init** × winner-zA@r30 → m>0.04 | **open** (bootstrap) |
| 5 | H89 | med | **Tok-init** × winner-zA@r31 → m>0.04 | **open** (bootstrap) |
| — | H83 | was med | **Tok-init** × winner-zA@r25 vs Tok | **refuted** m=+0.001012 |
| — | H84 | was med | **Tok-init** × winner-zA@r26 vs Tok | **refuted** m=−0.002423 |
| — | H82 | was med | **Tok-init** × winner-zA@r23 vs Tok | **refuted** m=−0.004388 |
| — | H81 | was med | **Tok-init** × winner-zA@r22 vs Tok | **refuted** m=+0.008811 |
| — | H80 | was med | **Tok-init** × winner-zA@r17 vs Tok | **refuted** m=−0.000821 |
| — | H79 | was med | **Tok-init** × winner-zA@r18 vs Tok | **refuted** m=−0.007836 |
| — | H77…H1 | — | see archive / below | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H85 — Tok-init × winner-zA @ r=27 (non-α) — open
- **Claim:** Tok-init r=27 → m>0.04.
- **Status:** n80 a203 **~16/80** + mid304.
  `…/pass326_recover_n80.md`.

### H86 — Tok-init × winner-zA @ r=28 (non-α) — open
- **Claim:** Tok-init r=28 → m>0.04.
- **Status:** recover264 settle→w1 @15:37Z; ports 200; n80 pending.
  `…/pass324_launch.md`.

### H87 — Tok-init × winner-zA @ r=29 (non-α) — open
- **Claim:** after H82@r23 REFUTE, r=29 → m>0.04.
- **Status:** bootstrap DOWNLOAD tok-init. `…/pass326_launch.md`.

### H88 — Tok-init × winner-zA @ r=30 (non-α) — open
- **Claim:** after H84@r26 REFUTE, r=30 → m>0.04.
- **Status:** bootstrap DOWNLOAD tok-init. `…/pass326_launch.md`.

### H89 — Tok-init × winner-zA @ r=31 (non-α) — open
- **Claim:** after H83@r25 REFUTE, r=31 → m>0.04.
- **Status:** bootstrap launched. `…/pass327_launch.md`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H83 — Tok-init × winner-zA @ r=25
- m=+0.001012 z=0.202 base×0.975 r=0.582 vs Tok. Gates OK. m≈0.
  **Tok-init r=25 dead vs Tok.** `…/pass327_n80_refute.md`.

### H84 — Tok-init × winner-zA @ r=26
- m=−0.002423 z=−0.343 base×0.997 r=0.644 vs Tok. Gates OK. m≤0.
  **Tok-init r=26 dead vs Tok.** `…/pass326_n80_refute.md`.

### H82 — Tok-init × winner-zA @ r=23
- m=−0.004388 z=−0.663 base×0.990 r=0.663 vs Tok. Gates OK. m≤0.
  **Tok-init r=23 dead vs Tok.** `…/pass326_n80_refute.md`.

### H81 — Tok-init × winner-zA @ r=22
- m=+0.008811 z=1.428 base×1.012 r=0.626 vs Tok. Gates OK. Below shortlist
  0.015; first Tok-init **positive** vs Tok. **Tok-init r=22 dead for m>0.04.**
  `…/pass324_n80_refute.md`.

### H80 — Tok-init × winner-zA @ r=17
- m=−0.000821 z=−0.164 base×0.983 r=0.661 vs Tok. Gates OK. Near-null m≤0.
  **Tok-init r=17 dead vs Tok.** `…/pass320_n80_refute.md`.

### H79 — Tok-init × winner-zA @ r=18
- m=−0.007836 z=−1.236 base×0.989 r=0.741 vs Tok. Gates OK. m≤0.
  **Tok-init r=18 dead vs Tok.** `…/pass316_n80_refute.md`.

### H77 — H69@r17 Tok-retarget (m7-init)
- m=−0.021756 z=−2.730 base×1.094 r=0.656 vs Tok. Gates OK. m≤0.
  **m7×r17 dead vs Tok.** `…/pass315_n80_refute.md`.

### H76 — H64@r18 replicate #4 vs Tok
- m=−0.019735 z=−2.969 base×1.062 r=0.715 vs Tok. Gates OK. m≤0.
  **m7×r18 / r=18 dead vs Tok.** `…/pass313_n80_refute.md`.

### H78 — m7×winner-zA @ LoRA r=21
- m=−0.007412 z=−1.030 base×1.095 r=0.619 vs Tok. Gates OK. m≤0.
  **r=21 dead vs Tok.** `…/pass312_n80_refute.md`.

### H75…H70 / H69…H1
- See archive + LESSONS. Dead: α-merge / plmk / leary / **TP×ks** / **m7×ks** /
  m7×union / **lr micro-steps** / **ep≥2** / **r≤8∨=16–24∨≥32** /
  **α≤8∨=16∨≥64** / **clip≥0.08** / king-self / **Tok-init
  r17∨r18∨r22∨r23∨r25∨r26**. Open: **H85–H89**.
