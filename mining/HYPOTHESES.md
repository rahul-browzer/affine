# HYPOTHESES — falsifiable claims

**Cap: 120 lines.** This file is the index, not the writeup. Each entry is at
most four lines and points at `experiments/<id>/result.md` for the detail.
Keep refuted entries — knowing an approach is dead is worth as much as knowing
one works. Full pre-compaction text: `archive/HYPOTHESES-full-2026-08-07.md`.

## Ranked

| rank | id | expected α/$ | prediction | status |
|---|---|---|---|---|
| 1 | H5c | highest | kevin-init thought LoRA on expanded teacher_refs → clip-L1 ≥ 0.042, r ∈ [0.70,0.85], margin > 0.04 | **open** (mid50 FAIL) |
| 2 | H4 | high (rule, not a run) | keep r ∈ [0.70,0.85] and base× ≤ 1.15 or the gates kill S | **open** (design rule) |
| 3 | H3 | instrumental | with Λ2 ≈ king, +0.01 mean clip-L1 ⇒ +0.01 S (cap +0.1) | **supported** |
| — | H5b | was highest | TalentPigs-init thought-only LoRA (lr 1e-5) → margin > 0.04 | **refuted** |
| — | H5 | was highest | kevin×TalentPigs merge α ∈ {0.65, 0.50} → margin > 0.04 | **refuted** |
| — | H1v2 | was highest | thought-only SFT → r ∈ [0.70,0.85] + margin > 0.04 | **refuted** |
| — | H1 | was highest | full (z,y) SFT on teacher_refs → margin > 0.04 | **refuted** |
| — | H2 | very high | merge of recent kings → margin > 0.02 first try | **refuted** |

---

## Open

### H5c — L1-headroom distill vs TalentPigs
- **Claim:** kevin-init thought LoRA on expanded teacher_refs clears margin > 0.04.
- **Test:** train 99 steps on 791 thought examples (lr 2e-5, r16) → n80 sim.
- **Status:** mid50 n40 **FAIL** (−0.019); final merge DONE 11:12Z (≠base/king); chall→n80 pending. Detail: `experiments/s4-h5c-expand-refs/results/h5c_final_merge_status.json`.

### H4 — stay inside the distill envelope
- **Claim:** r ∈ [0.70, 0.85] and base× ≤ 1.15, or gates invalidate the miner.
- **Evidence:** H1, H1v2 (r=0.904), H5b (r=0.670) all breached and all lost.
- **Status:** open as a standing design constraint on every future recipe.

### H3 — clip-L1 is the cheap lever (supported)
- **Claim:** once Λ2 ≈ king, mean clip-L1 moves S nearly one-for-one.
- **Evidence:** Spearman with outcome 0.936 (clip-L1) vs 0.711 (Λ2), n=14 duels.
- **Use:** target L1 headroom, not Λ2, in every candidate.

## Refuted

### H5b — TalentPigs-init thought-only LoRA
- n80 margin **+0.00322**, z=0.55. r=0.670 breaches H4.
- Detail: `experiments/s4-h5b-talentpigs-distill/result.md`.

### H5 — kevin × TalentPigs merge
- α0.65 gave base× 4.43; α0.50 was unpromptable. No viable α.
- Detail: `experiments/s4-h5-talentpigs/result.md`.

### H1v2 — thought-only teacher distill (kevin init)
- n80 margin **−0.00030**, z=−0.04 — reproduces the king, cannot exceed it.
- r=0.904 fails H4; clip-L1 +0.015 was fine.
- Detail: `experiments/s4-h1v2-sft/result.md`.

### H1 — full (z,y) SFT on teacher_refs
- n40 −0.0024, n80 **−0.01994** z=−2.42. Fails H4 both ways.
- Best loss 0.175 @ step 80; final 0.237 @ 110 (110 steps, 440 examples).
- Detail: `experiments/s4-h1-sft/result.md`.

### H2 — weight merge of recent kings
- α0.50 −0.010, α0.65 +0.007. Cheap to test, no signal.
- Detail: `experiments/s4-h2-merge/result.md`.
