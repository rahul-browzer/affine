# H10 result — REFUTED (baseline band)

**UTC:** 2026-08-07T13:29:18Z
**Pod:** mine-h10-1 (gentle-eagle-d5) · spent ~$40
**Merge:** α=0.75 · A=`TalentPigs/affine-5ekxlcg3fx-abc`@dbfbb3e2 · B=`kevin954/Affine-5dfqbbh8ev-sft`@6a5815fa → `/root/merges/h10-tp75`

## Verdict (n80)

| field | value |
|---|---|
| decision | **REFUTE_H10** |
| chall_valid | **false** (`baseline_band_exceeded`) |
| base_x | **1.983** (0.2444 / 0.1232) — gate 1.25× |
| r | 1.028 (would pass [0.3,4]) |
| margin / z | 0.0 / 0.0 (no paired test — invalid) |
| S_c / S_k | null / 0.00586 |
| mean_λ2 chall/king | −0.0262 / −0.0124 |
| mean_mix chall | −0.0320 |

## Conclusion

TP-dominant × kevin α0.75 still sabotages empty-baseline (same mode as H7/H8
null-S merges and H5 kevin-dom). Kevin as 25% B is enough to trip the band.
No α0.85 retry. Do not submit. Artifacts: `h10_decision.json`,
`h10_sim_result.json`.
