# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H65 | med | H42 cell @ **lr=5.02e-6** → m>0.04 | **open** (n80 11/80) |
| 2 | H66 | med | H42 cell @ **lr=5.08e-6** → m>0.04 | **open** (chall re-serve) |
| 3 | H67 | med | H42 cell @ **r=19** → m>0.04 | **open** (train) |
| 4 | H61 | med | H42 cell @ **lr=5.15e-6** → m>0.04 | **open** (n80 64/80) |
| 5 | H68 | med | H42 cell @ **lr=4.95e-6** → m>0.04 | **open** (bootstrap) |
| — | H63 | was med | H42 cell @ lr=5.05e-6 | **refuted** m=+0.00424 |
| — | H64 | was med | H42 cell @ r=18 | **refuted** m=+0.02509 (best; z=2.993) |
| — | H62 | was med | H42 cell @ r=20 | **refuted** band×1.273 |
| — | H60 | was med | H42 cell @ lr=5.3e-6 | **refuted** m=+0.01350 |
| — | H59 | was med | H42 cell @ lr=5.75e-6 | **refuted** band×1.273 |
| — | H56 | was med | H42 cell @ r=24 | **refuted** m=+0.00140 |
| — | H58 | was med | H42 cell @ lr=5.1e-6 | **refuted** m=+0.01466 |
| — | H54 | was low | H42 cell @ lr=8e-6 | **refuted** m=+0.01380 |
| — | H57 | was med | H42 cell @ lr=5.25e-6 | **refuted** m=+0.01537 |
| — | H55 | was med | H42 cell @ lr=5.5e-6 | **refuted** band×1.256 |
| — | H51…H42 | — | α/lr/r sweeps | **refuted** (H42 was +0.01613) |
| — | H41…H1 | — | see archive | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H67 — H42 @ LoRA r=19 (non-α) — open
- **Claim:** between H64@r18 best-short and H62@r20 band-dead → m>0.04.
- **Status:** mine-h67-1 eager-hawk-f5 train; preempt264 armed.
  `s4-h67-…/results/pass271_launch.md`.

### H68 — H28 @ lr=4.95e-6 (non-α) — open
- **Claim:** just under H42@5e-6 peak (H53@4e-6 dead) → m>0.04.
- **Status:** mine-h68-1 cosmic-shark-68 bootstrap; preempt264 armed.
  `s4-h68-…/results/pass272_launch.md`.

### H65 — H28 @ lr=5.02e-6 (non-α)
- **Claim:** densest under peak after H60@5.3 REFUTE → m>0.04.
- **Status:** n80 b203 11/80 after recover264 freeze.
  `s4-h65-…/results/pass267_launch.md`.

### H66 — H28 @ lr=5.08e-6 (non-α)
- **Claim:** between H63@5.05 dead and H58@5.1 dead → m>0.04.
- **Status:** merge OK; chall re-serve after king recover (t/k=200 c=000).
  `s4-h66-…/results/pass268_launch.md`.

### H61 — H28 @ lr=5.15e-6 (non-α)
- **Claim:** denser 5.1–5.25 gap → m>0.04.
- **Status:** n80 b203 64/80 (a203 teacher-400); freeze OK.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

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

### H60 — m7×winner-zA @ lr=5.3e-6
- m=+0.01350 z=2.23 base×1.212 r=0.659. Gates OK. **lr=5.3e-6 dead.**
  `s4-h60-…/results/pass267_n80_refute.md`.

### H59 — m7×winner-zA @ lr=5.75e-6
- chall INVALID band×**1.273**; margin 0. **lr=5.75e-6 dead.**
  `s4-h59-…/results/pass261_n80_refute.md`.

### H56 — m7×winner-zA @ LoRA r=24
- m=+0.00140 z=0.15 base×1.188 r=0.679. Gates OK. **r=24 dead.**
  `s4-h56-…/results/pass261_n80_refute.md`.

### H58 / H54 / H57 / H55
- lr5.1 +0.0147 / lr8 +0.0138 / lr5.25 +0.0154 / lr5.5 band×1.256.

### H51…H42 / H41…H1
- See archive + LESSONS. Dead: α-merge / plmk / leary / **TP×ks** /
  **m7×ks** / m7×union / **lr≤2.5e-6∨=4e-6∨=5.05e-6∨=5.1e-6∨=5.25e-6∨=5.3e-6∨=5.5e-6∨=5.75e-6** /
  **lr=6e-6∨7.5e-6∨8e-6** / **lr≥3e-5** / **ep≥2** / **r≤8∨=18∨=20∨=24∨≥32** /
  **α≤8∨=16** / **α≥64** / **clip≥0.08**. Open: H65@5.02 H66@5.08
  H61@5.15 H67@r19 H68@4.95e-6.
