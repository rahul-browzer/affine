# H113 / F18 — result (pass 460)

## Verdict: REFUTE

| metric | value |
|---|---|
| margin | **−0.03010** |
| z | −3.23 |
| SE | 0.00932 |
| S_c / S_k | 0.00845 / 0.03872 |
| mean_λ2_c | **−0.01326** (king −0.00074) |
| gates | both valid (pass 0.81, bank 0.44, r 0.812, base× 0.877) |
| slice | block_hash d203…004 · n=80 · digest a7386af5… |

## Decision rule
margin ≤ 0 → REFUTE family; tear `mine-f18-1` (cosmic-matrix-19). Done p460.

## Interpretation
Unmodified TalentPigs clears gates but loses on ranking via worse Λ2
(mean_λ2_c ≪ king). Same pattern as raw kevin/pandora/diane/af-k1.
F10 LoRA twin was also ≤0 — neither raw nor LoRA-on-TalentPigs moves Λ2
past Tok. Class signal: past-earner bases under live Tok are ranking-dead.

Artifact: pod `/root/affine_data/h113_sim_result.json` (torn with pod);
decision `REFUTE_H113` via nested_verdict parser @ 2026-08-09T04:06:16Z.
