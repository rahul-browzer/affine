# s4-h5-talentpigs — result

## Verdict: H5 merge parents **REFUTED**

| α | outcome | deciding number |
|---|---|---|
| 0.65 | chall INVALID (`baseline_band_exceeded`) | base×=**4.431**; r=1.077; margin forced 0 |
| 0.50 | **unpromptable** before scoring | `probe_no_parsable_action_in_3_turns`; manual chall sample = `**` loops |

## Artifacts

- α0.65: `results/h5_kt65_sim_result.json`, `h5_decision.json`
- α0.50: `results/h5_kt50_sim_result.json`, `h5_a50_decision.json`,
  `h5_kt50_identity.json` (non-identical to king/A; still broken gen)

## Interpretation

Kevin×TalentPigs linear merge at α=0.65 inflates empty baseline past the
1.25× band (H4 / RT-3d). α=0.50 equal-weight MoE merge destroys generation
(gibberish). Do not submit either ckpt. Freed `/root/merges/h5-kt50` on pod.

## Next

`experiments/s4-h5b-talentpigs-distill/` — TalentPigs-init thought-only
LoRA (lr=1e-5).
