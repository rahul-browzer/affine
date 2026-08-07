# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H21–H25 live (cap 5/5). H26 staged (lottery). H20 REFUTED.**
H1–H20/H5c/H6 **REFUTED**. No submit. Clip-L1 rank done (`s2-clip-l1-rank`).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | ~$32,488 · ~$1,720 · **avail ~$22,500** (floor $10k) |
| miner | τ10.000 free · 0 submissions |
| H21 | n80 ~33/80 (α0.75 — likely band) |
| H22 | n80 ~14/80 |
| H25 | n80 live (best clip-L1 parent +0.0435) |
| H23 | DL Talucampe (~89%) |
| H24 | engines loading → n80 next |
| H26 | staged lottery only; **not** next mean-shift |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h21-1 | golden-wolf-62 | 152.236.142.237:40310 | 23:41Z | H21 n80 ~33/80 |
| mine-h22-1 | lunar-shark-f2 | 38.255.28.21:20100 | 23:42Z | H22 n80 ~14/80 |
| mine-h23-1 | gentle-fox-b5 | 204.9.206.244:40300 | 00:10Z | H23 DL Talucampe |
| mine-h24-1 | brave-orbit-31 | 152.236.142.234:40311 | 00:17Z | H24 engines→n80 |
| mine-h25-1 | golden-shark-c8 | 152.236.142.232:40305 | 00:08Z | H25 n80 live |

known_hosts `/tmp/mine-h{21,22,23,24,25}-1.known_hosts`. **0 free slots.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk** (H16
m=+0.0097). Do not queue hk9/leary-tt (TP-era clipL1 ≤+0.020). qpoewir gated.

## Next action

**Prioritize H25 decision** (highest TP-era parent clip-L1). Poll nested
`*_decision.json` on h21–h25. Genuine REFUTE → `lium rm` that `mine-h*-1`
only. Free slot: if H25 not yet crowned, launch **H26** lottery
(`s4-h26-tp-kkk-a90/`) OR a **clip-L1-shaping** recipe (not another α0.90
of a mid-clipL1 B). Prefer shaping if H25 also fails. Never relaunch plmk.
