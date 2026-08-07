# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H20/H21/H22 n80; H25+H23 launched; H24 staged (cap 5/5).**
H1–H19/H5c/H6 **REFUTED**. No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | ~$32,592 · ~$1,560 · cap rem ~$2,440 |
| miner | τ10.000 free · 0 submissions |
| H18 | **REFUTE** band×1.997 invalid (α0.75 Shatoria) |
| H19 | **REFUTE** m=+0.00348 z=0.59 base×1.121 valid |
| H20 | n80 ~59/80 @16:05Z (TP×leary α0.90; chall@0.72) |
| H21 | engines up → wait_ready→n80 (TP×sft2 α0.75) |
| H22 | DL kevin still (~37GB incomplete @16:05Z) |
| H25 | **live** bootstrap DL TP (Radiant28/ckpt1000-m7 α0.90) |
| H23 | **live** bootstrap on 8×B300 (TP×Talucampe ck5 α0.90) |
| H24 | staged next free → TP×0ronoCris α0.90 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h20-1 | swift-lion-ac | 38.255.28.22:20100 | 22:53Z | H20 n80 |
| mine-h21-1 | golden-wolf-62 | 152.236.142.237:40310 | 23:41Z | H21 →n80 |
| mine-h22-1 | lunar-shark-f2 | 38.255.28.21:20100 | 23:42Z | H22 DL kevin |
| mine-h25-1 | golden-shark-c8 | 152.236.142.232:40305 | 00:08Z | H25 bootstrap |
| mine-h23-1 | gentle-fox-b5 | 204.9.206.244:40300 | 00:10Z | H23 bootstrap |

known_hosts `/tmp/mine-h{20,21,22,23,25}-1.known_hosts`. **0 free slots.**

## Blocked

No submit until some n80 margin > 0.04. Origin adambell gated; H25 uses
Radiant28 mirror. alskdjf/Tok*/qpoewir/affine-god gated.

## Next action

**Poll nested `*_decision.json` on h20–h23/h25.** On genuine REFUTE: `lium rm`
that `mine-h*-1` only; ignore `*.FALSE_PROBE.json`. Free slot → launch **H24**
(`experiments/s4-h24-tp-ronocris-a90/upload_and_launch.sh`). Prefer
`lium up --gpu H200 -c 8` landing ≥$28/h; reject COUNT≠8 or <$20/h. TRY_ALPHA_095
only if gate-valid and 0.02≤m≤0.04.
