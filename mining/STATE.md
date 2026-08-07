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
| Lium / spend | **~$191,052** · cum mining ~$2,270 · **avail ~$181k** (floor $10k) |
| miner | τ10.000 free · 0 submissions |
| H25 | **REFUTE** m=+0.00662 z=0.76 base×1.133; pod rm'd |
| H24 | **n80 ~52/80** · form+retry armed |
| H23 | **n80 ~16/80** · form+retry armed |
| H26 | **n80 ~20/80** · form+retry armed |
| H27 | LoRA **step ~44/51** loss≈0.44; t/k prewarm held GPU0–3 |
| H28 | **bootstrap live** (m7-init + winner-zA LoRA); pip/venv |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h23-1 | gentle-fox-b5 | 204.9.206.244:40300 | ~00:10Z | H23 n80 ~16/80 |
| mine-h24-1 | brave-orbit-31 | 152.236.142.234:40311 | ~00:17Z | H24 n80 ~52/80 |
| mine-h26-1 | swift-matrix-98 | 38.255.28.22:20100 | ~01:21Z | H26 n80 ~20/80 |
| mine-h27-1 | noble-orbit-fb | 38.255.28.21:20099 | ~05:34Z | H27 LoRA ~44/51 |
| mine-h28-1 | swift-hawk-e1 | 152.236.142.232:40311 | ~06:11Z | H28 bootstrap→train |

known_hosts `/tmp/mine-h{23,24,26,27,28}-1.known_hosts`. **Cap full (5/5).**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21 / H22 / H25 / α lottery.**
Never tear down on null-margin + `ConnectError`/`unpromptable` — false probe.
Never `pkill -f` a pattern that appears in the SSH remote cmdline.
Health=200 ≠ alive — require `/v1/completions` probe before n80.
**B300:** FA patch + SERVE_STAGGER_S≥45.

## Next action

1. Poll H24/H26/H23/H27/H28; genuine REFUTE → `lium rm` that pod only.
2. H27: after `train.done` merge→yield chall→n80 (keep prewarm 0–3).
3. H28: confirm TRAIN_LAUNCHED (m7 DL + LoRA on GPUs 6,7); free slot only after a tear-down.
