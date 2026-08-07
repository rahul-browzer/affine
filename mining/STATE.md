# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H21–H25 live (cap 5/5). H26 staged. H20 REFUTED.**
H1–H20/H5c/H6 **REFUTED**. No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | ~$32,550 · ~$1,650 · cap rem ~$2,350 |
| miner | τ10.000 free · 0 submissions |
| H21 | n80 live ~2/80 chall · engines OK chall@0.72 |
| H22 | merge OK_NON_IDENTICAL; teacher+king loading |
| H25 | merge OK_NON_IDENTICAL; teacher loading |
| H23 | DL TalentPigs (~65G) |
| H24 | DL TalentPigs (~22G) |
| H26 | **staged** — next free slot |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h21-1 | golden-wolf-62 | 152.236.142.237:40310 | 23:41Z | H21 n80 ~2/80 |
| mine-h22-1 | lunar-shark-f2 | 38.255.28.21:20100 | 23:42Z | H22 engines up |
| mine-h23-1 | gentle-fox-b5 | 204.9.206.244:40300 | 00:10Z | H23 DL parents |
| mine-h24-1 | brave-orbit-31 | 152.236.142.234:40311 | 00:17Z | H24 DL TalentPigs |
| mine-h25-1 | golden-shark-c8 | 152.236.142.232:40305 | 00:08Z | H25 engines up |

known_hosts `/tmp/mine-h{21,22,23,24,25}-1.known_hosts`. **0 free slots.**

## Blocked

No submit until some n80 margin > 0.04. Origin adambell gated; H25 uses
Radiant28. alskdjf/Tok*/qpoewir/affine-god gated. kkk origin 404 → H26 mirror.

## Next action

**Poll nested `*_decision.json` on h21–h25.** On genuine REFUTE: `lium rm`
that `mine-h*-1` only; ignore `*.FALSE_PROBE.json`. Free slot → launch **H26**
(`experiments/s4-h26-tp-kkk-a90/`: `lium up --gpu H200 -c 8 --ttl 8h` name
`mine-h26-1`, COUNT=8 ≥$28/h, then `DST_HOST/PORT` → `upload_and_launch.sh`).
Staged next after H26: plmk mirror `bluecolor777/plmk@b2cc7b9f` (+0.014),
then `longertime/…-hk9@8be58079` (+0.008).
