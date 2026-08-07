# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H25 | high | TP×Radiant28/ckpt1000-m7 α0.90 → margin>0.04 | **open** (bootstrap) |
| 2 | H21 | high | TalentPigs×sft2 α0.75 → margin>0.04 | **open** (engines recovering→n80) |
| 3 | H23 | med | TalentPigs×Talucampe ck5 α0.90 → margin>0.04 | **open** (bootstrap) |
| 4 | H22 | med | TalentPigs×kevin α0.90 → base×≤1.25 and margin>0.04 | **open** (DL kevin) |
| 5 | H20 | med | TalentPigs×leary α0.90 → margin>0.04 | **open** (n80 ~59/80) |
| 6 | H24 | low | TalentPigs×0ronoCris α0.90 → margin>0.04 | **staged** |
| — | H19 | was med | TP×kkkk α0.90 | **refuted** m=+0.00348 |
| — | H18 | was low | TP×Shatoria α0.75 | **refuted** band×1.997 |
| — | H17/H16 | was high | α0.90 band-clear near-miss | **refuted** |
| — | H15–H7 | — | α0.75 band cluster | **refuted** |
| — | H6/H5c/H5b/H5/H1v2/H1/H2 | — | LoRA/SFT/merge | **refuted** |
| 7 | H3 | instrumental | clip-L1 lever | **supported** |
| — | H4 | — | r∈[0.70,0.85] | **refuted** |

---

## Open

### H25 — TalentPigs × Radiant28 ckpt1000-m7 α0.90
- **Claim:** chal-00331 +0.01808 → merge margin>0.04.
- **Test:** `mine-h25-1` golden-shark-c8; B=`Radiant28/5eqdtdzqle-ckpt1000-m7`@f766293ee878.
- **Status:** launched pass158; bootstrap DL. `experiments/s4-h25-tp-adambell-m7-a90/`.

### H21 — TalentPigs × syntaxsorcerer1/sft2 α0.75
- **Claim:** chal-00325 +0.0109 base×1.009 → margin>0.04.
- **Test:** `mine-h21-1`; merge done maxΔ≈6e-5; engines→n80.
- **Status:** Triton race killed king/chall; pass159 wiped caches+relaunched; watchdog→n80.

### H23 — TalentPigs × Talucampe037/ck5 α0.90
- **Claim:** chal-00193 +0.0069 → margin>0.04.
- **Test:** `mine-h23-1` gentle-fox-b5 8×B300; B=@da35105f.
- **Status:** launched pass158. `experiments/s4-h23-tp-talucampe-a90/`.

### H22 / H20 / H24
- H22 merging; H20 n80 72/80; H24 staged after next free.

### H3 — clip-L1 lever (supported)
- Spearman with outcome 0.936 (clip-L1) vs 0.711 (Λ2), n=14.

## Refuted

### H19 — α0.90 kkkk band-clear, tiny margin
- m=**+0.00348** z=0.59 base×1.121 valid; S_c=0.0313 S_k=0.0279. No crown.

### H18 — α0.75 Shatoria band fail
- valid_c=false base×**1.997**; mean_mix −0.019. Same α0.75 band wall as H7–H15.

### H17 / H16 — α0.90 band-clear, weak margin
- H17 m=**−0.00367** base×1.133; H16 m=**+0.00970** base×1.146.

### H15–H7 / H6 / H5c / H5b / H5 / H1v2 / H1 / H2 / H4
- α0.75 band ×1.85–2.21; LoRA/SFT near-zero or negative; H4 invented r-band.
