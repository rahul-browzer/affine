# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H45/H49–H52 live (5/5).** H40–H44,H46–H48 REFUTED.
No submit. Best family still **H42 lr5e-6 m=+0.01613** (<0.04).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$189,069** · cum mining ~$5,560 · **avail ~$179.1k** |
| miner | τ10.000 free · 0 submissions |
| H45 | **n80 b203** ~59/80 (engines 200/200/200) |
| H49 | **n80 a203** ~12/80 (engines 200/200/200) |
| H50 | **TRAIN_LAUNCHED** pid=2568 lr=7.5e-6 @03:07:51Z GPUs6–7 |
| H51 | **TRAIN_LAUNCHED** pid=2539 α16/r16 lr1e-5 @03:07:42Z GPUs6–7 |
| H52 | **TRAIN_LAUNCHED** pid=2848 lr=6e-6 @03:09:05Z GPUs6–7 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h45-1 | lunar-fox-40 | 152.236.142.236:40299 | ~13:13Z | H45 n80 b203 |
| mine-h49-1 | zesty-shark-45 | 86.38.238.54:40300 | ~13:59Z | H49 n80 a203 |
| mine-h50-1 | eager-hawk-5b | 152.236.142.237:40499 | ~15:03Z | H50 train lr7.5e-6 |
| mine-h51-1 | brave-lion-47 | 152.236.142.232:40300 | ~15:03Z | H51 train α16 |
| mine-h52-1 | noble-wolf-4b | 38.255.28.18:20099 | ~15:05Z | H52 train lr6e-6 |

known_hosts `/tmp/mine-h{45,49,50,51,52}-1.known_hosts`.
**Free slots: 0.** Burn ~$150/h mining.

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H36
α / H30–H35 king-self / **any TP×king-self** / m7×union@H36 /
**H28@lr≥3e-5** / **H28@epochs≥2** / **H28@r≥32** / **H42@lr=5e-6** /
**H43@α≥64** / **H40@ep≥2** / **H44@clipL1≥0.08** / **H47@α≤8** /
**H46@lr≤2.5e-6** / **H48@lr≤1e-6**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.

## Next action

1. Poll H45 → `h45_decision.json` (~59/80; ETA ~20–30m).
2. Poll H49 → `h49_decision.json` (~12/80).
3. REFUTE → `lium rm mine-hN-1` only; fill non-α H28-neighbour (not dead cells).
4. H50–H52: poll `trainer_state.json` / merge.done → n80 when train finishes.
