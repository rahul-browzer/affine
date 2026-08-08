# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H82 | med | **Tok-init** × winner-zA@r23 → m>0.04 | **open** (n80 ~46/80) |
| 2 | H83 | med | **Tok-init** × winner-zA@r25 → m>0.04 | **open** (n80 ~15/80) |
| 3 | H84 | med | **Tok-init** × winner-zA@r26 → m>0.04 | **open** (n80 ~30/80) |
| 4 | H85 | med | **Tok-init** × winner-zA@r27 → m>0.04 | **open** (n80+recover+mid304) |
| 5 | H86 | med | **Tok-init** × winner-zA@r28 → m>0.04 | **open** (train) |
| — | H81 | was med | **Tok-init** × winner-zA@r22 vs Tok | **refuted** m=+0.008811 |
| — | H80 | was med | **Tok-init** × winner-zA@r17 vs Tok | **refuted** m=−0.000821 |
| — | H79 | was med | **Tok-init** × winner-zA@r18 vs Tok | **refuted** m=−0.007836 |
| — | H77 | was med | H69@r17 **Tok-retarget** vs Tok | **refuted** m=−0.021756 |
| — | H76 | was med | H64@r18 **rep#4** vs Tok | **refuted** m=−0.019735 |
| — | H78 | was med | m7×winner-zA @ r=21 vs Tok | **refuted** m=−0.007412 |
| — | H75…H1 | — | see archive / below | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H82 — Tok-init × winner-zA @ r=23 (non-α) — open
- **Claim:** Tok-init rank neighbor of H81 (r=23 untested) → m>0.04.
- **Status:** n80 a203 **~46/80** + mid304. `…/pass321_n80_mid304.md`.

### H83 — Tok-init × winner-zA @ r=25 (non-α) — open
- **Claim:** Tok-init r=25 (untested; ∉ dead) → m>0.04.
- **Status:** n80 a203 **~15/80** + mid304. `…/pass323_n80_mid304.md`.

### H84 — Tok-init × winner-zA @ r=26 (non-α) — open
- **Claim:** after H79 Tok-init@r18 REFUTE, r=26 → m>0.04.
- **Status:** n80 **b203** ~30/80 + mid304. `…/pass323_n80_live.md`.

### H85 — Tok-init × winner-zA @ r=27 (non-α) — open
- **Claim:** after H80 Tok-init@r17 REFUTE, r=27 (≥3 step, ∉ dead) → m>0.04.
- **Status:** n80 a203 + mid304 armed; recover274 isolating bare TCACHE.
  `…/pass325_n80_mid304.md`.

### H86 — Tok-init × winner-zA @ r=28 (non-α) — open
- **Claim:** after H81 Tok-init@r22 REFUTE (m=+0.0088), r=28 → m>0.04.
- **Status:** tok_init.done → start_h86 train. `…/pass324_launch.md`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

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

### H75 — H64@r18 replicate #3 vs Tok
- m=+0.000550 z=0.101 base×1.095 r=0.560 vs Tok. Gates OK. Near-null.
  Closed by H76. `…/pass301_n80_refute.md`.

### H74 — H64@r18 replicate #2 vs Tok
- m=−0.011003 z=−0.828 base×1.096 r=0.656 vs Tok. Gates OK. m≤0.
  `…/pass299_n80_refute.md`.

### H73 — H67@r19 replicate vs Tok
- m=−0.005810 z=−0.739 base×1.166 r=0.579 vs Tok. Gates OK. m≤0.
  **r=19 dead vs Tok.** `…/pass296_n80_refute.md`.

### H72 — H64@r18 replicate vs Tok
- m=−0.009356 z=−1.334 base×1.113 r=0.658 vs Tok. Gates OK. m≤0.
  `…/pass296_n80_refute.md`.

### H71 — m7×winner-zA @ LoRA r=16
- m=−0.013655 z=−2.344 base×1.100 r=0.609 vs Tok. Gates OK. m≤0.
  **r=16 dead.** `s4-h71-…/results/pass295_n80_refute.md`.

### H70 — m7×winner-zA @ lr=5.01e-6
- m=−0.000525 z=−0.067 base×1.114 r=0.638 vs Tok. Gates OK. m≤0.
  **lr=5.01e-6 dead.** `s4-h70-…/results/pass291_n80_refute.md`.

### H69 — m7×winner-zA @ LoRA r=17
- m=+0.01641 z=2.05 vs TalentPigs (ranking-only). Tok-retarget H77 REFUTE;
  Tok-init twin H80 also REFUTE. `…/pass288_n80_refute.md`.

### H68…H54 / H51…H1
- See archive + LESSONS. Dead: α-merge / plmk / leary / **TP×ks** / **m7×ks** /
  m7×union / **lr micro-steps** / **ep≥2** / **r≤8∨=16∨=17∨=18∨=19∨=20∨=21∨=24∨≥32** /
  **α≤8∨=16∨≥64** / **clip≥0.08** / king-self / **Tok-init r17∨r18∨r22**.
  Open: **H82–H86**.
