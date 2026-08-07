# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** This file is the index, not the writeup. Each entry is at
most four lines and points at `experiments/<id>/result.md` for the detail.
Keep refuted entries — knowing an approach is dead is worth as much as knowing
one works. Full pre-compaction text: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H17 | high (cheap) | TalentPigs×kkk-af α0.90 → base×≤1.25 and margin>0.04 (H13 band hedge) | **open** (n80 ~28/80) |
| 2 | H16 | high (cheap) | TalentPigs×plmk α0.90 → base×≤1.25 and margin>0.04 (H12 α0.75 band×2.02) | **open** (n80 ~42/80) |
| 3 | H19 | high (cheap) | TalentPigs×kkkk α0.90 → base×≤1.25 and margin>0.04 (H14 band hedge) | **open** (bootstrap) |
| 4 | H20 | high (cheap) | TalentPigs×leary α0.90 → base×≤1.25 and margin>0.04 (H15 band hedge) | **open** (bootstrap) |
| 5 | H18 | low (cheap) | TalentPigs×Shatoria α0.75 → margin>0.04 (chal-00283 +0.0017) | **open** (serve→n80) |
| — | H15 | was med | TalentPigs×leary α0.75 → margin>0.04 | **refuted** — INVALID base×2.107 |
| — | H14 | was med | TalentPigs×kkkk α0.75 → margin>0.04 | **refuted** — INVALID base×2.044 |
| — | H13 | was highest | TalentPigs×kkk-af α0.75 → margin>0.04 | **refuted** — INVALID base×2.047 |
| — | H12 | was high | TalentPigs×plmk α0.75 → margin>0.04 | **refuted** — INVALID base×2.017 |
| — | H6 | was highest | TalentPigs-init shortz-nolist thought LoRA lr5e-6 → clip-L1≥0.042, margin>0.04 | **refuted** — n80 +0.00330 |
| — | H11 | was high | TalentPigs×adambell-ckpt450 α0.75 → margin>0.04 | **refuted** — invalid base×1.866 |
| — | H9 | was high | TalentPigs×diane613 α0.75 → margin>0.04 | **refuted** — invalid base×1.851 |
| — | H10 | was high | TalentPigs×kevin α0.75 (TP-dom) → margin>0.04 | **refuted** — invalid base×1.983 |
| — | H8 | was high | TalentPigs×golden-crown α0.75 → margin>0.04 | **refuted** — invalid base×1.97 |
| — | H7 | was high | TalentPigs×pandora α0.75 → margin>0.04 | **refuted** — invalid base×2.21 |
| — | H5c | was highest | kevin-init thought LoRA on expanded refs → margin>0.04 | **refuted** — n80 −0.01640 |
| — | H4 | — | keep r∈[0.70,0.85] or gates kill S | **refuted** — real gate is [0.3,4.0]; we never failed it |
| 8 | H3 | instrumental | with Λ2≈king, +0.01 mean clip-L1 ⇒ +0.01 S | **supported** |
| — | H5b | was highest | TalentPigs-init thought LoRA lr1e-5 → margin>0.04 | **refuted** |
| — | H5 | was highest | kevin-dom×TalentPigs α∈{0.65,0.50} → margin>0.04 | **refuted** (TP-dom open as H10) |
| — | H1v2 | was highest | thought-only SFT → margin>0.04 | **refuted** |
| — | H1 | was highest | full (z,y) SFT → margin>0.04 | **refuted** |
| — | H2 | very high | merge recent kings → margin>0.02 | **refuted** |

---

## Open

### H17 — TalentPigs × kkk-af α0.90 — n80 live
- **Claim:** α=0.90 (10% kkk-af) keeps base×≤1.25 after H13 α0.75 band×2.047; margin>0.04.
- **Test:** `mine-h17-1` (cosmic-orbit-9b); B=`bluecolor777/kkk-af`@7426296b.
- **Status:** n80 ~28/80. Detail: `experiments/s4-h17-tp-kkk-a90/`.

### H16 — TalentPigs × plmk α0.90 — n80 live
- **Claim:** α=0.90 (10% plmk) keeps base×≤1.25 after H12 α0.75 hit ×2.02; margin>0.04.
- **Test:** `mine-h16-1` (cosmic-eagle-2d); B=`bluecolor777/plmk`@b2cc7b9f.
- **Status:** n80 ~42/80. Detail: `experiments/s4-h16-tp-plmk-a90/`.

