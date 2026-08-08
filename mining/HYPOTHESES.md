# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H63 | med | H42 cell @ **lr=5.05e-6** → m>0.04 | **open** (merge slow; preempt wait) |
| 2 | H61 | med | H42 cell @ **lr=5.15e-6** → m>0.04 | **open** (p266 recover264 fired) |
| 3 | H60 | med | H42 cell @ **lr=5.3e-6** → m>0.04 | **open** (n80 ~68/80) |
| 4 | H64 | med | H42 cell @ **r=18** → m>0.04 | **open** (salvage pre-frozen relaunch) |
| 5 | H62 | med | H42 cell @ **r=20** → m>0.04 | **open** (n80 ~31/80) |
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

### H63 — H28 @ lr=5.05e-6 (non-α)
- **Claim:** densest under peak (H42@5e-6 best ↔ H58@5.1 REFUTE) → m>0.04.
- **Status:** merge writing shard2 (slow); preempt264 waiting.
  `s4-h63-…/results/pass265_merge_slow.md`.

### H61 — H28 @ lr=5.15e-6 (non-α)
- **Claim:** denser 5.1–5.25 gap → m>0.04.
- **Status:** bare mid-n80@21/80 → p266 recover264 fired (attempt1 settle).
  `s4-h61-…/results/pass266_bare_preempt.md`.

### H60 — H28 @ lr=5.3e-6 (non-α)
- **Claim:** between dead 5.25 and band-dead 5.5/5.75 → m>0.04.
- **Status:** n80 a203 ~68/80 isolated freeze OK.

### H64 — H42 @ LoRA r=18 (non-α)
- **Claim:** open r gap denser (r16 best-ish / r20 open / r24 dead).
- **Status:** w1 EngineDead → salvage n_so16→18 pre-frozen relaunch.
  `s4-h64-…/results/pass265_preempt_fired.md`.

### H62 — H42 @ LoRA r=20 (non-α)
- **Claim:** between r16 and dead r24 → m>0.04.
- **Status:** n80 a203 ~31/80 (isolated freeze n_so=23).

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

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
  **m7×ks** / m7×union / **lr≤2.5e-6∨=4e-6∨=5.1e-6∨=5.25e-6∨=5.5e-6∨=5.75e-6** /
  **lr=6e-6∨7.5e-6∨8e-6** / **lr≥3e-5** / **ep≥2** / **r≤8∨=24∨≥32** /
  **α≤8∨=16** / **α≥64** / **clip≥0.08**. Open: H63@5.05 H61@5.15
  H60@5.3 H64@r18 H62@r20.
