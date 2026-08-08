# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H72 | med | H64@r18 **replicate** vs Tok → m>0.04 | **open** (merge) |
| 2 | H74 | med | H64@r18 **rep#2** vs Tok → m>0.04 | **open** (bootstrap) |
| 3 | H70 | med | H42 cell @ **lr=5.01e-6** → m>0.04 vs Tok | **open** (n80 ~34/80) |
| 4 | H73 | med | H67@r19 **replicate** vs Tok → m>0.04 | **open** (merge) |
| 5 | H71 | med | H42 cell @ **r=16** → m>0.04 vs Tok | **open** (recover264 warm) |
| — | H69 | was med | H42 cell @ r=17 | **refuted** m=+0.01641 (old king) |
| — | H68 | was med | H42 cell @ lr=4.95e-6 | **refuted** band×1.257 |
| — | H67 | was med | H42 cell @ r=19 | **refuted** m=+0.01835 (shortlist→H73) |
| — | H66 | was med | H42 cell @ lr=5.08e-6 | **refuted** m=+0.00976 |
| — | H65 | was med | H42 cell @ lr=5.02e-6 | **refuted** m=+0.01829 |
| — | H61 | was med | H42 cell @ lr=5.15e-6 | **refuted** band×1.262 |
| — | H63 | was med | H42 cell @ lr=5.05e-6 | **refuted** m=+0.00424 |
| — | H64 | was med | H42 cell @ r=18 | **refuted** m=+0.02509 (best; z=2.993) |
| — | H62…H1 | — | see archive / below | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H72 — H64@r18 replicate vs Tok (non-α) — open
- **Claim:** re-draw of best cell (+0.02509) vs live king → m>0.04.
- **Status:** merge on mine-h72-1. `…/pass284_launch.md`.

### H74 — H64@r18 replicate #2 vs Tok (non-α) — open
- **Claim:** second independent redraw of H64 cell vs Tok → m>0.04.
- **Status:** bootstrap on mine-h74-1. `…/pass288_launch.md`.

### H70 — H28 @ lr=5.01e-6 (non-α) — open
- **Claim:** between H42@5e-6 +0.016 and H65@5.02 +0.018 → m>0.04.
- **Status:** n80 vs Tok (b203) ~34/80. `…/pass285_n80_vs_tok.md`.

### H73 — H67@r19 replicate vs Tok (non-α) — open
- **Claim:** H67 +0.01835 shortlist re-draw vs Tok → m>0.04.
- **Status:** merge on mine-h73-1. `…/pass284_launch.md`.

### H71 — H42 @ LoRA r=16 (non-α) — open
- **Claim:** below H64@r18 → m>0.04 vs Tok.
- **Status:** recover264 diverse-warm (:8002=200). `…/pass287_recover264.md`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H69 — m7×winner-zA @ LoRA r=17
- m=+0.01641 z=2.05 base×1.196 r=0.602 vs TalentPigs (ranking-only).
  Below crowning bar. **Shortlist-weak; no Tok re-sim.** `…/pass288_n80_refute.md`.

### H68 — m7×winner-zA @ lr=4.95e-6
- chall INVALID band×**1.257**. margin 0. **lr=4.95e-6 dead.**
  `s4-h68-…/results/pass284_n80_refute.md`.

### H67 — m7×winner-zA @ LoRA r=19
- m=+0.01835 z=2.571 base×1.237 r=0.613. Gates OK. <0.04.
  **Shortlist → H73 replicate vs Tok** (not blacklist r=19).
  `s4-h67-…/results/pass284_n80_refute.md`.

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
- m=+0.02509 z=2.993 base×1.248 r=0.604. Fails 3σ by ~6e-5.
  **New best**; replicate as H72 vs Tok (not submit-dead only).
  `s4-h64-…/results/pass271_n80_refute.md`.

### H62 / H60 / H59 / H56 / H58 / H54 / H57 / H55
- r20 band×1.273 / lr5.3 +0.0135 / lr5.75 band / r24 +0.0014 /
  lr5.1 +0.0147 / lr8 +0.0138 / lr5.25 +0.0154 / lr5.5 band×1.256.

### H51…H42 / H41…H1
- See archive + LESSONS. Dead: α-merge / plmk / leary / **TP×ks** /
  **m7×ks** / m7×union / **lr≤2.5e-6∨=4e-6∨=4.95∨=5.02∨=5.05∨=5.08∨=5.1∨=5.15∨=5.25∨=5.3∨=5.5∨=5.75** /
  **lr=6e-6∨7.5e-6∨8e-6** / **lr≥3e-5** / **ep≥2** / **r≤8∨=20∨=24∨≥32** /
  **α≤8∨=16** / **α≥64** / **clip≥0.08**. Open: H70@5.01 H71@r16
  H72@r18-rep H73@r19-rep H74@r18-rep#2 (all vs Tok).
