# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H23/H24/H26/H27/H28 live (5/5). H25 REFUTED.**
H1–H22/H5c/H6/H20/H25 **REFUTED**. No submit. Clip-L1 rank: `s2-clip-l1-rank`.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | **~$191,031** · cum mining ~$2,290 · **avail ~$181k** (floor $10k) |
| miner | τ10.000 free · 0 submissions |
| H25 | **REFUTE** m=+0.00662 z=0.76 base×1.133; pod rm'd |
| H24 | **n80 ~55/80** · form+retry armed · engines OK |
| H23 | **king relaunch** (EngineDeadError sample_tokens) → wait probe→n80 |
| H26 | **n80 ~25/80** · form+retry armed |
| H27 | LoRA still training GPUs6–7; t/k prewarm on 0–3 |
| H28 | m7 download ~42%+ → train after DL |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h23-1 | gentle-fox-b5 | 204.9.206.244:40300 | ~00:10Z | king recover→n80 |
| mine-h24-1 | brave-orbit-31 | 152.236.142.234:40311 | ~00:17Z | H24 n80 ~55/80 |
| mine-h26-1 | swift-matrix-98 | 38.255.28.22:20100 | ~01:21Z | H26 n80 ~25/80 |
| mine-h27-1 | noble-orbit-fb | 38.255.28.21:20099 | ~05:34Z | H27 LoRA train |
| mine-h28-1 | swift-hawk-e1 | 152.236.142.232:40311 | ~06:11Z | H28 m7 DL→train |

known_hosts `/tmp/mine-h{23,24,26,27,28}-1.known_hosts`. **Cap full (5/5).**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21 / H22 / H25 / α lottery.**
Never tear down on null-margin + `ConnectError`/`unpromptable`/`EngineDeadError` — false probe.
Never `pkill -f` a pattern that appears in the SSH remote cmdline.
Health=200 ≠ alive — require `/v1/completions` probe before n80.
**B300:** FA patch + SERVE_STAGGER_S≥45.

## Next action

1. H23: confirm `/root/logs/h23_king_recover_pass176.log` shows king probe=ok + `start_h23_n80` relaunched; then poll n80.
2. Poll H24 (nearest finish ~55/80); genuine REFUTE → `lium rm` that pod only.
3. H27: after `train.done` merge→yield chall→n80 (keep prewarm 0–3).
4. H28: confirm TRAIN_LAUNCHED after m7 DL.
