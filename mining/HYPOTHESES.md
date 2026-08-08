# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H77 | med | H69@r17 **Tok-retarget** → m>0.04 | **open** (n80 a203) |
| 2 | H79 | med | **Tok-init** × winner-zA@r18 → m>0.04 | **open** (n80 a203) |
| 3 | H80 | med | **Tok-init** × winner-zA@r17 → m>0.04 | **open** (king311) |
| 4 | H81 | med | **Tok-init** × winner-zA@r22 → m>0.04 | **open** (bootstrap) |
| 5 | H82 | med | **Tok-init** × winner-zA@r23 → m>0.04 | **open** (bootstrap) |
| — | H76 | was med | H64@r18 **rep#4** vs Tok | **refuted** m=−0.019735 |
| — | H78 | was med | m7×winner-zA @ r=21 vs Tok | **refuted** m=−0.007412 |
| — | H75…H1 | — | see archive / below | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H77 — H69@r17 Tok-retarget (non-α) — open
- **Claim:** r17 shortlist (+0.01641 vs TalentPigs) clears Tok → m>0.04.
- **Status:** n80 a203 ~59/80 + mid304.

### H79 — Tok-init × winner-zA @ r=18 (non-α) — open
- **Claim:** after m7-init r18 family ≤0 vs Tok, Tok-init same hyp clears Tok.
- **Status:** n80 a203 ~31/80 + mid304.

### H80 — Tok-init × winner-zA @ r=17 (non-α) — open
- **Claim:** Tok-init neighbor of H79 at H69 shortlist rank → m>0.04.
- **Status:** king314 isolated TCACHE loading (pid31892→32012); chall OK; retry+mid304 armed.

### H81 — Tok-init × winner-zA @ r=22 (non-α) — open
- **Claim:** Tok-init rank step ≥3 from shortlist (r=22 untested) → m>0.04.
- **Status:** mine-h81-1 bootstrap. `…/pass312_launch.md`.

### H82 — Tok-init × winner-zA @ r=23 (non-α) — open
- **Claim:** Tok-init rank neighbor of H81 (r=23 untested) → m>0.04.
- **Status:** mine-h82-1 bootstrap @13:30Z. `…/pass313_launch.md`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

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
  Below crowning bar. **Tok-retarget = H77;** Tok-init twin = H80.
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

### H65 — m7×winner-zA @ lr=5.02e-6
- m=+0.01829 z=2.233 base×1.219 r=0.601. Gates OK. 2nd-best; <0.04.
  **lr=5.02e-6 dead.** `s4-h65-…/results/pass276_n80_refute.md`.

### H64 — m7×winner-zA @ LoRA r=18
- m=+0.02509 z=2.993 base×1.248 r=0.604. Fails 3σ by ~6e-5 vs TalentPigs.
  **Best vs old king**; H72/H74/H75 redraws vs Tok m≈≤0. H76 last draw.
  `s4-h64-…/results/pass271_n80_refute.md`.

### H62 / H61 / H60 / H59 / H56 / H58 / H54 / H57 / H55
- r20 band×1.273 / lr5.15 band / lr5.3 +0.0135 / lr5.75 band / r24 +0.0014 /
  lr5.1 +0.0147 / lr8 +0.0138 / lr5.25 +0.0154 / lr5.5 band×1.256.

### H51…H42 / H41…H1
- See archive + LESSONS. Dead: α-merge / plmk / leary / **TP×ks** /
  **m7×ks** / m7×union / **lr≤2.5e-6∨=4e-6∨=4.95∨=5.02∨=5.05∨=5.08∨=5.1∨=5.15∨=5.25∨=5.3∨=5.5∨=5.75** /
  **lr=6e-6∨7.5e-6∨8e-6** / **lr≥3e-5** / **ep≥2** / **r≤8∨=16∨=18∨=19∨=20∨=21∨=24∨≥32** /
  **α≤8∨=16** / **α≥64** / **clip≥0.08** / king-self. Open: H77@r17
  H79/H80/H81/H82 Tok-init. Dead also: **lr=5.01e-6** (H70); **r=18** (H76).
