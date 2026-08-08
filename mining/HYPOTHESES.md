# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H58 | med | H42 cell @ **lr=5.1e-6** → m>0.04 | **open** (n80 a203 ~59/80) |
| 2 | H61 | med | H42 cell @ **lr=5.15e-6** → m>0.04 | **open** (bootstrap) |
| 3 | H62 | med | H42 cell @ **r=20** → m>0.04 | **staged** (next free slot) |
| 4 | H60 | med | H42 cell @ **lr=5.3e-6** → m>0.04 | **open** (merge) |
| 5 | H59 | med | H42 cell @ **lr=5.75e-6** → m>0.04 | **open** (n80 b203) |
| 6 | H56 | med | H42 cell @ **r=24** → m>0.04 | **open** (n80 b203) |
| — | H54 | was low | H42 cell @ lr=8e-6 | **refuted** m=+0.01380 |
| — | H57 | was med | H42 cell @ lr=5.25e-6 | **refuted** m=+0.01537 |
| — | H55 | was med | H42 cell @ lr=5.5e-6 | **refuted** band×1.256 |
| — | H51 | was med | H28 cell @ α=16 | **refuted** m=+0.00855 |
| — | H53 | was med | H42 cell @ lr=4e-6 | **refuted** m=−0.00885 |
| — | H52 | was med | H42 cell @ lr=6e-6 | **refuted** m=+0.01280 |
| — | H50 | was med | H42 cell @ lr=7.5e-6 | **refuted** m=+0.00322 |
| — | H49 | was low | H28 cell @ α=4 | **refuted** m=+0.01174 |
| — | H45 | was med | H28 cell @ lora r=8 | **refuted** m=+0.00819 |
| — | H48 | was med | H42 cell @ lr=1e-6 | **refuted** band×1.269 |
| — | H47 | was med | H28 cell @ α=8 | **refuted** m=+0.00463 |
| — | H46 | was med | H42 cell @ lr=2.5e-6 | **refuted** m=+0.00802 |
| — | H44 | was med | H28 @ clipL1≥0.08 data | **refuted** m=−0.00017 |
| — | H43 | was med | H28 @ α=64 | **refuted** m=+0.01123 |
| — | H42 | was med | H28 @ lr=5e-6 | **refuted** m=+0.01613 |
| — | H41…H37 | — | r32 / ep / lr↑ | **refuted** |
| — | H36…H29 | — | union / ks / TP×ks | **refuted** |
| — | H28 | was high | winner-zA LoRA (m7-init) | **refuted** m=+0.01095 |
| — | H27…H1 | — | α/LoRA/SFT | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H58 — H28 @ lr=5.1e-6 (non-α)
- **Claim:** between H42 5e-6 (+0.016) and dead H57 5.25 → m>0.04.
- **Status:** n80 a203 ~59/80. `pass253_chall_diverse_recover.md`.

### H61 — H28 @ lr=5.15e-6 (non-α)
- **Claim:** denser 5.1–5.25 gap probe → m>0.04.
- **Status:** mine-h61-1 bootstrap. `s4-h61-…/plan.md`.

### H62 — H42 @ LoRA r=20 (non-α) — STAGED
- **Claim:** open r gap denser probe (r16 best / r24 open / r≤8∧r≥32 dead) → m>0.04.
- **Status:** `s4-h62-m7-winner-za-r20/`; next free slot.

### H60 — H28 @ lr=5.3e-6 (non-α)
- **Claim:** between H58 5.1 open and H57 5.25 REFUTE (+0.015) → m>0.04.
- **Status:** mine-h60-1 merge after train.done.

### H59 — H28 @ lr=5.75e-6 (non-α)
- **Claim:** between band-dead H55 5.5e-6 and dead H52 6e-6 → m>0.04.
- **Status:** mine-h59-1 n80 b203. `s4-h59-…/plan.md`.

### H56 — H42 @ LoRA r=24 (non-α)
- **Claim:** open r gap (r≤8∧r≥32 dead) @ lr=5e-6 → m>0.04.
- **Status:** n80 b203 retry.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H54 — m7×winner-zA @ lr=8e-6
- m=+0.01380 z=1.81 base×1.210 r=0.603. Gates OK. **lr=8e-6 dead.**
  `s4-h54-…/results/pass258_n80_refute.md`.

### H57 — m7×winner-zA @ lr=5.25e-6
- m=+0.01537 z=2.32 base×1.192 r=0.624. Gates OK. **lr=5.25e-6 dead.**
  `s4-h57-…/results/pass255_n80_refute.md`.

### H55 — m7×winner-zA @ lr=5.5e-6
- chall INVALID band×**1.256** (baseline_abs 0.147 vs king 0.117); r=0.630.
- margin forced 0. **lr=5.5e-6 dead.** `s4-h55-…/results/pass254_n80_refute.md`.

### H51 / H53 / H52 / H50 / H49 / H45 / H48 / H47 / H46 / H44 / H43 / H42
- α16 / lr4e-6 / lr6e-6 / lr7.5e-6 / α4 / r8 / lr1e-6 band / α8 /
  lr2.5e-6 / clip≥0.08 / α64 / lr5e-6(+0.016 best).

### H41…H29 / H28 / H27…H1
- See archive + LESSONS. Dead: α-merge / plmk / leary / **TP×ks** /
  **m7×ks** / m7×union / **lr≤2.5e-6∨=4e-6∨=5.25e-6∨=5.5e-6** /
  **lr=6e-6∨7.5e-6∨8e-6** / **lr≥3e-5** / **ep≥2** / **r≤8∨r≥32** /
  **α≤8∨=16** / **α≥64** / **clip≥0.08**. Open: H58@5.1 H61@5.15
  H62@r20 H60@5.3 H59@5.75 H56@r24.
