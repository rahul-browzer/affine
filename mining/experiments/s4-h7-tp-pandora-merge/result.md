# H7 result — REFUTED

## Verdict

n80 vs TalentPigs (`dbfbb3e2…`): **challenger INVALID** — `baseline_band_exceeded`.
Decision `REFUTE_H7` via `write_merge_decision.py#nested_verdict` at 2026-08-07T12:26:25Z.
`mine-h7-1` torn down same pass. Do not submit. Do not try α0.85 (gate fail, not margin near-miss).

## Numbers

| side | valid | S | r | baseline_abs | base× | Λ2 | mix |
|---|---|---|---|---|---|---|---|
| chall α0.75 TP×pandora | **false** | — | 0.997 | 0.305 | **2.21** | −0.0229 | −0.0208 |
| king TalentPigs | true | 0.0270 | 0.749 | 0.138 | 1.00 | +0.0009 | +0.0270 |

- gate_pass_rate 0.827 / bank_frac 0.275 — both above γ/γ_bank; **only** band 1.25× failed.
- margin/z reported 0 (invalid challenger); S_k=0.0270 on this slice.

## Interpretation

Same failure mode as H5 kevin-dom α0.65 (base×4.43): 25% pandora still sabotages empty-baseline.
Λ2 also collapsed (−0.023). Pandora is a toxic merge parent for TalentPigs-dominant linear merges
at α≤0.75. Artifacts: `results/h7_decision.json`, `results/h7_sim_result.json`.
