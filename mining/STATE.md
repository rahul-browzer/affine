# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H23/H26/H27/H28 live (4/5). H24/H25 REFUTED.**
H1–H22/H5c/H6/H20/H24/H25 **REFUTED**. No submit. Clip-L1 rank: `s2-clip-l1-rank`.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | **~$190,986** · cum mining ~$2,370 · **avail ~$181k** (floor $10k) |
| miner | τ10.000 free · 0 submissions |
| H24 | **REFUTE** m=−0.00466 z=−0.58 base×1.049; pod rm'd |
| H23 | **king Triton relaunch pass177** → wait probe→n80 |
| H26 | **n80 ~55/80** · form+retry armed |
| H27 | train DONE 18:17Z loss≈0.50; **merge save** → chall→n80 |
| H28 | TRAIN live ~step6/51 m7-init |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h23-1 | gentle-fox-b5 | 204.9.206.244:40300 | ~00:10Z | king recover177→n80 |
| mine-h26-1 | swift-matrix-98 | 38.255.28.22:20100 | ~01:21Z | H26 n80 ~55/80 |
| mine-h27-1 | noble-orbit-fb | 38.255.28.21:20099 | ~05:34Z | H27 merge→chall→n80 |
| mine-h28-1 | swift-hawk-e1 | 152.236.142.232:40311 | ~06:11Z | H28 LoRA train |

known_hosts `/tmp/mine-h{23,26,27,28}-1.known_hosts`. **Free slots: 1.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21–H25 / α lottery.**
Never tear down on null-margin + `ConnectError`/`unpromptable`/`EngineDeadError`.
Health=200 ≠ alive — require `/v1/completions` probe; if probe kills engine
(Triton `.so` missing), wipe `king_*` caches + unique TCACHE + relaunch (not wait).
**B300:** FA patch + SERVE_STAGGER_S≥45.

## Next action

1. H27: confirm `h27_merge.done` + chall:8002 probe=ok + n80 started; poll margin.
2. H23: `tail /root/logs/h23_king_recover_pass177.log` for probe=ok + n80 relaunch.
3. Poll H26 n80; genuine REFUTE → `lium rm mine-h26-1` only.
4. H28: poll `trainer_state` / `train.done` (keep slot free until H26/H23 resolve).
