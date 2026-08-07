# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H30 | high | king-self LoRA (**m7-init**) → m>0.04 | **open** (n80 ~59/80) |
| 2 | H31 | high | H30 cell @ **lr=3e-5** → m>0.04 | **open** (n80 ~49/80) |
| 3 | H32 | high | H29 cell @ **lr=3e-5** → m>0.04 | **open** (n80 ~15/80) |
| 4 | H33 | high | H29 cell @ **epochs=2** → m>0.04 | **open** (n80 started) |
| 5 | H34 | high | H30 cell @ **epochs=2** → m>0.04 | **open** (train live) |
| — | H29 | was high | king-self LoRA (TP-init) | **refuted** m=−0.01527 |
| — | H28 | was high | winner-zA LoRA (m7-init) | **refuted** m=+0.01095 |
| — | H27 | was high | winner-zA LoRA (TP-init) | **refuted** m=−0.00792 |
| — | H23…H1 | — | α/LoRA/SFT | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H30 — king-self × m7 init (non-α)
- **Claim:** m7 init + TalentPigs king-self → m>0.04.
- **Status:** n80 ~59/80. `s4-h30-m7-king-self/`.

### H31 — H30 @ lr=3e-5 (non-α)
- **Claim:** 3× LR on m7×king-self → m>0.04.
- **Status:** n80 ~49/80 post-recover193. `s4-h31-m7-king-self-lr3e5/`.

### H32 — H29 @ lr=3e-5 (non-α)
- **Claim:** 3× LR on TP×king-self → m>0.04.
- **Status:** n80 ~15/80 (retry after early teacher 400s). `s4-h32-tp-king-self-lr3e5/`.

### H33 — H29 @ epochs=2 (non-α)
- **Claim:** 2× epochs on TP×king-self@lr1e-5 → m>0.04.
- **Status:** n80 started pass196 after chall completions OK. `s4-h33-tp-king-self-ep2/`.

### H34 — H30 @ epochs=2 (non-α)
- **Claim:** 2× epochs on m7×king-self@lr1e-5 → m>0.04.
- **Status:** train live (pid 2294); teacher+king DL done. `s4-h34-m7-king-self-ep2/`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H29 — king-self LoRA on TalentPigs init
- m=−0.01527 z=−1.56 base×0.948 r=0.841 S_c=0.008 S_k=0.024.
  Gates OK; loses hard. `s4-h29-king-self-clip-l1/results/`.

### H28 — winner-zA LoRA on m7 init
- m=+0.01095 z=1.35 base×1.131 r=0.679 (gates OK). < submit bar.
  `s4-h28-…/results/`.

### H27 — winner-zA LoRA on TalentPigs init
- m=−0.00792 z=−1.34 base×0.962 r=0.818. `s4-h27-clip-l1-shape/results/`.

### H23 / H26 / H25 / H24 / H22…H1
- See archive + LESSONS. No α / plmk / leary / winner-zA / TP×king-self@1ep.
