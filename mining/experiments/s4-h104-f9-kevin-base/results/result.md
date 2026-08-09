# H104 / F9 — REFUTED (pass 423)

## Screen (n80, k=1, block_hash=d203…)

| metric | value |
|---|---|
| margin | **−0.014171** |
| z | −1.138 |
| SE | 0.012448 |
| S_c / S_k | 0.02063 / 0.03483 |
| mean_λ2_c / mean_λ2_k | **−0.01352** / −0.00228 |
| r_c | 0.711 |
| base_x | 1.193 |
| gates | both valid (pass 0.86/0.82, bank 0.48/0.46) |
| n_paired | 80 |
| elapsed | 2843s · decision 2026-08-09T00:44:46Z |

Decision: `REFUTE_H104` (write_merge_decision nested_verdict). Pod `mine-f9-1` removed (~$113 @ $31.92/h).

## Verdict

kevin954-init × high-Λ2 z_A LoRA does **not** beat Tok — margin −0.014,
mean_λ2_c −0.0135 ≪ king −0.0023. Past-crown base still worsens Λ2 under the
same LoRA recipe. Family **closed**. Do not CONFIRM / SWEEP kevin954 cells.
