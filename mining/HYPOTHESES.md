# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** This file is the index, not the writeup. Each entry is at
most four lines and points at `experiments/<id>/result.md` for the detail.
Keep refuted entries — knowing an approach is dead is worth as much as knowing
one works. Full pre-compaction text: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H13 | highest (cheap) | TalentPigs×kkk-af α0.75 → margin>0.04 (chal-00262 +0.0244 exact rev) | **open** (serve→n80) |
| 2 | H16 | high (cheap) | TalentPigs×plmk α0.90 → base×≤1.25 and margin>0.04 (H12 α0.75 band×2.02) | **open** (bootstrap) |
| 3 | H14 | med (cheap) | TalentPigs×kkkk α0.75 → margin>0.04 (chal-00268 +0.0132) | **open** (merging) |
| 4 | H15 | med (cheap) | TalentPigs×leary α0.75 → margin>0.04 (chal-00315 +0.0059 base×≈1.017) | **open** (merging) |
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

### H13 — TalentPigs × kkk-af (chal-00262) — serve→n80
- **Claim:** α=0.75 with strongest non-crown near-miss (+0.0244 z=2.58) clears margin > 0.04.
- **Test:** `mine-h13-1` (zesty-orbit-df); B=`bluecolor777/kkk-af`@7426296b.
- **Status:** merge done 16/16; engines launched 13:49Z. Detail: `experiments/s4-h13-tp-kkk-merge/`.

### H16 — TalentPigs × plmk α0.90 — bootstrap
- **Claim:** α=0.90 (10% plmk) keeps base×≤1.25 after H12 α0.75 hit ×2.02; margin>0.04.
- **Test:** `mine-h16-1` (cosmic-eagle-2d); B=`bluecolor777/plmk`@b2cc7b9f.
- **Status:** rented+launched 13:51Z; pipeline pid 839. Detail: `experiments/s4-h16-tp-plmk-a90/`.

### H14 — TalentPigs × kkkk (chal-00268) — merging
- **Claim:** α=0.75 with chal-00268 near-miss (+0.0132 z=1.24) clears margin > 0.04.
- **Test:** `mine-h14-1` (swift-orbit-cd); B=`vincentwarrior/affine-5ccebdzvsj-kkkk`@3ca1ebe6.
- **Status:** merging ~2/16. Detail: `experiments/s4-h14-tp-kkkk-merge/`.

### H15 — TalentPigs × leary (chal-00315) — merging
- **Claim:** α=0.75 with accessible healthy-baseline +0.0059 clears margin > 0.04.
- **Test:** `mine-h15-1` (cosmic-shark-43); B=`leary-criste/affine-5g4yy75zuz-test`@1e6d6d02.
- **Status:** merging ~5/16. Detail: `experiments/s4-h15-tp-leary-merge/`.

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

### H12 — TalentPigs × plmk α0.75
- n80 **INVALID**: base×**2.017** (0.2525/0.1252); r=0.990; S_c null. Parent duel was base×≈1.000.
- α0.75 (25% B) sabotages empty-baseline even when B itself was healthy. No α0.85; H16 tests α0.90.
- Detail: `experiments/s4-h12-tp-dfwas-merge/result.md`, `results/h12_decision.json`.

### H6 — TalentPigs-init mild shortz-nolist LoRA
- n80 margin **+0.00330**, z=0.54. r=0.730 / base×0.957 gate-valid; clipL1≈king (~0.030), not ≥0.042.
- Same near-zero positive as H5b (+0.00322). Do not retry. Pod rm ~$116.
- Detail: `experiments/s4-h6-talentpigs-shortz-mild/result.md`, `results/h6_decision.json`.

### H11 — TalentPigs × adambell-ckpt450 α0.75
- n80 **INVALID**: base×**1.866** (0.230/0.123); r=0.974; Λ2 −0.017. Pod rm ~$30.
- Detail: `experiments/s4-h11-tp-adambell-merge/result.md`.

### H9 — TalentPigs × diane613 α0.75
- n80 **INVALID**: base×**1.851** (0.227/0.123); r=0.976; Λ2 −0.018. Pod rm ~$48.
- Detail: `experiments/s4-h9-tp-diane-merge/result.md`.

### H10 — TalentPigs × kevin α0.75 (TP-dominant)
- n80 **INVALID**: base×**1.983**; r=1.028; Λ2 −0.026 vs king −0.012. Pod rm ~$40.
- Detail: `experiments/s4-h10-tp-kevin-merge/results/h10_decision.json`.
### H8 — TalentPigs × golden-crown α0.75
- n80 **INVALID**: `baseline_band_exceeded` base×**1.97** (0.249/0.127); r=0.934; Λ2 −0.018.
- Same band mode as H7. No α0.85. Detail: `experiments/s4-h8-tp-goldencrown-merge/result.md`.

### H7 — TalentPigs × pandora-m4 α0.75
- n80 **INVALID**: `baseline_band_exceeded` base×**2.21** (0.305/0.138); r=0.997 otherwise fine.
- Λ2 −0.0229 vs king +0.0009. Same band failure mode as H5 kevin-dom. No α0.85 retry.
- Detail: `experiments/s4-h7-tp-pandora-merge/result.md`, `results/h7_decision.json`.

### H5c — kevin-init thought LoRA on expanded shortz refs
- n80 margin **−0.01640**, z=−2.25. r=0.883 / base×1.058 gate-valid; clipL1 0.017≪king 0.028; Λ2 −0.0028 vs king +0.0024.
- mid50 n40 was −0.019; final confirms clip-L1 miss, not calibration. Do not submit HF merge.
- Detail: `experiments/s4-h5c-expand-refs/result.md`, `results/h5c_decision.json`.

### H5b / H5 / H1v2 / H1 / H2 — older refutes
- H5b +0.00322; H5 kevin-dom band×4.43; H1v2 −0.00030; H1 −0.01994; H2 α0.50/−0.010 α0.65/+0.007.
- Detail: `experiments/s4-h{5b,5,1v2,1,2}*/result.md`.
