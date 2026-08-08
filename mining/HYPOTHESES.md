# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H74 | med | H64@r18 **rep#2** vs Tok → m>0.04 | **open** (n80 ~71/80) |
| 2 | H75 | med | H64@r18 **rep#3** vs Tok → m>0.04 | **open** (n80 ~58/80) |
| 3 | H76 | med | H64@r18 **rep#4** vs Tok → m>0.04 | **open** (n80 started) |
| 4 | H77 | med | H69@r17 **Tok-retarget** → m>0.04 | **open** (merging) |
| 5 | H78 | med | r=21 untested vs Tok → m>0.04 | **open** (merging) |
| — | H73 | was med | H67@r19 replicate vs Tok | **refuted** m=−0.005810 |
| — | H72 | was med | H64@r18 replicate vs Tok | **refuted** m=−0.009356 |
| — | H71 | was med | H42 cell @ r=16 | **refuted** m=−0.013655 |
| — | H70 | was med | H42 cell @ lr=5.01e-6 | **refuted** m=−0.000525 |
| — | H69 | was med | H42 cell @ r=17 | **refuted** m=+0.01641 (old king) |
| — | H68…H1 | — | see archive / below | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H74 — H64@r18 replicate #2 vs Tok (non-α) — open
- **Claim:** second independent redraw of H64 cell vs Tok → m>0.04.
- **Status:** n80 vs Tok a203 ~71/80. `…/pass294_salvage_n80.md`.

### H75 — H64@r18 replicate #3 vs Tok (non-α) — open
- **Claim:** third independent redraw of H64 cell vs Tok → m>0.04.
- **Status:** n80 vs Tok a203 ~58/80. `…/pass291_launch.md`.

### H76 — H64@r18 replicate #4 vs Tok (non-α) — open
- **Claim:** fourth independent redraw of H64 cell vs Tok → m>0.04.
- **Status:** n80 vs Tok a203 started 12:12Z after stale-retry
  refresh + recover264. `…/pass298_n80_start.md`.

### H77 — H69@r17 Tok-retarget (non-α) — open
- **Claim:** r17 shortlist (+0.01641 vs TalentPigs) clears Tok → m>0.04.
- **Status:** train.done; merging; teacher/king 200. `…/pass296_launch.md`.

### H78 — m7×winner-zA @ r=21 vs Tok (non-α) — open
- **Claim:** untested rank between shortlist and band-fail ranks → m>0.04.
- **Status:** train.done; merging shards. `…/pass296_launch.md`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H73 — H67@r19 replicate vs Tok
- m=−0.005810 z=−0.739 base×1.166 r=0.579 vs Tok. Gates OK. m≤0.
  **r=19 dead vs Tok.** `…/pass296_n80_refute.md`.

### H72 — H64@r18 replicate vs Tok
- m=−0.009356 z=−1.334 base×1.113 r=0.658 vs Tok. Gates OK. m≤0.
  One negative draw; H74/H75/H76 still resolve r18 vs Tok.
  `…/pass296_n80_refute.md`.

### H71 — m7×winner-zA @ LoRA r=16
- m=−0.013655 z=−2.344 base×1.100 r=0.609 vs Tok. Gates OK. m≤0.
  **r=16 dead.** `s4-h71-…/results/pass295_n80_refute.md`.

### H70 — m7×winner-zA @ lr=5.01e-6
- m=−0.000525 z=−0.067 base×1.114 r=0.638 vs Tok. Gates OK. m≤0.
  **lr=5.01e-6 dead.** `s4-h70-…/results/pass291_n80_refute.md`.

### H69 — m7×winner-zA @ LoRA r=17
- m=+0.01641 z=2.05 base×1.196 r=0.602 vs TalentPigs (ranking-only).
  Below crowning bar. **Tok-retarget = H77.** `…/pass288_n80_refute.md`.

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

### H61 — m7×winner-zA @ lr=5.15e-6
- chall INVALID band×**1.262**. margin 0. **lr=5.15e-6 dead.**
  `s4-h61-…/results/pass273_n80_refute.md`.

### H63 — m7×winner-zA @ lr=5.05e-6
- m=+0.00424 z=0.556 base×1.214 r=0.610. **lr=5.05e-6 dead.**
  `s4-h63-…/results/pass272_n80_refute.md`.

### H64 — m7×winner-zA @ LoRA r=18
- m=+0.02509 z=2.993 base×1.248 r=0.604. Fails 3σ by ~6e-5 vs TalentPigs.
  **Best vs old king**; H72 redraw vs Tok m=−0.009. Keep H74–H76.
  `s4-h64-…/results/pass271_n80_refute.md`.

### H62 / H60 / H59 / H56 / H58 / H54 / H57 / H55
- r20 band×1.273 / lr5.3 +0.0135 / lr5.75 band / r24 +0.0014 /
  lr5.1 +0.0147 / lr8 +0.0138 / lr5.25 +0.0154 / lr5.5 band×1.256.

### H51…H42 / H41…H1
- See archive + LESSONS. Dead: α-merge / plmk / leary / **TP×ks** /
  **m7×ks** / m7×union / **lr≤2.5e-6∨=4e-6∨=4.95∨=5.02∨=5.05∨=5.08∨=5.1∨=5.15∨=5.25∨=5.3∨=5.5∨=5.75** /
  **lr=6e-6∨7.5e-6∨8e-6** / **lr≥3e-5** / **ep≥2** / **r≤8∨=16∨=19∨=20∨=24∨≥32** /
  **α≤8∨=16** / **α≥64** / **clip≥0.08**. Open: H74–H76@r18 H77@r17 H78@r21
  (all vs Tok). Dead also: **lr=5.01e-6** (H70).
