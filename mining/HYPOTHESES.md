# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H67 | med | H42 cell @ **r=19** → m>0.04 | **open** (n80 ~54/80 old king) |
| 2 | H69 | med | H42 cell @ **r=17** → m>0.04 | **open** (n80 ~17/80 old king) |
| 3 | H71 | med | H42 cell @ **r=16** → m>0.04 vs **Tok** | **open** (bootstrap) |
| 4 | H70 | med | H42 cell @ **lr=5.01e-6** → m>0.04 vs **Tok** | **open** (merge+retarget) |
| 5 | H68 | med | H42 cell @ **lr=4.95e-6** → m>0.04 | **open** (n80 ~55/80 old king) |
| — | H66 | was med | H42 cell @ lr=5.08e-6 | **refuted** m=+0.00976 |
| — | H65 | was med | H42 cell @ lr=5.02e-6 | **refuted** m=+0.01829 |
| — | H61 | was med | H42 cell @ lr=5.15e-6 | **refuted** band×1.262 |
| — | H63 | was med | H42 cell @ lr=5.05e-6 | **refuted** m=+0.00424 |
| — | H64 | was med | H42 cell @ r=18 | **refuted** m=+0.02509 (best; z=2.993) |
| — | H62 | was med | H42 cell @ r=20 | **refuted** band×1.273 |
| — | H60 | was med | H42 cell @ lr=5.3e-6 | **refuted** m=+0.01350 |
| — | H59…H54 | — | lr/r sweeps | **refuted** (see below) |
| — | H51…H42 | — | α/lr/r sweeps | **refuted** (H42 was +0.01613) |
| — | H41…H1 | — | see archive | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H67 — H42 @ LoRA r=19 (non-α) — open
- **Claim:** between H64@r18 best-short and H62@r20 band-dead → m>0.04.
- **Status:** n80 ~54/80 vs TalentPigs (ranking only until Tok re-sim).

### H69 — H42 @ LoRA r=17 (non-α) — open
- **Claim:** below H64@r18 best → m>0.04 (r≤8 dead).
- **Status:** n80 ~17/80 vs TalentPigs.

### H71 — H42 @ LoRA r=16 (non-α) — open
- **Claim:** below H69@r17 → m>0.04 vs **Tok331102** (live).
- **Status:** mine-h71-1 bootstrap. `…/results/pass280_launch.md`.

### H70 — H28 @ lr=5.01e-6 (non-α) — open
- **Claim:** between H42@5e-6 +0.016 and H65@5.02 +0.018 → m>0.04.
- **Status:** merge + Tok retarget DL → n80 vs Tok. `…/pass279_king_retarget.md`.

### H68 — H28 @ lr=4.95e-6 (non-α)
- **Claim:** just under H42@5e-6 peak (H53@4e-6 dead) → m>0.04.
- **Status:** n80 ~55/80 vs TalentPigs (ranking only).

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H66 — m7×winner-zA @ lr=5.08e-6
- m=+0.00976 z=1.718 base×1.187 r=0.658. Gates OK. Far below bar.
  **lr=5.08e-6 dead.** `s4-h66-…/results/pass280_n80_refute.md`.

### H65 — m7×winner-zA @ lr=5.02e-6
- m=+0.01829 z=2.233 base×1.219 r=0.601. Gates OK. 2nd-best; <0.04.
  **lr=5.02e-6 dead.** `s4-h65-…/results/pass276_n80_refute.md`.

### H61 — m7×winner-zA @ lr=5.15e-6
- chall INVALID band×**1.262** (base×1.262) r=0.608. margin 0.
  **lr=5.15e-6 dead.** `s4-h61-…/results/pass273_n80_refute.md`.

### H63 — m7×winner-zA @ lr=5.05e-6
- m=+0.00424 z=0.556 base×1.214 r=0.610. Gates OK. Far below bar.
  **lr=5.05e-6 dead.** `s4-h63-…/results/pass272_n80_refute.md`.

### H64 — m7×winner-zA @ LoRA r=18
- m=+0.02509 z=2.993 base×1.248 r=0.604. Gates OK. Fails 3σ by ~6e-5
  (0.02509 < 3·SE=0.02515). **New best** vs H42 +0.01613; still <0.04.
  **r=18 dead** for submit. `s4-h64-…/results/pass271_n80_refute.md`.

### H62 — m7×winner-zA @ LoRA r=20
- chall INVALID band×**1.273**; margin 0. **r=20 dead.**
  `s4-h62-…/results/pass268_n80_refute.md`.

### H60 / H59 / H56 / H58 / H54 / H57 / H55
- lr5.3 +0.0135 / lr5.75 band×1.273 / r24 +0.0014 / lr5.1 +0.0147 /
  lr8 +0.0138 / lr5.25 +0.0154 / lr5.5 band×1.256.

### H51…H42 / H41…H1
- See archive + LESSONS. Dead: α-merge / plmk / leary / **TP×ks** /
  **m7×ks** / m7×union / **lr≤2.5e-6∨=4e-6∨=5.02∨=5.05∨=5.08∨=5.1∨=5.15∨=5.25∨=5.3∨=5.5∨=5.75** /
  **lr=6e-6∨7.5e-6∨8e-6** / **lr≥3e-5** / **ep≥2** / **r≤8∨=18∨=20∨=24∨≥32** /
  **α≤8∨=16** / **α≥64** / **clip≥0.08**. Open: H70@5.01 H67@r19
  H68@4.95e-6 H69@r17 H71@r16(vs Tok).
