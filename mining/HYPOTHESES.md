# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H26 | high | TP×kkk-af@7426296b α0.90 → margin>0.04 | **staged** (next slot) |
| 2 | H25 | high | TP×Radiant28/ckpt1000-m7 α0.90 → margin>0.04 | **open** (engines) |
| 3 | H21 | high | TalentPigs×sft2 α0.75 → margin>0.04 | **open** (n80 ~2/80) |
| 4 | H22 | med | TalentPigs×kevin α0.90 → margin>0.04 | **open** (engines) |
| 5 | H23 | med | TalentPigs×Talucampe ck5 α0.90 → margin>0.04 | **open** (DL) |
| 6 | H24 | low | TalentPigs×0ronoCris α0.90 → margin>0.04 | **open** (DL) |
| — | H20 | was med | TP×leary α0.90 | **refuted** m=−0.01168 |
| — | H19 | was med | TP×kkkk α0.90 | **refuted** m=+0.00348 |
| — | H18 | was low | TP×Shatoria α0.75 | **refuted** band×1.997 |
| — | H17/H16 | was high | α0.90 band-clear near-miss | **refuted** |
| — | H15–H7 | — | α0.75 band cluster | **refuted** |
| — | H6/H5c/H5b/H5/H1v2/H1/H2 | — | LoRA/SFT/merge | **refuted** |
| 7 | H3 | instrumental | clip-L1 lever | **supported** |
| — | H4 | — | r∈[0.70,0.85] | **refuted** |

---

## Open

### H26 — TalentPigs × bluecolor777/kkk-af α0.90 (staged)
- **Claim:** chal-00262 +0.02442 base×0.918 → merge margin>0.04.
- **Test:** next free slot → `mine-h26-1`; B=`bluecolor777/kkk-af`@7426296b0a2d…
- **Status:** scripts ready `experiments/s4-h26-tp-kkk-a90/`. Origin 404.

### H25 — TalentPigs × Radiant28 ckpt1000-m7 α0.90
- **Claim:** chal-00331 +0.01808 → merge margin>0.04.
- **Status:** merge OK; engines loading. `experiments/s4-h25-tp-adambell-m7-a90/`.

### H21 / H22 / H23 / H24
- H21 n80 ~2/80; H22/H25 engines; H23/H24 DL parents.

### H3 — clip-L1 lever (supported)
- Spearman with outcome 0.936 (clip-L1) vs 0.711 (Λ2), n=14.

## Refuted

### H20 — α0.90 leary band-clear, negative margin
- m=**−0.01168** z=−1.54 base×1.118 valid; S_c=0.0218 S_k=0.0333. No crown.

### H19 — α0.90 kkkk band-clear, tiny margin
- m=**+0.00348** z=0.59 base×1.121 valid; S_c=0.0313 S_k=0.0279. No crown.

### H18 — α0.75 Shatoria band fail
- valid_c=false base×**1.997**; mean_mix −0.019. Same α0.75 band wall as H7–H15.

### H17 / H16 — α0.90 band-clear, weak margin
- H17 m=**−0.00367** base×1.133; H16 m=**+0.00970** base×1.146.

### H15–H7 / H6 / H5c / H5b / H5 / H1v2 / H1 / H2 / H4
- α0.75 band ×1.85–2.21; LoRA/SFT near-zero or negative; H4 invented r-band.
