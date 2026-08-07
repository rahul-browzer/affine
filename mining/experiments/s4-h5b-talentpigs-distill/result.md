# s4-h5b-talentpigs-distill — result (DONE)

## Verdict

**revise_recipe / H5b REFUTED for submit** — do **not** submit
`unconst/Affine-5czsc2fc98-h5b-merged` (or the LoRA). TalentPigs-init
thought-only LoRA (lr=1e-5, 1 epoch, 440 refs) is gate-valid and slightly
above the king on this slice, but misses both the contract noise floor
(0.02) and the Stage-4 submit gate (0.04).

| metric | n80 |
|---|---|
| margin | **+0.00322** |
| z / SE | **0.547** / 0.00589 |
| chall S / king S | 0.04699 / 0.04405 |
| both valid | yes |
| chall r / base× | **0.670** / **0.949** |
| H4 design envelope | **FAIL** (r∉[0.70,0.85]; slightly low) |
| mean clip-L1 chall (S−Λ2) | **+0.0336** (met ≥+0.015 pred) |
| triage action | `revise_recipe` |
| sim king | TalentPigs/…-abc @ `dbfbb3e2…` |
| live king at triage | same (match=true); chal-00300 loading |

Prediction ≥ +0.04 missed by ~12×. `challenger_wins=false` (z≪3).
Submit=false. No hotkey burned.

## Decomposition (n80)

| side | mean_Λ2 | clip-L1 approx (S−Λ2) | S | gate_pass | bank | r |
|---|---|---|---|---|---|---|
| king (TalentPigs) | 0.00936 | +0.0347 | 0.04405 | 0.807 | 0.561 | 0.650 |
| chall (H5b) | **0.01336** | +0.0336 | **0.04699** | 0.761 | 0.600 | 0.670 |

Λ2 improved vs king (~+0.004) but clip-L1 stayed flat / slightly worse.
Mix margin collapses to noise. Mild king-init distill on 440 refs cannot
clear δ=0.02 against TalentPigs.

## Timing

- n80 launch: ~08:40Z → done **09:25:18Z** (~45 min; elapsed_s≈2658)
- attempt 1/3 OK; no retries
- harvest triage: **09:25:48Z** → `h5b_decision.json`
- PIPELINE_DONE + `h5b_sim_n80.done` / `h5b_pipeline.done` under `/root/logs/`

## Decision rule application

- margin **0.00322 < 0.02** → refute H5b; **no slot burn**
- H4 fail (r=0.670) is secondary to the ranking miss
- Do not iterate the same recipe hoping for slice luck
- Next (from plan.md): different lever — more/better refs, kevin-init
  measured vs TalentPigs, pandora path, or mine TalentPigs crown duel
  publicly before another LoRA burn

## Artifacts

- `results/h5b_sim_result.json` (+ pod artifact
  `/root/affine_data/h5b_sim_result_artifact.json`)
- `results/h5b_decision.json` (primary=n80, submit=false)
- `results/host_harvest_h5b.done`
- HF: `…-h5b-lora` @ `ad537ed…`; `…-h5b-merged` @ `e1d39a1…`
  (private salvage only)
