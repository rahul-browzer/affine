# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** Index only. ≤4 lines/entry. Detail → `experiments/<id>/`.
Full pre-compaction: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H21 | high | TalentPigs×sft2 α0.75 → margin>0.04 (new parent +0.0109 base×1.01) | **open** (bootstrap) |
| 2 | H23 | med | TalentPigs×Talucampe ck5 α0.90 → margin>0.04 (+0.0069 ungated) | **staged** |
| 3 | H22 | med | TalentPigs×kevin α0.90 → base×≤1.25 and margin>0.04 | **open** (bootstrap) |
| 4 | H19 | med | TalentPigs×kkkk α0.90 → margin>0.04 | **open** (n80 ~42/80) |
| 5 | H20 | med | TalentPigs×leary α0.90 → margin>0.04 | **open** (n80 ~26/80) |
| 6 | H18 | low | TalentPigs×Shatoria α0.75 → margin>0.04 | **open** (n80 ~37/80) |
| 7 | H24 | low | TalentPigs×0ronoCris α0.90 → margin>0.04 (+0.0016 ungated) | **staged** |
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
- **Status:** TP+sft2 DL done; teacher DL @15:47Z. `experiments/s4-h21-tp-sft2/`.

### H23 — TalentPigs × Talucampe037/ck5 α0.90 (staged)
- **Claim:** chal-00193 +0.0069 ungated ck5 (ck10/11 unservable) → margin>0.04.
- **Test:** next free slot → `mine-h23-1`; B=`Talucampe037/…-ck5`@da35105f.
- **Status:** scripts+plan ready. `experiments/s4-h23-tp-talucampe-a90/`.

### H22 — TalentPigs × kevin α0.90 (H10 hedge)
- **Claim:** α0.90 clears H10's α0.75 base×1.983; margin>0.04.
- **Test:** `mine-h22-1` (lunar-shark-f2); B=`kevin954/…-sft`@6a5815fa.
- **Status:** TP done; kevin DL @15:47Z. `experiments/s4-h22-tp-kevin-a90/`.

### H24 — TalentPigs × 0ronoCris distill-ref-2 α0.90 (staged)
- **Claim:** chal-00190 +0.0016 ungated @d43ada88 → margin>0.04 (weak; last +margin B).
- **Test:** after H23 slot → `mine-h24-1`; B=`0ronoCris/…-distill-ref-2`@d43ada88.
- **Status:** HF verified pass156 (no py/auto_map). `experiments/s4-h24-tp-ronocris-a90/`.

### H19 / H20 / H18 — n80 live
- H19 kkkk@3ca1ebe6 ~42/80; H20 leary@1e6d6d02 ~26/80; H18 Shatoria@a751418a ~37/80.

### H3 — clip-L1 lever (supported)
- Spearman with outcome 0.936 (clip-L1) vs 0.711 (Λ2), n=14.

## Refuted

### H17 / H16 — α0.90 band-clear, weak margin
- H17 m=**−0.00367** base×1.133; H16 m=**+0.00970** base×1.146. No crown.

### H15–H7 / H6 / H5c / H5b / H5 / H1v2 / H1 / H2 / H4
- α0.75 band ×1.85–2.21; LoRA/SFT near-zero or negative; H4 invented r-band.
