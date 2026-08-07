# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H6/H9/H10/H11/H12 parallel; H13 staged.** 0–3 done.
H2/H1/H1v2/H5/H5b/H5c/H7/H8 **REFUTED**. H6/H9–H12 open; H13 ready on next free slot.
No submit. Cap **5/5**.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | $33,225 · ~$590 · cap rem ~$3,410 |
| miner | τ10.000 free · 0 submissions |
| H6 | final n80 RUNNING (just started); retry watcher armed |
| H9 | n80 retry 1/3 ~12/80 |
| H10 | n80 ~32/80; retry watcher armed |
| H11 | n80 ~18/80; retry watcher armed |
| H12 | engines loading (teacher~60%, king/chall shards); n80 waits |
| H13 | **staged** TP×`bluecolor777/kkk-af`@7426296b |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h5c-1 | golden-hawk-dc | 152.236.142.234:40298 | 19:37Z | H6 final n80 |
| mine-h9-1 | noble-lion-ac | 38.255.28.21:20100 | ~20:07Z | H9 n80 retry 1/3 |
| mine-h10-1 | gentle-eagle-d5 | 38.255.28.19:20099 | ~20:10Z | H10 n80 |
| mine-h11-1 | swift-fox-b5 | 152.236.142.232:40311 | ~20:33Z | H11 n80 |
| mine-h12-1 | calm-hawk-89 | 152.236.142.237:40311 | 20:42Z | H12 serve→n80 |

known_hosts `/tmp/mine-h{5c,9,10,11,12}-1.known_hosts`. **Slots full.**
H6/H10/H11: `watch_n80_retry.sh` → `retry_*_n80.sh` (3×) if sim dies without decision.

## Blocked

No submit until some n80 margin > 0.04. No pandora / golden-crown merges (band).
H13: wait free slot after REFUTE teardown; `experiments/s4-h13-tp-kkk-merge/`.

## Next action

**Poll for first nested `*_decision.json` (H9 / H6 / H10 / H11 / H12).**
On REFUTE: `lium rm` that `mine-h*-1` only, then rent `mine-h13-1` +
`DST_HOST=… DST_PORT=… bash experiments/s4-h13-tp-kkk-merge/upload_and_launch.sh`.
H6 mid50 already SIGNAL_NEG — ignore; only final n80 counts.
TRY_ALPHA_085 if 0.02≤m≤0.04; ADVANCE if m>0.04.
If H10/H11/H6 abort with no decision, confirm watcher relaunched retry (logs
`/root/logs/{h6,h10,h11}_watch_retry.nohup` / `*_n80_retry.nohup`).
