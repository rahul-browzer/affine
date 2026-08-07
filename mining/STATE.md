# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H23/H24/H26/H27 live (4/5). H25 REFUTED.**
H1–H22/H5c/H6/H20/H25 **REFUTED**. No submit. Clip-L1 rank: `s2-clip-l1-rank`.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | **~$191,070** · cum mining ~$2,245 · **avail ~$181k** (floor $10k) |
| miner | τ10.000 free · 0 submissions |
| H25 | **REFUTE** m=+0.00662 z=0.76 base×1.133; pod rm'd |
| H24 | **n80 ~42/80** · form+retry armed |
| H23 | **n80 started** probe=ok @18:06Z (B300) |
| H26 | **n80 ~9/80** · form+retry armed |
| H27 | LoRA **step ~35/51** loss≈0.41; t/k prewarm held GPU0–3 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h23-1 | gentle-fox-b5 | 204.9.206.244:40300 | ~00:10Z | H23 n80 running |
| mine-h24-1 | brave-orbit-31 | 152.236.142.234:40311 | ~00:17Z | H24 n80 ~42/80 |
| mine-h26-1 | swift-matrix-98 | 38.255.28.22:20100 | ~01:21Z | H26 n80 ~9/80 |
| mine-h27-1 | noble-orbit-fb | 38.255.28.21:20099 | ~05:34Z | H27 LoRA ~35/51 |

known_hosts `/tmp/mine-h{23,24,26,27}-1.known_hosts`. **1 free slot.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21 / H22 / H25 / α lottery.**
Never tear down on null-margin + `ConnectError`/`unpromptable` — false probe.
Never `pkill -f` a pattern that appears in the SSH remote cmdline.
Health=200 ≠ alive — require `/v1/completions` probe before n80.
**B300:** FA patch + SERVE_STAGGER_S≥45; H23 cleared probe this pass.

## Next action

1. Free slot: design+rent **H28** (non-α; prefer clip-L1 shape / non-merge) OR wait H27.
2. Poll H24/H26/H23 decisions; genuine REFUTE → `lium rm` that pod only.
3. H27: after `train.done` merge→yield chall→n80 (keep prewarm 0–3).
