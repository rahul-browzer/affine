# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H18–H20 n80 live; H21/H22 bootstrapping; H23 staged (cap 5/5).**
H1–H17/H5c/H6 **REFUTED**. No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | ~$32,698 · ~$1,420 · cap rem ~$2,580 |
| miner | τ10.000 free · 0 submissions |
| H18 | n80 ~34/80 @15:45Z (TP×Shatoria α0.75) |
| H19 | n80 ~37/80 @15:45Z (TP×kkkk α0.90) |
| H20 | n80 ~22/80 @15:45Z (TP×leary α0.90; chall@0.72) |
| H21 | DL TalentPigs (pip OK) — TP×sft2 α0.75 |
| H22 | DL TalentPigs — TP×kevin α0.90 |
| H23 | **staged** TP×Talucampe ck5 α0.90 — launch on first free slot |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h18-1 | golden-comet-e1 | 152.236.142.232:40307 | 22:57Z | H18 n80 |
| mine-h19-1 | eager-eagle-c6 | 152.236.142.234:40297 | 22:50Z | H19 n80 |
| mine-h20-1 | swift-lion-ac | 38.255.28.22:20100 | 22:53Z | H20 n80 |
| mine-h21-1 | golden-wolf-62 | 152.236.142.237:40310 | 23:41Z | H21 bootstrap→n80 |
| mine-h22-1 | lunar-shark-f2 | 38.255.28.21:20100 | 23:42Z | H22 bootstrap→n80 |

known_hosts `/tmp/mine-h{18,19,20,21,22}-1.known_hosts`. **0 free slots.**

## Blocked

No submit until some n80 margin > 0.04. adambell ckpt1000-m7 (+0.018)
gated=manual. alskdjf/Tok*/qpoewir/affine-god gated. Sansaliu/completeyourprofile 404.
ally1/hope100 **absent** from public history (pass155).

## Next action

**Poll nested `*_decision.json` on h18–h22.** On genuine REFUTE: `lium rm`
that `mine-h*-1` only; ignore `*.FALSE_PROBE.json`. Free slot → launch **H23**
(`experiments/s4-h23-tp-talucampe-a90/upload_and_launch.sh`). H24 queue:
0ronoCris distill-ref-2 @d43ada88 (+0.0016 ungated). TRY_ALPHA_095 only if
gate-valid and 0.02≤m≤0.04.
