# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H79 | med | **Tok-init** × winner-zA@r18 → m>0.04 | **open** (n80 a203) |
| 2 | H80 | med | **Tok-init** × winner-zA@r17 → m>0.04 | **open** (king315) |
| 3 | H81 | med | **Tok-init** × winner-zA@r22 → m>0.04 | **open** (train) |
| 4 | H82 | med | **Tok-init** × winner-zA@r23 → m>0.04 | **open** (bootstrap) |
| 5 | H83 | med | **Tok-init** × winner-zA@r25 → m>0.04 | **open** (bootstrap) |
| — | H77 | was med | H69@r17 **Tok-retarget** vs Tok | **refuted** m=−0.021756 |
| — | H76 | was med | H64@r18 **rep#4** vs Tok | **refuted** m=−0.019735 |
| — | H78 | was med | m7×winner-zA @ r=21 vs Tok | **refuted** m=−0.007412 |
| — | H75…H1 | — | see archive / below | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H79 — Tok-init × winner-zA @ r=18 (non-α) — open
- **Claim:** after m7-init r18 family ≤0 vs Tok, Tok-init same hyp clears Tok.
- **Status:** n80 a203 ~62/80 + mid304.

### H80 — Tok-init × winner-zA @ r=17 (non-α) — open
- **Claim:** Tok-init neighbor of H79 at H69 shortlist rank → m>0.04.
- **Status:** king315 util=0.72 after p314 OOM; chall OK; retry+mid304 armed.

### H81 — Tok-init × winner-zA @ r=22 (non-α) — open
- **Claim:** Tok-init rank step ≥3 from shortlist (r=22 untested) → m>0.04.
- **Status:** train LIVE (BOOTSTRAP_DONE). `…/pass312_launch.md`.

### H82 — Tok-init × winner-zA @ r=23 (non-α) — open
- **Claim:** Tok-init rank neighbor of H81 (r=23 untested) → m>0.04.
- **Status:** bootstrap Tok-init dl. `…/pass313_launch.md`.

### H83 — Tok-init × winner-zA @ r=25 (non-α) — open
- **Claim:** Tok-init r=25 (untested; ∉ dead) after H77 m7×r17 REFUTE → m>0.04.
- **Status:** mine-h83-1 bootstrap @13:44Z. `…/pass315_launch.md`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H77 — H69@r17 Tok-retarget (m7-init)
- m=−0.021756 z=−2.730 base×1.094 r=0.656 vs Tok. Gates OK. m≤0.
  **m7×r17 dead vs Tok** (TalentPigs +0.01641 was ranking-only).
  `…/pass315_n80_refute.md`.

### H76 — H64@r18 replicate #4 vs Tok
- m=−0.019735 z=−2.969 base×1.062 r=0.715 vs Tok. Gates OK. m≤0.
  Fourth failed m7×r18 redraw. **m7×r18 / r=18 dead vs Tok.**
  `…/pass313_n80_refute.md`.

### H78 — m7×winner-zA @ LoRA r=21
- m=−0.007412 z=−1.030 base×1.095 r=0.619 vs Tok. Gates OK. m≤0.
  **r=21 dead vs Tok.** `…/pass312_n80_refute.md`.

### H75 — H64@r18 replicate #3 vs Tok
- m=+0.000550 z=0.101 base×1.095 r=0.560 vs Tok. Gates OK. Near-null.
  Third failed m7×r18 redraw (w/ H72/H74). Closed by H76.
  `…/pass301_n80_refute.md`.

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
- m=+0.01641 z=2.05 base×1.196 r=0.602 vs TalentPigs (ranking-only).
  Below crowning bar. **Tok-retarget H77 REFUTE;** Tok-init twin = H80.
  `…/pass288_n80_refute.md`.

### H68 — m7×winner-zA @ lr=4.95e-6
- chall INVALID band×**1.257**. margin 0. **lr=4.95e-6 dead.**
  `s4-h68-…/results/pass284_n80_refute.md`.

### H67 — m7×winner-zA @ LoRA r=19
- m=+0.01835 z=2.571 base×1.237 r=0.613. Gates OK. <0.04.
  **Shortlist → H73** (now REFUTE vs Tok). `…/pass284_n80_refute.md`.

### H66 — m7×winner-zA @ lr=5.08e-6
- m=+0.00976 z=1.718 base×1.187 r=0.658. Gates OK. Far below bar.
  **lr=5.08e-6 dead.** `s4-h66-…/results/pass280_n80_refute.md`.

### H65 / H64
- H65 lr5.02e-6 +0.01829; H64 r18 +0.02509 (best vs TalentPigs; 3σ miss ~6e-5).
  Both dead vs Tok via H70/H76 family. See archive pass276/271.

### H62…H54 / H51…H1
- See archive + LESSONS. Dead: α-merge / plmk / leary / **TP×ks** / **m7×ks** /
  m7×union / **lr micro-steps** / **ep≥2** / **r≤8∨=16∨=17∨=18∨=19∨=20∨=21∨=24∨≥32** /
  **α≤8∨=16∨≥64** / **clip≥0.08** / king-self. Open: **H79–H83 Tok-init**.
