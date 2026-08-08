# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H65 | med | H42 cell @ **lr=5.02e-6** → m>0.04 | **open** (n80 5/80) |
| 2 | H63 | med | H42 cell @ **lr=5.05e-6** → m>0.04 | **open** (n80 75/80) |
| 3 | H66 | med | H42 cell @ **lr=5.08e-6** → m>0.04 | **open** (king recover) |
| 4 | H67 | med | H42 cell @ **r=19** → m>0.04 | **open** (bootstrap) |
| 5 | H61 | med | H42 cell @ **lr=5.15e-6** → m>0.04 | **open** (n80 45/80) |
| 6 | H68 | med | H42 cell @ **lr=4.95e-6** → m>0.04 | **queued** (scaffold) |
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
- **Status:** mine-h67-1 eager-hawk-f5 bootstrap; preempt264 armed.
  `s4-h67-…/results/pass271_launch.md`.

### H68 — H28 @ lr=4.95e-6 (non-α) — queued
- **Claim:** just under H42@5e-6 peak (H53@4e-6 dead) → m>0.04.
- **Status:** scaffold ready; rent on next free slot.
  `s4-h68-…/results/pass270_scaffold.md`.

### H65 — H28 @ lr=5.02e-6 (non-α)
- **Claim:** densest under peak after H60@5.3 REFUTE → m>0.04.
- **Status:** n80 a203 5/80 after recover264 freeze.
  `s4-h65-…/results/pass267_launch.md`.

### H66 — H28 @ lr=5.08e-6 (non-α)
- **Claim:** between H63@5.05 open and H58@5.1 dead → m>0.04.
- **Status:** merge OK; king Triton ENOENT → pass271 relaunch king+merged chall.
  `s4-h66-…/results/pass268_launch.md`.

### H63 — H28 @ lr=5.05e-6 (non-α)
- **Claim:** densest under peak (H42@5e-6 best ↔ H58@5.1 REFUTE) → m>0.04.
- **Status:** n80 a203 75/80.

### H61 — H28 @ lr=5.15e-6 (non-α)
- **Claim:** denser 5.1–5.25 gap → m>0.04.
- **Status:** n80 b203 45/80 (a203 teacher-400); freeze OK.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

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
  **m7×ks** / m7×union / **lr≤2.5e-6∨=4e-6∨=5.1e-6∨=5.25e-6∨=5.3e-6∨=5.5e-6∨=5.75e-6** /
  **lr=6e-6∨7.5e-6∨8e-6** / **lr≥3e-5** / **ep≥2** / **r≤8∨=18∨=20∨=24∨≥32** /
  **α≤8∨=16** / **α≥64** / **clip≥0.08**. Open: H65@5.02 H63@5.05
  H66@5.08 H61@5.15 H67@r19; queued H68@4.95e-6.
