# H13 — TalentPigs × kkk-af α0.75 — REFUTED

**Verdict:** INVALID `baseline_band_exceeded` base×**2.047** (0.2613/0.1277).
r=0.955 otherwise fine; S_c null; margin 0. Nested parser
`write_merge_decision.py` → `REFUTE_H13`.

| side | valid | S | r | baseline_abs | Λ2 |
|---|---|---|---|---|---|
| king | true | 0.02512 | 0.740 | 0.1277 | −0.0047 |
| chall | **false** | null | 0.955 | **0.2613** | −0.0195 |

n_paired=79. Same band failure as H7–H12 at α0.75 (25% B). Parent
chal-00262 was healthy base×≈0.92 — parent calibration ≠ merge calibration.

**Decision:** tear `mine-h13-1` (~$33). Keep H17 (α0.90 hedge on same B).
No submit. Artifacts: `results/h13_decision.json`, `h13_sim_result.json`.