### H19 — TalentPigs × kkkk α0.90 — bootstrap
- **Claim:** α=0.90 after H14 α0.75 band×2.044; margin>0.04.
- **Test:** `mine-h19-1` (eager-eagle-c6); B=`vincentwarrior/affine-5ccebdzvsj-kkkk`@3ca1ebe6.
- **Status:** bootstrap @14:51Z. Detail: `experiments/s4-h19-tp-kkkk-a90/`.

### H20 — TalentPigs × leary α0.90 — bootstrap
- **Claim:** α=0.90 after H15 α0.75 band×2.107 (parent was healthy ×1.017); margin>0.04.
- **Test:** `mine-h20-1` (swift-lion-ac); B=`leary-criste/affine-5g4yy75zuz-test`@1e6d6d02.
- **Status:** bootstrap @14:53Z. Detail: `experiments/s4-h20-tp-leary-a90/`.

### H18 — TalentPigs × Shatoria test3 (chal-00283) — serve→n80
- **Claim:** α=0.75 with weak +0.0017 ungated B clears margin > 0.04 (last accessible α0.75).
- **Test:** `mine-h18-1` (zesty-hawk-bc @$5.66/h); B=`Shatoria/Affine-5ghntktyzq-test3`@a751418a.
- **Status:** serve launched @14:54Z. Detail: `experiments/s4-h18-tp-shatoria-merge/`.

### H4 — stay inside the distill envelope — **REFUTED** (do not revive)
- **Claim was:** r ∈ [0.70, 0.85], base× ≤ 1.15, or gates invalidate the miner.
- **Refuted by:** real gate is r ∈ [0.3, 4.0] (`affine/affine.toml`). Our
  r=0.670/0.897/0.904 were all gate-valid — `h1v2_decision_n80.json` says
  `chall_valid: true` at r=0.904. Those runs lost on **margin**, not on r. And
  our only positive margin (H5b +0.00322) had r=0.670, *outside* the band.
- **Do:** record r as a diagnostic; never target it, never kill a run over it.
  Real calibration limits are r∈[0.3,4.0] and baseline ≤1.25× king (gate 3b).

### H3 — clip-L1 is the cheap lever (supported)
- **Claim:** once Λ2 ≈ king, mean clip-L1 moves S nearly one-for-one.
- **Evidence:** Spearman with outcome 0.936 (clip-L1) vs 0.711 (Λ2), n=14 duels.

## Refuted

### H15 — TalentPigs × leary α0.75
- n80 **INVALID**: base×**2.107** (0.2795/0.1326); r=0.978; S_c null. Parent chal-00315 was ×≈1.017.
- Healthy parent still bands at α0.75. H20 α0.90 continues. Detail: `experiments/s4-h15-tp-leary-merge/result.md`.

### H14 — TalentPigs × kkkk α0.75
- n80 **INVALID**: base×**2.044** (0.2378/0.1164); r=0.975; Λ2 −0.020. H19 α0.90 continues.
- Detail: `experiments/s4-h14-tp-kkkk-merge/result.md`, `results/h14_decision.json`.

### H13 — TalentPigs × kkk-af α0.75
- n80 **INVALID**: base×**2.047**; parent chal-00262 +0.0244 still bands. H17 α0.90 continues.
- Detail: `experiments/s4-h13-tp-kkk-merge/result.md`.

### H12 — TalentPigs × plmk α0.75
- n80 **INVALID**: base×**2.017**; parent duel ×≈1.000. H16 α0.90 continues.
- Detail: `experiments/s4-h12-tp-dfwas-merge/result.md`.

### H11 / H10 / H9 / H8 / H7 — α0.75 band cluster
- INVALID base× 1.866 / 1.983 / 1.851 / 1.97 / 2.21. No α0.85. Details under `experiments/s4-h{11,10,9,8,7}*/`.

### H6 / H5c / H5b / H5 / H1v2 / H1 / H2 — older
- H6 +0.00330; H5c −0.01640; H5b +0.00322; H5 band×4.43; H1v2 −0.00030; H1 −0.01994; H2 −0.010/+0.007.
- Detail: `experiments/s4-h{6,5c,5b,5,1v2,1,2}*/result.md`.
