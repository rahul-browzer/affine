# s4-h1-sft — result (DONE)

## Verdict

**revise_recipe / recipe REFUTED for submit** — do **not** submit this
checkpoint. Full-completion teacher-ref LoRA from kevin fails the Stage-4
gate on both n40 and n80. Successor: **H1v2** thought-only distill.

| metric | n40 | n80 |
|---|---|---|
| margin | −0.00241 | **−0.01994** |
| z / SE | −0.183 / 0.0132 | −2.425 / 0.00822 |
| chall S / king S | −0.03548 / −0.03263 | −0.00687 / 0.01281 |
| both valid | yes | yes |
| chall r / base× | 1.135 / 0.817 | 0.992 / 0.848 |
| H4 design envelope | FAIL | FAIL (r∉[0.70,0.85]) |
| triage action | `revise_recipe` | `revise_recipe` |
| live king guard | match kevin `6a5815…` | match kevin `6a5815…` |

n80 is **worse** than n40 by ~0.0175 (slice variance + SE shrink); prediction
≥ +0.04 missed on both. Submit gate never approached.

## Decomposition (n80)

Implied mean clip-L1 ≈ S − mean_Λ2:

| side | mean_Λ2 | implied clip-L1 | S |
|---|---|---|---|
| king | −0.00651 | **+0.01932** | 0.01281 |
| chall (H1 merged) | −0.01289 | **+0.00602** | −0.00687 |

Unlike n40 (chall slightly better Λ2, negative clip-L1), n80 shows chall
**worse on both Λ2 and clip-L1**. Calib ratio 0.992 still outside the
winner band ~0.72–0.81. Envelope broken either way — matches H3/H4.

## Timing

- n40: 04:10:15Z → **04:27:07Z** (~17 min)
- n80: restarted 04:39Z (timeout patch) → **05:18:46Z** (~38 min this run;
  elapsed_s 2306 ≈ 38.4 min; prior dead attempt burned ~16 turns)
- Soft 06:50Z / deadman 07:00Z still hold for H1v2 path

## Decision rule application

- margin < 0.02 on n80 → revise recipe; **no slot burn**
- H1 full-completion LoRA from this train is closed for submit
- Do not re-serve or re-sim this merged ckpt; GPUs 0–5 free for H1v2
  chall restart once H1v2 train.done + merge finish

## Artifacts

- `results/h1_sim_result_n40.json` / `_artifact.json`
- `results/h1_sim_result.json` (n80)
- `results/h1_decision.json` (primary=n80)
- `results/h1_n80_confirmed.json`
- HF merged: `unconst/Affine-5czsc2fc98-h1-merged` @ `3364892cefcc…`
  (salvage only; not a submission)
