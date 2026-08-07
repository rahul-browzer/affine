# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** This file is the index, not the writeup. Each entry is at
most four lines and points at `experiments/<id>/result.md` for the detail.
Keep refuted entries — knowing an approach is dead is worth as much as knowing
one works. Full pre-compaction text: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H6 | highest | TalentPigs-init shortz-nolist thought LoRA lr5e-6 → clip-L1≥0.042, margin>0.04 | **open** (train~65/99; mid50 n40~5/40) |
| 2 | H7 | high (cheap) | TalentPigs×pandora α0.75 → margin>0.04 vs TalentPigs | **open** (n80 ~65/80) |
| 3 | H8 | high (cheap) | TalentPigs×golden-crown α0.75 → margin>0.04 vs TalentPigs | **open** (n80 ~58/80) |
| 4 | H10 | high (cheap) | TalentPigs×kevin α0.75 (TP-dom) → margin>0.04 | **open** (kevin dl ~27G) |
| 5 | H9 | high (cheap) | TalentPigs×diane613 α0.75 → margin>0.04 vs TalentPigs | **open** (MERGE_DONE; serve→n80) |
| — | H5c | was highest | kevin-init thought LoRA on expanded refs → margin>0.04 | **refuted** — n80 −0.01640 |
| — | H4 | — | keep r∈[0.70,0.85] or gates kill S | **refuted** — real gate is [0.3,4.0]; we never failed it |
| 6 | H3 | instrumental | with Λ2≈king, +0.01 mean clip-L1 ⇒ +0.01 S | **supported** |
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
- **Status:** train **RUNNING** ~65/99 loss≈0.530; mid50 n40 **RUNNING** ~5/40; nested fix-watchers 67516/67517. Detail: `experiments/s4-h6-talentpigs-shortz-mild/`.

### H7 — TalentPigs × pandora-m4 merge
- **Claim:** α=0.75 linear merge (TalentPigs-dominant) clears margin > 0.04; untried parents (H2=kevin×pandora, H5=kevin×TP).
- **Test:** mine-h7-1 bootstrap→merge→n80; try α=0.85 if 0.02≤margin≤0.04.
- **Status:** n80 **RUNNING** ~65/80; nested-verdict fix-watcher 12666. Detail: `experiments/s4-h7-tp-pandora-merge/`.

### H8 — TalentPigs × golden-crown merge
- **Claim:** α=0.75 linear merge with reign-earner golden-crown clears margin > 0.04; independent of H7 (different B).
- **Test:** mine-h8-1 bootstrap→merge→n80; try α=0.85 if 0.02≤margin≤0.04.
- **Status:** n80 **RUNNING** ~58/80; nested-verdict fix-watcher 13030. Detail: `experiments/s4-h8-tp-goldencrown-merge/`.

### H10 — TalentPigs × kevin merge (TP-dominant)
- **Claim:** α=0.75 `0.75·TP + 0.25·kevin` clears margin > 0.04; H5 only tried kevin-dominant (A=kevin).
- **Test:** mine-h10-1 bootstrap→merge→n80; try α=0.85 if 0.02≤margin≤0.04.
- **Status:** kevin weight shards downloading (~16G+11G incomplete); fix-watcher. Detail: `experiments/s4-h10-tp-kevin-merge/`.

### H9 — TalentPigs × diane613 merge
- **Claim:** α=0.75 linear merge with reign-earner diane613 clears margin > 0.04; untried B (≠pandora/golden-crown).
- **Test:** mine-h9-1 bootstrap→merge→n80; try α=0.85 if 0.02≤margin≤0.04.
- **Status:** MERGE_DONE non-identical; vLLM teacher/king/chall loading → wait_ready→n80. Detail: `experiments/s4-h9-tp-diane-merge/`.

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

### H5c — kevin-init thought LoRA on expanded shortz refs
- n80 margin **−0.01640**, z=−2.25. r=0.883 / base×1.058 gate-valid; clipL1 0.017≪king 0.028; Λ2 −0.0028 vs king +0.0024.
- mid50 n40 was −0.019; final confirms clip-L1 miss, not calibration. Do not submit HF merge.
- Detail: `experiments/s4-h5c-expand-refs/result.md`, `results/h5c_decision.json`.

### H5b — TalentPigs-init thought-only LoRA
- n80 margin **+0.00322**, z=0.55. r=0.670 — gate-valid; our best margin so far.
- Detail: `experiments/s4-h5b-talentpigs-distill/result.md`.

### H5 — kevin-dominant × TalentPigs merge
- A=kevin α0.65 → base×4.43; α0.50 unpromptable. TP-dominant flip is H10 (open).
- Detail: `experiments/s4-h5-talentpigs/result.md`.

### H1v2 — thought-only teacher distill (kevin init)
- n80 margin **−0.00030**, z=−0.04. r=0.904 — gate-valid (`chall_valid: true`); lost on margin.
- Detail: `experiments/s4-h1v2-sft/result.md`.

### H1 — full (z,y) SFT on teacher_refs
- n80 **−0.01994** z=−2.42. Detail: `experiments/s4-h1-sft/result.md`.

### H2 — weight merge of recent kings
- α0.50 −0.010, α0.65 +0.007. Detail: `experiments/s4-h2-merge/result.md`.
