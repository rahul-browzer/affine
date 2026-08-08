# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H91 | med | **Tok-init** × winner-zA@r12 → m>0.04 | **open** (n80 ~20/80) |
| 2 | H92 | med | **Tok-init** × winner-zA@r13 → m>0.04 | **open** (n80 ~3/80) |
| 3 | H94 | med | **Tok-init** × winner-zA@r11 → m>0.04 | **open** (chall load) |
| 4 | H93 | med | **Tok-init** × winner-zA@r15 → m>0.04 | **open** (train ~26) |
| 5 | H95 | med | **Tok-init** × winner-zA@r10 → m>0.04 | **open** (bootstrap) |
| — | H90 | was med | **Tok-init** × winner-zA@r14 vs Tok | **refuted** m=−0.008472 |
| — | H88 | was med | **Tok-init** × winner-zA@r30 vs Tok | **refuted** m=+0.001358 |
| — | H89 | was med | **Tok-init** × winner-zA@r31 vs Tok | **refuted** m=−0.007241 |
| — | H87…H81 | — | Tok-init r22–r29 | **refuted** (see below) |
| — | H80…H1 | — | see archive / below | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H91 — Tok-init × winner-zA @ r=12 (non-α) — open
- **Claim:** ≥8 from H81@r22; untested r=12 → m>0.04.
- **Status:** n80 a203 ~20/80 + mid304. `…/pass345_n80_mid304.md`.

### H92 — Tok-init × winner-zA @ r=13 (non-α) — open
- **Claim:** between H91@r12 and dead r14; untested r=13 → m>0.04.
- **Status:** salvage n_so=23 mode=555; n80 a203 + mid304.
  `…/pass346_n80_mid304.md`.

### H93 — Tok-init × winner-zA @ r=15 (non-α) — open
- **Claim:** between dead r14 and dead 16–24; untested r=15 → m>0.04.
- **Status:** train_lora r15 ~step26. `…/pass342_rent.md`.

### H94 — Tok-init × winner-zA @ r=11 (non-α) — open
- **Claim:** between dead ≤8 and live r12; untested r=11 → m>0.04.
- **Status:** merge.done; chall loading. `…/pass343_rent.md`.

### H95 — Tok-init × winner-zA @ r=10 (non-α) — open
- **Claim:** gap dead ≤8 ↔ live r11; untested r=10 → m>0.04.
- **Status:** mine-h95-1 bootstrap. `…/pass346_rent.md`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H90 — Tok-init × winner-zA @ r=14
- m=−0.008472 z=−1.139 base×0.994 r=0.718 vs Tok. Gates OK. m≤0.
  **Tok-init r=14 dead vs Tok.** `…/pass346_n80_refute.md`.

### H88 — Tok-init × winner-zA @ r=30
- m=+0.001358 z=0.228 base×0.977 r=0.676 vs Tok. Gates OK. m≈0.
  **Tok-init r=30 dead vs Tok.** `…/pass343_n80_refute.md`.

### H89 — Tok-init × winner-zA @ r=31
- m=−0.007241 z=−1.282 base×0.982 r=0.659 vs Tok. Gates OK. m≤0.
  **Tok-init r=31 dead vs Tok.** `…/pass342_n80_refute.md`.

### H87 — Tok-init × winner-zA @ r=29
- m=+0.005075 z=0.692 base×0.968 r=0.638 vs Tok. Gates OK. m≈0.
  **Tok-init r=29 dead vs Tok.** `…/pass340_n80_refute.md`.

### H86 — Tok-init × winner-zA @ r=28
- m=−0.000341 z=−0.044 base×0.988 r=0.675 vs Tok. Gates OK. m≤0.
  **Tok-init r=28 dead vs Tok.** `…/pass334_n80_refute.md`.

### H85 — Tok-init × winner-zA @ r=27
- m=−0.008170 z=−1.282 base×0.973 r=0.684 vs Tok. Gates OK. m≤0.
  **Tok-init r=27 dead vs Tok.** `…/pass332_n80_refute.md`.

### H83 / H84 / H82 / H81
- r25 m=+0.001012; r26 m=−0.002423; r23 m=−0.004388; r22 m=+0.008811
  (<0.015). All gates OK. **Tok-init r22–r26 dead for m>0.04.**

### H80 / H79 / H77 / H76 / H78
- r17 m=−0.000821; r18 m=−0.007836; m7×r17 m=−0.021756; m7×r18
  m=−0.019735; r21 m=−0.007412. All dead vs Tok.

### H75…H70 / H69…H1
- See archive + LESSONS. Dead: α-merge / plmk / leary / **TP×ks** / **m7×ks** /
  m7×union / **lr micro-steps** / **ep≥2** / **r≤8∨=14∨=16–24∨≥32** /
  **α≤8∨=16∨≥64** / **clip≥0.08** / king-self / **Tok-init
  r14∨r17∨r18∨r22∨r23∨r25–r31**. Open: **H91–H95** (r12/r13/r15/r11/r10).
