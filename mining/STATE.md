# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H50–H54 live (5/5).** H40–H49 REFUTED; H49 m=+0.01174.
No submit. Best family still **H42 lr5e-6 m=+0.01613** (<0.04).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$188,772** · cum mining ~$6,050 · **avail ~$178.8k** |
| miner | τ10.000 free · 0 submissions |
| H50 | n80 a203 **~68/80** |
| H51 | pre-freeze OK → n80 a203 **just started** @04:28Z |
| H52 | n80 a203 **~62/80** |
| H53 | n80 a203 **~50/80** |
| H54 | TRAIN_LAUNCHED lr8e-6 pid=2563 (teacher/king DL parallel) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h50-1 | eager-hawk-5b | 152.236.142.237:40499 | ~15:03Z | H50 n80 a203 |
| mine-h51-1 | brave-lion-47 | 152.236.142.232:40300 | ~15:03Z | H51 n80 a203 |
| mine-h52-1 | noble-wolf-4b | 38.255.28.18:20099 | ~15:05Z | H52 n80 a203 |
| mine-h53-1 | zesty-raven-e1 | 38.255.28.22:20100 | ~15:20Z | H53 n80 a203 |
| mine-h54-1 | calm-matrix-9c | 152.236.142.236:40300 | ~16:23Z | H54 train lr8e-6 |

known_hosts `/tmp/mine-h{50,51,52,53,54}-1.known_hosts`.
**Free slots: 0.** Burn ~$148/h mining.

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H36
α / H30–H35 king-self / **any TP×king-self** / m7×union@H36 /
**H28@lr≥3e-5** / **H28@epochs≥2** / **H28@r≥32** / **H42@lr=5e-6** /
**H43@α≥64** / **H40@ep≥2** / **H44@clipL1≥0.08** / **H47@α≤8** /
**H46@lr≤2.5e-6** / **H48@lr≤1e-6** / **H45@r≤8** / **H49@α=4**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
H51 pre-freeze method proven — do not relaunch chall while n80 alive.

## Next action

1. Poll H50 (nearest ~68/80) → `h50_decision.json` first.
2. Poll H52/H53/H51 → `hN_decision.json`.
3. REFUTE → `lium rm mine-hN-1` only; fill non-α H28-neighbour (not dead).
4. Hyperparams: H50 lr7.5e-6 · H51 α16 · H52 lr6e-6 · H53 lr4e-6 · H54 lr8e-6.
