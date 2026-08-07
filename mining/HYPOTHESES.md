# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H29 | high | king-self LoRA (**TP-init**) → m>0.04 | **open** (n80 ~7/80) |
| 2 | H30 | high | king-self LoRA (**m7-init**) → m>0.04 | **open** (merging) |
| 3 | H31 | high | H30 cell @ **lr=3e-5** → m>0.04 | **open** (king recover191) |
| 4 | H32 | high | H29 cell @ **lr=3e-5** → m>0.04 | **open** (king recover191) |
| 5 | H33 | high | H29 cell @ **epochs=2** → m>0.04 | **open** (bootstrap DL) |
| — | H28 | was high | winner-zA LoRA (m7-init) | **refuted** m=+0.01095 |
| — | H27 | was high | winner-zA LoRA (TP-init) | **refuted** m=−0.00792 |
| — | H23…H1 | — | α/LoRA/SFT | **refuted** |
| — | H3 | instrumental | clip-L1 lever | **supported** (+rank) |

---

## Open

### H29 — king-self high clip-L1 z_A (non-α)
- **Claim:** Train only TalentPigs's own high-L1 thoughts on TP init → m>0.04.
- **Status:** n80 live chall 7/80 king 6/80 (20:20Z). `s4-h29-king-self-clip-l1/`.

### H30 — king-self × m7 init (non-α)
- **Claim:** m7 init + TalentPigs king-self → m>0.04.
- **Status:** train done; merge writing shards; t/k 200. `s4-h30-m7-king-self/`.

### H31 — H30 @ lr=3e-5 (non-α)
- **Claim:** 3× LR on m7×king-self → m>0.04.
- **Status:** merge OK; king Triton-dead → recover191 relaunched.
  `s4-h31-m7-king-self-lr3e5/`.

### H32 — H29 @ lr=3e-5 (non-α)
- **Claim:** 3× LR on TP×king-self → m>0.04.
- **Status:** merge OK; king Triton-dead → recover191 relaunched.
  `s4-h32-tp-king-self-lr3e5/`.

### H33 — H29 @ epochs=2 (non-α)
- **Claim:** 2× epochs on TP×king-self@lr1e-5 → m>0.04.
- **Status:** bootstrap DL TalentPigs (pip/vllm OK). `s4-h33-tp-king-self-ep2/`.

### H3 — clip-L1 lever (supported)
- Spearman 0.936. Offline rank: `experiments/s2-clip-l1-rank/`.

## Refuted (keep)

### H28 — winner-zA LoRA on m7 init
- m=+0.01095 z=1.35 base×1.131 r=0.679 (gates OK). S_c 0.0259 > S_k 0.0148
  but < submit bar. Better than H27; still not crown. `s4-h28-…/results/`.

### H27 — winner-zA LoRA on TalentPigs init
- m=−0.00792 z=−1.34 base×0.962 r=0.818. `s4-h27-clip-l1-shape/results/`.

### H23 — TP×Talucampe α0.90
- m=−0.00777. `s4-h23-tp-talucampe-a90/results/`.

### H26 / H25 / H24 / H22…H1
- See archive + LESSONS. No α / plmk / leary / winner-zA relaunch.
