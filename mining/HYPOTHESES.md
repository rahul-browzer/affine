# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H58 | med | H42 cell @ **lr=5.1e-6** → m>0.04 | **open** (bootstrap) |
| 2 | H57 | med | H42 cell @ **lr=5.25e-6** → m>0.04 | **open** (king prefreeze p249) |
| 3 | H55 | med | H42 cell @ **lr=5.5e-6** → m>0.04 | **open** (king recover→n80) |
| 4 | H56 | med | H42 cell @ **r=24** → m>0.04 | **open** (chall prefreeze) |
| 5 | H54 | low | H42 cell @ **lr=8e-6** → m>0.04 | **open** (king recover→n80) |
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
- **Claim:** between H42 5e-6 (+0.016) and H57 5.25e-6 → m>0.04.
- **Status:** mine-h58-1 eager-matrix-0d bootstrap. `pass246_launch.md`.

### H57 — H28 @ lr=5.25e-6 (non-α)
- **Claim:** ridge between H42 5e-6 and H55 5.5e-6 → m>0.04.
- **Status:** n80 died king Triton ENOENT @4/80 → p249 chall-seed
  prefreeze. `pass249_king_prefreeze.md`.

### H55 — H28 @ lr=5.5e-6 (non-α)
- **Claim:** between H42 5e-6 and dead H52 6e-6 → m>0.04.
- **Status:** king die @16/80 ConnectError → p248 recover. `pass248_king_recover.md`.

### H56 — H42 @ LoRA r=24 (non-α)
- **Claim:** open r gap (r≤8∧r≥32 dead) @ lr=5e-6 → m>0.04.
- **Status:** chall `__triton_launcher` ENOENT → pass247 prefreeze recover.
  `pass247_chall_prefreeze.md`.

### H54 — H28 @ lr=8e-6 (non-α)
- **Claim:** above dead 7.5e-6 → m>0.04 (**low prior** — H50 collapsed).
- **Status:** king :8001 down @ n80 start → p248 recover. `pass248_king_recover.md`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H51 — H28 @ LoRA α=16 @ r16
- m=+0.00855 z=0.86 base×1.189 r=0.661. Gates OK. **α=16 dead.**
  `s4-h51-…/results/pass246_n80_refute.md`.

### H53 — m7×winner-zA @ lr=4e-6
- m=−0.00885. **lr=4e-6 dead.** `s4-h53-…/results/pass244_n80_refute.md`.

### H52 / H50 / H49 / H45 / H48 / H47 / H46 / H44 / H43 / H42
- lr6e-6 / lr7.5e-6 / α4 / r8 / lr1e-6 band / α8 / lr2.5e-6 / clip≥0.08 /
  α64 / lr5e-6(+0.016 best).

### H41…H29 / H28 / H27…H1
- See archive + LESSONS. Dead: α-merge / plmk / leary / **TP×ks** /
  **m7×ks** / m7×union / **lr≤2.5e-6∨=4e-6** / **lr=6e-6∨7.5e-6** /
  **lr≥3e-5** / **ep≥2** / **r≤8∨r≥32** / **α≤8∨=16** / **α≥64** /
  **clip≥0.08**. Open: H58@5.1e-6 H57@5.25e-6 H55@5.5e-6 H54@8e-6 H56@r24.
