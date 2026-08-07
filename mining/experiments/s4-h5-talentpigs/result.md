# s4-h5-talentpigs — results

## α=0.65 kevin×TalentPigs (n80) — 2026-08-07T07:15:40Z

**Verdict: REJECT — challenger gate-invalid (baseline band).** Do not submit.

| metric | king (TalentPigs) | chall (h5-kt65 α0.65) |
|---|---|---|
| valid | true | **false** |
| S | 0.02874 | null (mean_mix −0.04785) |
| gate_pass_rate | 0.827 | 0.721 |
| bank_frac | 0.502 | 0.209 |
| calib_r | 0.746 | **1.077** |
| baseline_abs | 0.1218 | **0.5398** |
| base× | 1.0 | **4.431** |
| mean_Λ2 | +0.00020 | −0.0332 |
| n_pairs | 318 | 68 |

- Paired margin forced **0.0** (chall INVALID); n_paired=47; z=0.
- `baseline_band_exceeded: true` (contract 1.25×).
- H4 FAIL: r∉[0.70,0.85], base×≫1.15.
- Triage `reject_gates`; `submit=false`. Live-king guard match=true.
- Identity: 2-shard merge vs 16-shard king; `identical_to_king=false`.
- Elapsed sim ≈ 1719s. Artifacts: `results/h5_kt65_sim_result.json`,
  `h5_kt65_sim_result_artifact.json`, `h5_decision.json`.

### Interpretation

Linear α=0.65 (kevin-heavy) destroyed empty-baseline calibration: chall
mean|lpA(y_C|∅)| ≈ 4.4× king. Ranking never reached — band gate killed S.
Same parents at α=0.50 (more TalentPigs) is the pre-registered next shot
before refuting the merge family.

## α=0.50 — in flight (pass 77)

See `results/h5_a50_launched.json` / STATE.md.
