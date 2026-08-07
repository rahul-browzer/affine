# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** This file is the index, not the writeup. Each entry is at
most four lines and points at `experiments/<id>/result.md` for the detail.
Keep refuted entries — knowing an approach is dead is worth as much as knowing
one works. Full pre-compaction text: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H6 | highest | TalentPigs-init shortz-nolist thought LoRA lr5e-6 → r∈[0.70,0.85], clip-L1≥0.042, margin>0.04 | **open** (train RUNNING) |
| 2 | H5c | was highest | kevin-init thought LoRA on expanded refs → margin>0.04 | **open** (mid50 FAIL; n80 RUNNING) |
| 3 | H4 | high (rule) | keep r∈[0.70,0.85] and base×≤1.15 or gates kill S | **open** (design rule) |
| 4 | H3 | instrumental | with Λ2≈king, +0.01 mean clip-L1 ⇒ +0.01 S | **supported** |
| — | H5b | was highest | TalentPigs-init thought LoRA lr1e-5 → margin>0.04 | **refuted** |
| — | H5 | was highest | kevin×TalentPigs merge α∈{0.65,0.50} → margin>0.04 | **refuted** |
| — | H1v2 | was highest | thought-only SFT → margin>0.04 | **refuted** |
| — | H1 | was highest | full (z,y) SFT → margin>0.04 | **refuted** |
| — | H2 | very high | merge recent kings → margin>0.02 | **refuted** |

---

## Open

### H6 — TalentPigs-init mild shortz-nolist
- **Claim:** lr=5e-6 on shortz-nolist (790) from TalentPigs keeps r∈[0.70,0.85] and raises clip-L1 ≥ 0.042.
- **Test:** train on mine-h5c-1 GPUs 6,7 → merge → n80 vs TalentPigs.
- **Status:** train **RUNNING** pid 46680 @11:24Z. Detail: `experiments/s4-h6-talentpigs-shortz-mild/`.

### H5c — L1-headroom distill vs TalentPigs
- **Claim:** kevin-init thought LoRA on expanded teacher_refs clears margin > 0.04.
- **Status:** mid50 n40 **FAIL** (−0.019); n80 **RUNNING** pid 43690; HF public `unconst/Affine-5czsc2fc98-h5c-merged` @0cda099e. Detail: `experiments/s4-h5c-expand-refs/`.

### H4 — stay inside the distill envelope
- **Claim:** r ∈ [0.70, 0.85] and base× ≤ 1.15, or gates invalidate the miner.
- **Evidence:** H1, H1v2 (r=0.904), H5b (r=0.670), H5c mid50 (r=0.897) all breached and lost.
- **Status:** open as a standing design constraint on every future recipe.

### H3 — clip-L1 is the cheap lever (supported)
- **Claim:** once Λ2 ≈ king, mean clip-L1 moves S nearly one-for-one.
- **Evidence:** Spearman with outcome 0.936 (clip-L1) vs 0.711 (Λ2), n=14 duels.

## Refuted

### H5b — TalentPigs-init thought-only LoRA
- n80 margin **+0.00322**, z=0.55. r=0.670 breaches H4.
- Detail: `experiments/s4-h5b-talentpigs-distill/result.md`.

### H5 — kevin × TalentPigs merge
- α0.65 gave base× 4.43; α0.50 was unpromptable. No viable α.
- Detail: `experiments/s4-h5-talentpigs/result.md`.

### H1v2 — thought-only teacher distill (kevin init)
- n80 margin **−0.00030**, z=−0.04. r=0.904 fails H4.
- Detail: `experiments/s4-h1v2-sft/result.md`.

### H1 — full (z,y) SFT on teacher_refs
- n80 **−0.01994** z=−2.42. Detail: `experiments/s4-h1-sft/result.md`.

### H2 — weight merge of recent kings
- α0.50 −0.010, α0.65 +0.007. Detail: `experiments/s4-h2-merge/result.md`.
