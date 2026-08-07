# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H20/H21/H22 n80 path; H25+H23 bootstrap; H24 staged (cap 5/5).**
H1–H19/H5c/H6 **REFUTED**. No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | ~$32,592 · ~$1,580 · cap rem ~$2,420 |
| miner | τ10.000 free · 0 submissions |
| H20 | n80 **72/80** @16:12Z (TP×leary α0.90; chall@0.72) |
| H21 | Triton crash→**recovered** king+chall loading; watchdog→n80 |
| H22 | DL done; **merging** kevin α0.90 |
| H25 | DL Radiant28 B after TP done |
| H23 | pip install on 8×B300 |
| H24 | staged next free → TP×0ronoCris α0.90 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h20-1 | swift-lion-ac | 38.255.28.22:20100 | 22:53Z | H20 n80 72/80 |
| mine-h21-1 | golden-wolf-62 | 152.236.142.237:40310 | 23:41Z | H21 engines→n80 |
| mine-h22-1 | lunar-shark-f2 | 38.255.28.21:20100 | 23:42Z | H22 merge |
| mine-h25-1 | golden-shark-c8 | 152.236.142.232:40305 | 00:08Z | H25 DL B |
| mine-h23-1 | gentle-fox-b5 | 204.9.206.244:40300 | 00:10Z | H23 pip |

known_hosts `/tmp/mine-h{20,21,22,23,25}-1.known_hosts`. **0 free slots.**

## Blocked

No submit until some n80 margin > 0.04. Origin adambell gated; H25 uses
Radiant28 mirror. alskdjf/Tok*/qpoewir/affine-god gated.

## Next action

**Poll nested `*_decision.json` on h20–h23/h25.** H21: confirm
`/root/affine_data/h21_decision.json` (or progress) after recover — if engines
dead again, wipe `/root/.triton/cache/{king,chall}` + relaunch chall@0.72.
On genuine REFUTE: `lium rm` that `mine-h*-1` only; ignore `*.FALSE_PROBE.json`.
Free slot → launch **H24** (`experiments/s4-h24-tp-ronocris-a90/upload_and_launch.sh`).
Prefer `lium up --gpu H200 -c 8` ≥$28/h; reject COUNT≠8 or <$20/h.
