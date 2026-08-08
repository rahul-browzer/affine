# H99 / F2 — RESULT (REFUTE)

**UTC:** 2026-08-08T20:37:03Z · pod `mine-f2-1` (zesty-orbit-85) torn down p371
**Slice:** n=80 · `block_hash=b203…002` · king `Tok331102/…-af10` @ `eb8bf9a…`

| metric | value |
|---|---|
| margin | **−0.001994** |
| z | −0.263 |
| SE | 0.007585 |
| S_c / S_k | 0.03188 / 0.03442 |
| r_c | 0.658 (in band) |
| valid_c | true · gate_pass 0.803 · bank 0.494 |
| base_x | 0.966 |
| mean_λ2_c / mean_λ2_k | −0.00154 / −0.00095 |

**Decision:** `REFUTE_H99` (m≤0; ≪ CONFIRM bar +0.015).
**Parser:** `write_merge_decision.py#nested_verdict`
**Artifacts:** `h99_decision.json`, `h99_sim_result.json` (this dir).

## Interpretation
High-Λ2 z_A selection (1059 ex, mean Λ2 0.086, 65% non-overlap with clip-L1 set)
under Tok-init LoRA r16 did **not** raise challenger Λ2 above the king. Same
basin as clip-L1 winner-zA: data-axis remix on king LoRA leaves Λ2 frozen.
Family F2 closed at screen; no CONFIRM / no sweep.
