# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H37 | high | H28 cell @ **lr=1e-4** → m>0.04 | **open** (n80 a203) |
| 2 | H38 | high | H28 cell @ **epochs=2** → m>0.04 | **open** (n80 @5/80) |
| 3 | H39 | high | H28 cell @ **lr=3e-5** → m>0.04 | **open** (train) |
| 4 | H40 | high | H28 cell @ **epochs=3** → m>0.04 | **open** (train) |
| 5 | H41 | med | H28 cell @ **lora r=32** → m>0.04 | **open** (train) |
| — | H36 | was high | m7×union z_A | **refuted** m=+0.00052 |
| — | H35 | was med | H30 @ lr=1e-4 | **refuted** m=+0.01602 |
| — | H34 | was med | H30 @ epochs=2 | **refuted** m=+0.00593 |
| — | H33…H29 | — | TP×ks / m7×ks@1e-5/3e-5 | **refuted** |
| — | H28 | was high | winner-zA LoRA (m7-init) | **refuted** m=+0.01095 |
| — | H27…H1 | — | α/LoRA/SFT | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H37 — H28 @ lr=1e-4 (non-α)
- **Claim:** 10× LR on m7×winner-zA → m>0.04 after H28 +0.01095.
- **Status:** p207 chall double-promptable; n80 a203 started 23:21Z.
  `s4-h37-m7-winner-za-lr1e4/`.

### H38 — H28 @ epochs=2 (non-α)
- **Claim:** 2× epochs on m7×winner-zA@lr1e-5 → m>0.04.
- **Status:** n80 a203 live chall 5/80 king 4/80 (p207 recover).
  `s4-h38-m7-winner-za-ep2/`.

### H39 — H28 @ lr=3e-5 (non-α)
- **Claim:** mid-LR between H28 1e-5 and H37 1e-4 → m>0.04.
- **Status:** train loading on mine-h39-1. `s4-h39-m7-winner-za-lr3e5/`.

### H40 — H28 @ epochs=3 (non-α)
- **Claim:** 3× epochs on m7×winner-zA@lr1e-5 → m>0.04.
- **Status:** train loading on mine-h40-1 (B200). `s4-h40-m7-winner-za-ep3/`.

### H41 — H28 @ LoRA r=32 (non-α)
- **Claim:** 2× LoRA rank (r32/α64) → m>0.04.
- **Status:** train loading on mine-h41-1. `s4-h41-m7-winner-za-r32/`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H36 — m7 × UNION(winner-zA ∪ king-self)
- m=+0.00052 z=0.06 base×1.110 r=0.712. Near-null; union ≠ crown.
  `s4-h36-m7-union-za/results/`.

### H35 — m7×king-self @ lr=1e-4
- m=+0.01602 z=2.45 base×**1.238** r=0.567. Best of m7×ks family but
  fails 3σ/δ; band knife-edge. `s4-h35-m7-king-self-lr1e4/results/`.
  **m7×king-self family dead** (H30/31/34/35).

### H34 — m7×king-self @ epochs=2
- m=+0.00593 z=0.76 base×1.114 r=0.719. `s4-h34-m7-king-self-ep2/results/`.

### H33 — TP×king-self @ epochs=2
- m=−0.00158 z=−0.19 base×0.940 r=0.768. `s4-h33-tp-king-self-ep2/results/`.

### H32 — TP×king-self @ lr=3e-5
- m=−0.00601. **TP×king-self family dead.** `s4-h32-…/results/`.

### H31 / H30 — m7×king-self @ lr=3e-5 / 1e-5
- m=+0.00016 / −0.00316. `s4-h31-…` / `s4-h30-…/results/`.

### H29 — king-self LoRA on TalentPigs init
- m=−0.01527. `s4-h29-king-self-clip-l1/results/`.

### H28 — winner-zA LoRA on m7 init
- m=+0.01095 z=1.35 base×1.131 r=0.679 (gates OK). < submit bar.
  `s4-h28-m7-clip-l1-shape/results/`. Best single so far; H37–H41 variants.

### H27 / H23…H1
- See archive + LESSONS. No α / plmk / leary / **any TP×king-self** /
  **any m7×king-self** / m7×union@H36.
