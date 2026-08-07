# H8 result — REFUTED

## Verdict

n80 vs TalentPigs (`dbfbb3e2…`): **challenger INVALID** — `baseline_band_exceeded`.
Decision `REFUTE_H8` via `write_merge_decision.py#nested_verdict` at 2026-08-07T12:30:57Z.
`mine-h8-1` torn down same pass (~$27). Do not submit. No α0.85 (gate fail, not margin near-miss).

## Numbers

| side | valid | S | r | baseline_abs | base× | Λ2 | mix |
|---|---|---|---|---|---|---|---|
| chall α0.75 TP×golden-crown | **false** | — | 0.934 | 0.249 | **1.97** | −0.0184 | −0.0048 |
| king TalentPigs | true | 0.0185 | 0.773 | 0.127 | 1.00 | −0.0078 | +0.0185 |

- gate_pass_rate 0.857 / bank_frac 0.323 — above γ/γ_bank; **only** band 1.25× failed.
- margin/z reported 0 (invalid challenger); S_k=0.0185 on this slice.

## Interpretation

Same failure mode as H7 pandora (base×2.21) and H5 kevin-dom: 25% null-S reign earner
still sabotages empty-baseline vs TalentPigs. Do not retry golden-crown merges at α≤0.75.
Artifacts: `results/h8_decision.json`, `results/h8_sim_result.json`.
