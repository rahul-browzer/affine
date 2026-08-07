# s4-h1-sft — result (partial; n40 DONE, n80 RUNNING)

## Verdict so far (n40)

**revise_recipe** — do **not** submit. H1 prediction (margin ≥ +0.04) missed
badly on the n40 probe. Leave n80 running for a cleaner SE, but do not expect
a crown from this checkpoint.

| metric | value |
|---|---|
| source | n40 (`h1_sim_result_n40.json`) |
| margin | **−0.00241** |
| z / SE | −0.183 / 0.0132 |
| chall S / king S | −0.03548 / −0.03263 |
| both valid | yes (gate_pass 0.867 / 0.938; bank 0.402 / 0.369) |
| chall r / base× | **1.135** / 0.817 |
| H4 envelope | **FAIL** (r∉[0.70,0.85]; base× OK) |
| live king guard | match (kevin @ `6a5815…`) |
| triage action | `revise_recipe` (`h1_decision.json`) |

## Decomposition (why)

Implied mean clip-L1 ≈ S − mean_Λ2 on the stored aggregates:

| side | mean_Λ2 | implied clip-L1 | S |
|---|---|---|---|
| king | −0.03801 | **+0.00537** | −0.03263 |
| chall (H1 merged) | −0.03455 | **−0.00093** | −0.03548 |

Challenger is slightly **better** on Λ2 than kevin on this slice, but
clip-L1 collapsed (negative) and calib_ratio drifted to **1.13** (winners sit
~0.72–0.81). Matches H3/H4: without the distill envelope, Λ2 gains do not
crown.

## Timing

- n40 launch 04:10:15Z → done **04:27:07Z** (~17 min for 40 turns)
- n80 launched immediately after (pid on pod; soft deadline 06:50Z, ~8573s slack)

## Decision rule application

- margin < 0.02 → revise recipe / consider H5; **no slot burn**
- Full H1 falsification waits on n80, but n40 already rules out submit

## Artifacts

- `results/h1_sim_result_n40.json`
- `results/h1_sim_result_n40_artifact.json`
- `results/h1_decision.json`
- HF merged: `unconst/Affine-5czsc2fc98-h1-merged` @ `3364892cefcc…`
