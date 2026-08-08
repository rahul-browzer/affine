# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H65 | med | H42 cell @ **lr=5.02e-6** → m>0.04 | **open** (merge) |
| 2 | H63 | med | H42 cell @ **lr=5.05e-6** → m>0.04 | **open** (n80 44/80) |
| 3 | H66 | med | H42 cell @ **lr=5.08e-6** → m>0.04 | **open** (train) |
| 4 | H64 | med | H42 cell @ **r=18** → m>0.04 | **open** (n80 ~38/80) |
| 5 | H61 | med | H42 cell @ **lr=5.15e-6** → m>0.04 | **open** (n80 b203 10/80) |
| 6 | H67 | med | H42 cell @ **r=19** → m>0.04 | **queued** (scaffold) |
| 7 | H68 | med | H42 cell @ **lr=4.95e-6** → m>0.04 | **queued** (scaffold) |
| — | H62 | was med | H42 cell @ r=20 | **refuted** band×1.273 |
| — | H60 | was med | H42 cell @ lr=5.3e-6 | **refuted** m=+0.01350 |
| — | H59 | was med | H42 cell @ lr=5.75e-6 | **refuted** band×1.273 |
| — | H56 | was med | H42 cell @ r=24 | **refuted** m=+0.00140 |
| — | H58 | was med | H42 cell @ lr=5.1e-6 | **refuted** m=+0.01466 |
| — | H54 | was low | H42 cell @ lr=8e-6 | **refuted** m=+0.01380 |
| — | H57 | was med | H42 cell @ lr=5.25e-6 | **refuted** m=+0.01537 |
| — | H55 | was med | H42 cell @ lr=5.5e-6 | **refuted** band×1.256 |
| — | H51…H42 | — | α/lr/r sweeps | **refuted** (H42 best +0.01613) |
| — | H41…H1 | — | see archive | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H67 — H42 @ LoRA r=19 (non-α) — queued
- **Claim:** last open int between H64@r18 and H62@r20 band-dead → m>0.04.
- **Status:** scaffold ready; rent on first free slot.
  `s4-h67-…/results/pass269_scaffold.md`.

### H68 — H28 @ lr=4.95e-6 (non-α) — queued
- **Claim:** just under H42@5e-6 peak (H53@4e-6 dead) → m>0.04.
- **Status:** scaffold ready; rent after H67.
  `s4-h68-…/results/pass270_scaffold.md`.

### H65 — H28 @ lr=5.02e-6 (non-α)
- **Claim:** densest under peak after H60@5.3 REFUTE → m>0.04.
- **Status:** mine-h65-1 merge_lora saving → n80.
  `s4-h65-…/results/pass267_launch.md`.

### H66 — H28 @ lr=5.08e-6 (non-α)
- **Claim:** between H63@5.05 open and H58@5.1 dead → m>0.04.
- **Status:** mine-h66-1 train (loading weights); preempt264 armed.
  `s4-h66-…/results/pass268_launch.md`.

### H63 — H28 @ lr=5.05e-6 (non-α)
- **Claim:** densest under peak (H42@5e-6 best ↔ H58@5.1 REFUTE) → m>0.04.
- **Status:** n80 a203 44/80.

### H61 — H28 @ lr=5.15e-6 (non-α)
- **Claim:** denser 5.1–5.25 gap → m>0.04.
- **Status:** n80 b203 10/80 (a203 teacher-400); freeze OK.

### H64 — H42 @ LoRA r=18 (non-α)
- **Claim:** open r gap denser (r16 best-ish / r20 band-dead / r24 dead).
- **Status:** n80 a203 ~38/80.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

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
  **lr=6e-6∨7.5e-6∨8e-6** / **lr≥3e-5** / **ep≥2** / **r≤8∨=20∨=24∨≥32** /
  **α≤8∨=16** / **α≥64** / **clip≥0.08**. Open: H65@5.02 H63@5.05
  H66@5.08 H61@5.15 H64@r18; queued H67@r19 H68@4.95e-6.
