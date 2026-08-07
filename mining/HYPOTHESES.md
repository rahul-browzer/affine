# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** This file is the index, not the writeup. Each entry is at
most four lines and points at `experiments/<id>/result.md` for the detail.
Keep refuted entries — knowing an approach is dead is worth as much as knowing
one works. Full pre-compaction text: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H6 | highest | TalentPigs-init shortz-nolist thought LoRA lr5e-6 → clip-L1≥0.042, margin>0.04 | **open** (n80 ~60/80; retry watcher) |
| 2 | H13 | highest (cheap) | TalentPigs×kkk-af α0.75 → margin>0.04 (chal-00262 +0.0244 exact rev) | **open** (mine-h13-1 boot) |
| 3 | H11 | high (cheap) | TalentPigs×adambell-ckpt450 α0.75 → margin>0.04 (chal-00274 +0.023) | **open** (n80 ~75/80; retry watcher) |
| 4 | H12 | high (cheap) | TalentPigs×plmk α0.75 → margin>0.04 (chal-00310 +0.0143) | **open** (n80 ~44/80) |
| 5 | H9 | high (cheap) | TalentPigs×diane613 α0.75 → margin>0.04 vs TalentPigs | **open** (n80 retry ~73/80) |
| 6 | H14 | med (cheap) | TalentPigs×kkkk α0.75 → margin>0.04 (chal-00268 +0.0132) | **open** (staged+retry; wait slot) |
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

### H6 — TalentPigs-init mild shortz-nolist
- **Claim:** lr=5e-6 on shortz-nolist (790) from TalentPigs raises clip-L1 ≥ 0.042 at margin > 0.04.
- **Test:** train on mine-h5c-1 GPUs 6,7 → merge → n80 vs TalentPigs.
- **Status:** mid50 SIGNAL_NEG; final n80 ~60/80; `watch_n80_retry` armed. Detail: `experiments/s4-h6-talentpigs-shortz-mild/`.

### H13 — TalentPigs × kkk-af (chal-00262) — boot
- **Claim:** α=0.75 with strongest non-crown near-miss (+0.0244 z=2.58) clears margin > 0.04.
- **Test:** `mine-h13-1` (zesty-orbit-df); B=`bluecolor777/kkk-af`@7426296b.
- **Status:** rented 13:32Z after H10 rm; bootstrap pid 888 + watchers. Detail: `experiments/s4-h13-tp-kkk-merge/`.

### H14 — TalentPigs × kkkk (chal-00268) — staged+hardened
- **Claim:** α=0.75 with chal-00268 near-miss (+0.0132 z=1.24) clears margin > 0.04.
- **Test:** second free slot → `mine-h14-1`; B=`vincentwarrior/affine-5ccebdzvsj-kkkk`@3ca1ebe6 (HF OK 13:12Z).
- **Status:** `retry_h14_n80.sh` + `watch_n80_retry` in upload; after H13. Detail: `experiments/s4-h14-tp-kkkk-merge/`.

### H12 — TalentPigs × plmk merge (pivoted from als kdjf)
- **Claim:** α=0.75 with plmk near-miss clears margin > 0.04.
- **Test:** mine-h12-1; B=`bluecolor777/plmk`@b2cc7b9f (=chal-00310 +0.0143).
- **Status:** n80 ~44/80; inline 3×. Detail: `experiments/s4-h12-tp-dfwas-merge/`.

### H11 — TalentPigs × adambell ckpt450 merge
- **Claim:** α=0.75 with chal-00274 near-miss (+0.0229 z=2.37) clears margin > 0.04.
- **Test:** mine-h11-1; B=`0pentensor/5dvha3y7cd-ckpt450-H6`@af20efc1.
- **Status:** n80 ~75/80; `watch_n80_retry` armed. Detail: `experiments/s4-h11-tp-adambell-merge/`.

### H9 — TalentPigs × diane613 merge
- **Claim:** α=0.75 with reign-earner diane613 clears margin > 0.04.
- **Test:** mine-h9-1; try α=0.85 if 0.02≤margin≤0.04.
- **Status:** n80 retry ~73/80. Detail: `experiments/s4-h9-tp-diane-merge/`.

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

### H5b — TalentPigs-init thought-only LoRA
- n80 margin **+0.00322**, z=0.55. r=0.670 — gate-valid; our best margin so far.
- Detail: `experiments/s4-h5b-talentpigs-distill/result.md`.

### H5 — kevin-dominant × TalentPigs merge
- A=kevin α0.65 → base×4.43; α0.50 unpromptable. TP-dom flip H10 also band-INVALID.
- Detail: `experiments/s4-h5-talentpigs/result.md`.

### H1v2 — thought-only teacher distill (kevin init)
- n80 margin **−0.00030**, z=−0.04. r=0.904 — gate-valid (`chall_valid: true`); lost on margin.
- Detail: `experiments/s4-h1v2-sft/result.md`.

### H1 — full (z,y) SFT on teacher_refs
- n80 **−0.01994** z=−2.42. Detail: `experiments/s4-h1-sft/result.md`.

### H2 — weight merge of recent kings
- α0.50 −0.010, α0.65 +0.007. Detail: `experiments/s4-h2-merge/result.md`.
