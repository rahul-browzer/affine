# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H6/H12/H13 n80 live; H14 boot; H9/H11 REFUTED.** 0–3 done.
H2/H1/H1v2/H5/H5b/H5c/H7/H8/H9/H10/H11 **REFUTED**. H6/H12–H14 open.
No submit. Cap **4/5** (1 free).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | check `contract.submission` (was 8767079) |
| Lium / spend | $33,114 · ~$760 · cap rem ~$3,240 |
| miner | τ10.000 free · 0 submissions |
| H6 | n80 ~70/80; retry watcher armed |
| H9 | **REFUTED** base×1.851 band; pod rm'd |
| H11 | **REFUTED** base×1.866 band; pod rm'd |
| H12 | n80 ~53/80; inline 3× retry |
| H13 | downloading parents (kkk-af); watchers armed |
| H14 | **boot** TP×kkkk@3ca1ebe6 (pipeline pid 878) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h5c-1 | golden-hawk-dc | 152.236.142.234:40298 | 19:37Z | H6 final n80 |
| mine-h12-1 | calm-hawk-89 | 152.236.142.237:40311 | 20:42Z | H12 n80 |
| mine-h13-1 | zesty-orbit-df | 38.255.28.22:20099 | ~21:32Z | H13 bootstrap→n80 |
| mine-h14-1 | swift-orbit-cd | 38.255.28.19:20100 | ~21:38Z | H14 bootstrap→n80 |

known_hosts `/tmp/mine-h{5c,12,13,14}-1.known_hosts`. **1 free slot.**

## Blocked

No submit until some n80 margin > 0.04. No pandora/golden-crown/kevin/
diane/adambell merges (all band-INVALID at α0.75). H9/H11 closed.

## Next action

**Poll for nested `*_decision.json` (H6 ~70/80, H12 ~53/80; then H13/H14).**
On REFUTE: `lium rm` that `mine-h*-1` only. Free slot → stage next hyp
(avoid α0.75 B-parents that inflate empty-baseline). TRY_ALPHA_085 if
0.02≤m≤0.04; ADVANCE if m>0.04.
