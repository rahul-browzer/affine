# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H48 | med | H42 cell @ **lr=1e-6** → m>0.04 | **open** (bootstrap) |
| 2 | H46 | med | H42 cell @ **lr=2.5e-6** → m>0.04 | **open** (train) |
| 3 | H47 | med | H28 cell @ **α=8 r16** → m>0.04 | **open** (bootstrap) |
| 4 | H44 | med | H28 cell @ **clipL1≥0.08** data → m>0.04 | **open** (n80 ~38/80) |
| 5 | H45 | med | H28 cell @ **lora r=8** → m>0.04 | **open** (merge) |
| — | H43 | was med | H28 @ α=64 | **refuted** m=+0.01123 |
| — | H42 | was med | H28 @ lr=5e-6 | **refuted** m=+0.01613 |
| — | H41 | was med | H28 @ r=32 | **refuted** m=+0.00533 |
| — | H40 | was low | H28 @ epochs=3 | **refuted** (ops; ep≥2 dead) |
| — | H39 | was high | H28 @ lr=3e-5 | **refuted** m=+0.00544 |
| — | H38 | was high | H28 @ epochs=2 | **refuted** m=−0.00037 |
| — | H37 | was high | H28 @ lr=1e-4 | **refuted** m=−0.00088 |
| — | H36…H29 | — | union / ks / TP×ks | **refuted** |
| — | H28 | was high | winner-zA LoRA (m7-init) | **refuted** m=+0.01095 |
| — | H27…H1 | — | α/LoRA/SFT | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H48 — H28 @ lr=1e-6 (non-α)
- **Claim:** half H46 LR → continues gentler-LR gain → m>0.04.
- **Status:** bootstrap on mine-h48-1. `s4-h48-m7-winner-za-lr1e6/`.

### H46 — H28 @ lr=2.5e-6 (non-α)
- **Claim:** half H42 LR → continues gentler-LR gain → m>0.04.
- **Status:** train on mine-h46-1. `s4-h46-m7-winner-za-lr2e6/`.

### H47 — H28 @ LoRA α=8 @ r16 (non-α)
- **Claim:** α÷4 at fixed r16 (opposite H43 α64) → m>0.04.
- **Status:** bootstrap on mine-h47-1. `s4-h47-m7-winner-za-a8/`.

### H44 — H28 @ clipL1≥0.08 data (non-α)
- **Claim:** stricter data (305/406, mean clipL1 0.098) @ H28 hyps → m>0.04.
- **Status:** n80 a203 ~38/80. `s4-h44-m7-winner-za-clip08/`.

### H45 — H28 @ LoRA r=8 (non-α)
- **Claim:** ½ LoRA rank (r8/α16) opposite of H41 → m>0.04.
- **Status:** merge on mine-h45-1. `s4-h45-m7-winner-za-r8/`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H43 — m7×winner-zA @ LoRA α=64
- m=+0.01123 z=1.42 base×1.160 r=0.642. Below H42; α↑ no help.
  `s4-h43-m7-winner-za-a64/results/`.

### H42 — m7×winner-zA @ lr=5e-6
- m=+0.01613 z=1.78 base×1.216 r=0.614. **Best H28-family so far** but <0.04.
  Gentler LR helps vs H28; continue lr↓ (H46/H48). `s4-h42-…/results/`.

### H41 — m7×winner-zA @ LoRA r=32
- m=+0.00533 z=0.78 base×1.157 r=0.674. Below H28; capacity-up no help.
  `s4-h41-m7-winner-za-r32/results/`.

### H40 — m7×winner-zA @ epochs=3
- REFUTE-by-ops: chall never promptable (recover 212–219 Triton races).
  Class already dead via H38 ep2 m=−0.00037. `s4-h40-…/results/`.

### H39 — m7×winner-zA @ lr=3e-5
- m=+0.00544 z=0.85 base×1.105 r=0.584. Below H28; mid-LR no help.
  `s4-h39-m7-winner-za-lr3e5/results/`.

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
- m=+0.01095 z=1.35 base×1.131 r=0.679. Beat by H42 lr↓; H44–H48 variants.
  `s4-h28-m7-clip-l1-shape/results/`.

### H27 / H23…H1
- See archive + LESSONS. No α / plmk / leary / **any TP×king-self** /
  **any m7×king-self** / m7×union / **H28@lr≥3e-5** / **H28@ep≥2** /
  **H28@r≥32** / **H42@lr=5e-6** / **H43@α≥64**.
