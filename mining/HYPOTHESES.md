# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H19 | med | TalentPigs×kkkk α0.90 → base×≤1.25 and margin>0.04 | **open** (n80 @15:27Z) |
| 2 | H20 | med | TalentPigs×leary α0.90 → base×≤1.25 and margin>0.04 | **open** (n80 retry; false probe cleared) |
| 3 | H18 | low | TalentPigs×Shatoria α0.75 → margin>0.04 | **open** (n80 retry) |
| — | H17 | was high | TP×kkk-af α0.90 → margin>0.04 | **refuted** — m=−0.0037 base×1.133 valid |
| — | H16 | was high | TP×plmk α0.90 → margin>0.04 | **refuted** — m=+0.0097 base×1.146 valid |
| — | H15–H7 | — | α0.75 band cluster | **refuted** — INVALID ×1.85–2.21 |
| — | H6/H5c/H5b/H5/H1v2/H1/H2 | — | LoRA/SFT/merge | **refuted** |
| 8 | H3 | instrumental | clip-L1 lever | **supported** |
| — | H4 | — | r∈[0.70,0.85] | **refuted** |

---

## Open

### H19 — TalentPigs × kkkk α0.90 — n80 live
- **Claim:** α=0.90 after H14 α0.75 band×2.044; margin>0.04.
- **Test:** `mine-h19-1` (eager-eagle-c6); B=`vincentwarrior/…-kkkk`@3ca1ebe6.
- **Status:** king recover @15:20Z → n80 @15:27Z. `experiments/s4-h19-tp-kkkk-a90/`.

### H20 — TalentPigs × leary α0.90 — n80 retry
- **Claim:** α=0.90 after H15 α0.75 band×2.107; margin>0.04.
- **Test:** `mine-h20-1` (swift-lion-ac); B=`leary-criste/…-test`@1e6d6d02.
- **Status:** first "REFUTE" was false probe (chall OOM); cleared; n80 retry @15:27Z. See `results/h20_false_probe.md`.

### H18 — TalentPigs × Shatoria test3 — n80 retry
- **Claim:** α=0.75 weak-B (+0.0017) clears margin>0.04.
- **Test:** `mine-h18-1` (golden-comet-e1); B=`Shatoria/…-test3`@a751418a.
- **Status:** teacher died mid-n80; recovered → retry @15:27Z.

### H3 — clip-L1 lever (supported)
- Spearman with outcome 0.936 (clip-L1) vs 0.711 (Λ2), n=14.

## Refuted

### H17 — TalentPigs × kkk-af α0.90
- n80 m=**−0.00367** z=−0.54; valid; base×**1.133**; r=0.774. Band clear, no crown.
- Detail: `experiments/s4-h17-tp-kkk-a90/results/result.md`.

### H16 — TalentPigs × plmk α0.90
- n80 m=**+0.00970** z=1.48; valid; base×**1.146**; r=0.774. Band clear, below δ.
- Detail: `experiments/s4-h16-tp-plmk-a90/results/result.md`.

### H15 / H14 / H13 / H12 — α0.75 band
- INVALID base× 2.107 / 2.044 / 2.047 / 2.017. α0.90 hedges = H20/H19/H17/H16.

### H11–H7 / H6 / H5c / H5b / H5 / H1v2 / H1 / H2 / H4
- α0.75 band ×1.85–2.21; H6 +0.00330; H5c −0.01640; H5b +0.00322; H1v2 −0.00030; H1 −0.01994; H2 −0.010/+0.007; H4 invented r-band.
