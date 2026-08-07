# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H21 | high | TalentPigs×sft2 α0.75 → margin>0.04 (new parent +0.0109 base×1.01) | **open** (bootstrap) |
| 2 | H22 | med | TalentPigs×kevin α0.90 → base×≤1.25 and margin>0.04 | **open** (bootstrap) |
| 3 | H19 | med | TalentPigs×kkkk α0.90 → margin>0.04 | **open** (n80 ~31/80) |
| 4 | H20 | med | TalentPigs×leary α0.90 → margin>0.04 | **open** (n80 ~16/80) |
| 5 | H18 | low | TalentPigs×Shatoria α0.75 → margin>0.04 | **open** (n80 ~24/80) |
| — | H17/H16 | was high | α0.90 band-clear near-miss | **refuted** |
| — | H15–H7 | — | α0.75 band cluster | **refuted** |
| — | H6/H5c/H5b/H5/H1v2/H1/H2 | — | LoRA/SFT/merge | **refuted** |
| 8 | H3 | instrumental | clip-L1 lever | **supported** |
| — | H4 | — | r∈[0.70,0.85] | **refuted** |

---

## Open

### H21 — TalentPigs × syntaxsorcerer1/sft2 α0.75
- **Claim:** new parent class chal-00325 +0.0109 base×1.009 → margin>0.04.
- **Test:** `mine-h21-1` (golden-wolf-62); B=`syntaxsorcerer1/…-sft2`@affa6d81.
- **Status:** rented+bootstrap @15:42Z. `experiments/s4-h21-tp-sft2/`.

### H22 — TalentPigs × kevin α0.90 (H10 hedge)
- **Claim:** α0.90 clears H10's α0.75 base×1.983; margin>0.04.
- **Test:** `mine-h22-1` (lunar-shark-f2); B=`kevin954/…-sft`@6a5815fa.
- **Status:** rented+bootstrap @15:42Z. `experiments/s4-h22-tp-kevin-a90/`.

### H19 — TalentPigs × kkkk α0.90 — n80 live
- **Test:** `mine-h19-1`; B=`vincentwarrior/…-kkkk`@3ca1ebe6. ~31/80 @15:42Z.

### H20 — TalentPigs × leary α0.90 — n80 live
- **Test:** `mine-h20-1`; B=`leary-criste/…-test`@1e6d6d02. ~16/80; chall@0.72.

### H18 — TalentPigs × Shatoria test3 — n80 live
- **Test:** `mine-h18-1`; B=`Shatoria/…-test3`@a751418a. ~24/80 @15:42Z.

### H3 — clip-L1 lever (supported)
- Spearman with outcome 0.936 (clip-L1) vs 0.711 (Λ2), n=14.

## Refuted

### H17 / H16 — α0.90 band-clear, weak margin
- H17 m=**−0.00367** base×1.133; H16 m=**+0.00970** base×1.146. No crown.

### H15–H7 / H6 / H5c / H5b / H5 / H1v2 / H1 / H2 / H4
- α0.75 band ×1.85–2.21; LoRA/SFT near-zero or negative; H4 invented r-band.
