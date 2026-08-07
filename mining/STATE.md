# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H21/H22/H23/H24/H25 live (cap 5/5). H20 REFUTED.**
H1–H20/H5c/H6 **REFUTED**. No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | ~$32,570 · ~$1,630 · cap rem ~$2,370 |
| miner | τ10.000 free · 0 submissions |
| H20 | **REFUTE** n80 m=−0.01168 z=−1.54 base×1.118 valid → rm |
| H21 | engines OK; n80 started 16:18Z |
| H22 | merging ~11/16 |
| H25 | merging ~9/16 |
| H23 | DL TalentPigs after pip |
| H24 | launched bootstrap COUNT=8 @$28 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h21-1 | golden-wolf-62 | 152.236.142.237:40310 | 23:41Z | H21 n80 just started |
| mine-h22-1 | lunar-shark-f2 | 38.255.28.21:20100 | 23:42Z | H22 merge ~11/16 |
| mine-h23-1 | gentle-fox-b5 | 204.9.206.244:40300 | 00:10Z | H23 DL parents |
| mine-h24-1 | brave-orbit-31 | 152.236.142.234:40311 | 00:17Z | H24 bootstrap |
| mine-h25-1 | golden-shark-c8 | 152.236.142.232:40305 | 00:08Z | H25 merge ~9/16 |

known_hosts `/tmp/mine-h{21,22,23,24,25}-1.known_hosts`. **0 free slots.**

## Blocked

No submit until some n80 margin > 0.04. Origin adambell gated; H25 uses
Radiant28 mirror. alskdjf/Tok*/qpoewir/affine-god gated.

## Next action

**Poll nested `*_decision.json` on h21–h25.** H21 n80 early — if engines
die, wipe `/root/.triton/cache/{king,chall}` + relaunch chall@0.72 +
`watch_engines_then_n80`. On genuine REFUTE: `lium rm` that `mine-h*-1` only;
ignore `*.FALSE_PROBE.json`. Free slot → next ungated +margin B (none staged;
re-scan `api/v1/snapshot` queue / duel table). Prefer `lium up --gpu H200 -c 8`
≥$28/h; reject COUNT≠8 or <$20/h.
