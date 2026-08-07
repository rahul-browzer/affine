# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H36 | high | m7×(winner∪king-self) → m>0.04 | **open** (merge) |
| 2 | H37 | high | H28 cell @ **lr=1e-4** → m>0.04 | **open** (bootstrap) |
| 3 | H38 | high | H28 cell @ **epochs=2** → m>0.04 | **open** (bootstrap) |
| 4 | H35 | med | H30 cell @ **lr=1e-4** → m>0.04 | **open** (merge) |
| 5 | H34 | med | H30 cell @ **epochs=2** → m>0.04 | **open** (merge) |
| — | H33 | was med | H29 @ epochs=2 | **refuted** m=−0.00158 |
| — | H32 | was med | H29 @ lr=3e-5 | **refuted** m=−0.00601 |
| — | H31 | was high | H30 @ lr=3e-5 | **refuted** m=+0.00016 |
| — | H30 | was high | m7×king-self@1ep lr1e-5 | **refuted** m=−0.00316 |
| — | H29 | was high | king-self LoRA (TP-init) | **refuted** m=−0.01527 |
| — | H28 | was high | winner-zA LoRA (m7-init) | **refuted** m=+0.01095 |
| — | H27…H1 | — | α/LoRA/SFT | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H36 — m7 × UNION(winner-zA ∪ king-self)
- **Claim:** union high-L1 z_A on m7 → m>0.04 (H28 best single-source +0.011).
- **Status:** train.done; merge in progress. `s4-h36-m7-union-za/` (794→410 fit).

### H37 — H28 @ lr=1e-4 (non-α)
- **Claim:** 10× LR on m7×winner-zA → m>0.04 after H28 +0.01095.
- **Status:** bootstrap mine-h37-1. `s4-h37-m7-winner-za-lr1e4/`.

### H38 — H28 @ epochs=2 (non-α)
- **Claim:** 2× epochs on m7×winner-zA@lr1e-5 → m>0.04.
- **Status:** bootstrap mine-h38-1. `s4-h38-m7-winner-za-ep2/`.

### H35 — H30 @ lr=1e-4 (non-α)
- **Claim:** 10× LR on m7×king-self → m>0.04 after H30/H31 near-null.
- **Status:** train.done; merge. `s4-h35-m7-king-self-lr1e4/`.

### H34 — H30 @ epochs=2 (non-α)
- **Claim:** 2× epochs on m7×king-self@lr1e-5 → m>0.04.
- **Status:** train.done; merge writing. `s4-h34-m7-king-self-ep2/`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H33 — TP×king-self @ epochs=2
- m=−0.00158 z=−0.19 base×0.940 r=0.768. Near-null; gates OK.
  `s4-h33-tp-king-self-ep2/results/`.

### H32 — TP×king-self @ lr=3e-5
- m=−0.00601 z=−0.84 base×0.939 r=0.867 S_c=−0.0027 (a198 slice).
  `s4-h32-tp-king-self-lr3e5/results/`. **TP×king-self family dead.**

### H31 — m7×king-self @ lr=3e-5
- m=+0.00016 z=0.025 base×1.077 r=0.764. Near-null; gates OK.
  `s4-h31-m7-king-self-lr3e5/results/`.

### H30 — m7×king-self @ lr=1e-5
- m=−0.00316 z=−0.37 base×1.165 r=0.679 S_c=0.024 S_k=0.027.
  Gates OK; Λ2_c≪king. `s4-h30-m7-king-self/results/`.

### H29 — king-self LoRA on TalentPigs init
- m=−0.01527 z=−1.56 base×0.948 r=0.841. `s4-h29-king-self-clip-l1/results/`.

### H28 — winner-zA LoRA on m7 init
- m=+0.01095 z=1.35 base×1.131 r=0.679 (gates OK). < submit bar.
  `s4-h28-m7-clip-l1-shape/results/`. Best single so far; H37/H38 variants.

### H27 / H23…H1
- See archive + LESSONS. No α / plmk / leary / H30@1e-5 / H31@3e-5 /
  **any TP×king-self**.
