# H11 result — REFUTED

**Decision:** `REFUTE_H11` (2026-08-07T13:34:42Z)
**Pod:** mine-h11-1 (swift-fox-b5) · spent ~$30 · torn down pass 142

## n80 vs TalentPigs

| metric | challenger (TP×adambell α0.75) | king |
|---|---|---|
| valid | **false** (`baseline_band_exceeded`) | true |
| base× | **1.866** (0.230 / 0.123) | — |
| r / calib | 0.974 | 0.677 |
| gate_pass | 0.801 | — |
| bank_frac | 0.317 | — |
| mean Λ2 | −0.0174 | — |
| mean mix | −0.0112 | — |
| S | null | 0.0380 |
| margin / z | 0.0 / 0.0 (invalid) | — |

## Conclusion

α0.75 TP-dominant merge with gate-valid near-miss chal-00274 still trips
baseline band (~1.87×). Same failure mode as H7/H8/H10. No α0.85 (gate-fail).
Artifacts: `results/h11_decision.json`, `results/h11_sim_result.json`.
