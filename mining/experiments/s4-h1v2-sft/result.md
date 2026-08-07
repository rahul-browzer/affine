# s4-h1v2-sft — result (DONE)

## Verdict

**revise_recipe / H1v2 REFUTED for submit** — do **not** submit this
checkpoint. Thought-only teacher-ref LoRA from kevin reaches ~king parity
on n80 but misses the Stage-4 gate (margin > 0.04) and H4 envelope.

| metric | n80 |
|---|---|
| margin | **−0.00030** |
| z / SE | −0.038 / 0.00787 |
| chall S / king S | 0.00531 / 0.00561 |
| both valid | yes |
| chall r / base× | **0.904** / 0.997 |
| H4 design envelope | **FAIL** (r∉[0.70,0.85]; slightly high) |
| mean clip-L1 chall | **+0.01509** (met ≥+0.015 pred) |
| triage action | `revise_recipe` |
| sim king | kevin954/…-sft @ `6a5815…` |
| live king at triage | **TalentPigs/affine-5ekxlcg3fx-abc** @ `dbfbb3e2…` (reign 3, S=0.0315) |

Prediction ≥ +0.04 missed. Submit gate never approached. Live-king guard
`match=false` — chal-00284 crowned TalentPigs at 06:15Z while n80 was
still sampling against kevin.

## Decomposition (n80, 319 pairs)

| side | mean_Λ2 | mean L1lift | mean clip-L1 | S |
|---|---|---|---|---|
| king (kevin) | −0.01141 | +0.01204 | **+0.01702** | 0.00561 |
| chall (H1v2) | **−0.00978** | +0.01305 | +0.01509 | 0.00531 |

Thought-only restored clip-L1 vs H1 (H1 n80 clip-L1 +0.006) and slightly
beat kevin on Λ2, but kevin's clip-L1 still wins the mix → margin ≈ 0.
r=0.904 is closer to the winner band than H1's 0.99–1.14 but still above
0.85.

## Timing

- n80 launch: 05:41:16Z → **06:19:xxZ** (~38 min; elapsed in result JSON)
- Harvested + triaged: 06:20:02Z
- Host harvest killed after SCP to prevent early-teardown (pod kept for
  new-king pivot; deadman still 08:00Z)

## Decision rule application

- margin < 0.02 on n80 → revise recipe; **no slot burn**
- H1v2 thought-only LoRA from this train is closed for submit vs kevin
- Do **not** re-sim this ckpt against kevin; live king is TalentPigs
- Next: pivot `mine-sim-1` to new king (download + re-serve :8001) and
  open H5 / merge-vs-TalentPigs / milder distill from TalentPigs init

## Artifacts

- `results/h1v2_sim_result.json` / `_artifact.json`
- `results/h1v2_decision.json` (primary=n80, submit=false)
- `results/h1v2_n80_confirmed.json` / `h1v2_n80_decomp.json`
- `results/KEEP_POD_FOR_PIVOT.txt`
- HF merged: `unconst/Affine-5czsc2fc98-h1v2-merged` @ `a314357…`
  (salvage only; not a submission)
- HF adapter: `unconst/Affine-5czsc2fc98-h1v2-lora` @ `6c964d35…`
