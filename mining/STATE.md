# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H6/H9/H11/H12 n80 live; H13 boot; H14 staged.** 0–3 done.
H2/H1/H1v2/H5/H5b/H5c/H7/H8/H10 **REFUTED**. H6/H9/H11–H14 open.
No submit. Cap **5/5**.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 (check contract.submission) |
| Lium / spend | $33,134 · ~$670 · cap rem ~$3,330 |
| miner | τ10.000 free · 0 submissions |
| H6 | n80 ~60/80; retry watcher armed |
| H9 | n80 retry ~73/80 |
| H10 | **REFUTED** base×1.983 band; pod rm'd |
| H11 | n80 ~75/80; retry watcher armed |
| H12 | n80 ~44/80; inline 3× retry |
| H13 | **boot** TP×kkk-af@7426296b (pipeline pid 888) |
| H14 | **staged+hardened** TP×kkkk@3ca1ebe6 (wait free slot) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h5c-1 | golden-hawk-dc | 152.236.142.234:40298 | 19:37Z | H6 final n80 |
| mine-h9-1 | noble-lion-ac | 38.255.28.21:20100 | ~20:07Z | H9 n80 retry |
| mine-h11-1 | swift-fox-b5 | 152.236.142.232:40311 | ~20:33Z | H11 n80 |
| mine-h12-1 | calm-hawk-89 | 152.236.142.237:40311 | 20:42Z | H12 n80 |
| mine-h13-1 | zesty-orbit-df | 38.255.28.22:20099 | ~21:32Z | H13 bootstrap→n80 |

known_hosts `/tmp/mine-h{5c,9,11,12,13}-1.known_hosts`. **Slots full.**
H6/H11: `watch_n80_retry`. H9/H12: inline 3×. H13: bootstrap + watchers armed.

## Blocked

No submit until some n80 margin > 0.04. No pandora/golden-crown/**kevin** merges (band).
H14: wait free slot → `upload_and_launch.sh`.

## Next action

**Poll for first nested `*_decision.json` (H11 ~75/80, then H9/H6/H12).**
Confirm H13 bootstrap→merge→n80. On REFUTE: `lium rm` that `mine-h*-1` only →
rent `mine-h14-1` (`DST_HOST=… DST_PORT=… bash experiments/s4-h14-tp-kkkk-merge/upload_and_launch.sh`).
TRY_ALPHA_085 if 0.02≤m≤0.04; ADVANCE if m>0.04.
