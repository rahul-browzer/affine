# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H39 | high | H28 cell @ **lr=3e-5** → m>0.04 | **open** (n80 ~26/80) |
| 2 | H40 | high | H28 cell @ **epochs=3** → m>0.04 | **open** (chall load) |
| 3 | H41 | med | H28 cell @ **lora r=32** → m>0.04 | **open** (chall load) |
| 4 | H42 | med | H28 cell @ **lr=5e-6** → m>0.04 | **open** (bootstrap) |
| 5 | H43 | med | H28 cell @ **α=64 r16** → m>0.04 | **open** (bootstrap) |
| — | H38 | was high | H28 @ epochs=2 | **refuted** m=−0.00037 |
| — | H37 | was high | H28 @ lr=1e-4 | **refuted** m=−0.00088 |
| — | H36…H29 | — | union / ks / TP×ks | **refuted** |
| — | H28 | was high | winner-zA LoRA (m7-init) | **refuted** m=+0.01095 |
| — | H27…H1 | — | α/LoRA/SFT | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H39 — H28 @ lr=3e-5 (non-α)
- **Claim:** mid-LR between H28 1e-5 and H37 1e-4 → m>0.04.
- **Status:** n80 a203 ~26/80. `s4-h39-m7-winner-za-lr3e5/`.

### H40 — H28 @ epochs=3 (non-α)
- **Claim:** 3× epochs on m7×winner-zA@lr1e-5 → m>0.04.
- **Status:** chall loading (poll~12/120). `s4-h40-m7-winner-za-ep3/`.
- Note: H38@ep2 already null — ep3 likely weak; let finish.

### H41 — H28 @ LoRA r=32 (non-α)
- **Claim:** 2× LoRA rank (r32/α64) → m>0.04.
- **Status:** chall loading (poll~20/120). `s4-h41-m7-winner-za-r32/`.

### H42 — H28 @ lr=5e-6 (non-α)
- **Claim:** half H28 LR → less overwrite → m>0.04 (H37 10×LR killed signal).
- **Status:** bootstrap on mine-h42-1. `s4-h42-m7-winner-za-lr5e6/`.

### H43 — H28 @ LoRA α=64 @ r=16 (non-α)
- **Claim:** α×2 at fixed r16 (≠ H41 r32) → m>0.04.
- **Status:** bootstrap on mine-h43-1. `s4-h43-m7-winner-za-a64/`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H38 — m7×winner-zA @ epochs=2
- m=−0.00037 z=−0.06 base×1.145 r=0.672. Near-null; ep≥2 kills H28.
  `s4-h38-m7-winner-za-ep2/results/`.

### H37 — m7×winner-zA @ lr=1e-4
- m=−0.00088 z=−0.14 base×1.040 r=0.744. Near-null; 10×LR kills H28.
  `s4-h37-m7-winner-za-lr1e4/results/`.

### H36 — m7 × UNION(winner-zA ∪ king-self)
- m=+0.00052. `s4-h36-m7-union-za/results/`.

### H35 / H34 / H33…H30 — king-self family
- Best H35 m=+0.01602 still < bar. **m7×ks + TP×ks dead.**

### H29 — king-self LoRA on TalentPigs init
- m=−0.01527. `s4-h29-king-self-clip-l1/results/`.

### H28 — winner-zA LoRA on m7 init
- m=+0.01095 z=1.35 base×1.131 r=0.679. Best single so far; H39–H43 variants.
  `s4-h28-m7-clip-l1-shape/results/`.

### H27 / H23…H1
- See archive + LESSONS. No α / plmk / leary / **any TP×king-self** /
  **any m7×king-self** / m7×union / **H28@lr≥1e-4** / **H28@ep≥2**.
