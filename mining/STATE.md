# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H51/H53–H56 live (5/5).** H50/H52 REFUTED this pass.
No submit. Best family still **H42 lr5e-6 m=+0.01613** (<0.04).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$188,734** · cum mining ~$6,200 · **avail ~$178.7k** |
| miner | τ10.000 free · 0 submissions |
| H50 | **REFUTE m=+0.00322** (lr7.5e-6 dead) |
| H51 | n80 b203 **~12/80** |
| H52 | **REFUTE m=+0.01280** (lr6e-6 dead) |
| H53 | n80 a203 **~64/80** |
| H54 | TRAIN lr8e-6 (likely weak; H50 curve) |
| H55 | bootstrap→train lr5.5e-6 |
| H56 | bootstrap→train r=24 @ lr5e-6 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h51-1 | brave-lion-47 | 152.236.142.232:40300 | ~15:03Z | H51 n80 b203 |
| mine-h53-1 | zesty-raven-e1 | 38.255.28.22:20100 | ~15:20Z | H53 n80 a203 |
| mine-h54-1 | calm-matrix-9c | 152.236.142.236:40300 | ~16:23Z | H54 train lr8e-6 |
| mine-h55-1 | lunar-shark-0b | 38.255.28.19:20100 | ~16:36Z | H55 train lr5.5e-6 |
| mine-h56-1 | swift-fox-1d | 152.236.142.237:40099 | ~16:38Z | H56 train r=24 |

known_hosts `/tmp/mine-h{51,53,54,55,56}-1.known_hosts`.
**Free slots: 0.** Burn ~$148/h mining.

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H36
α / H30–H35 king-self / **any TP×king-self** / m7×union@H36 /
**H28@lr≥3e-5** / **H28@epochs≥2** / **H28@r≥32** / **H42@lr=5e-6** /
**H43@α≥64** / **H40@ep≥2** / **H44@clipL1≥0.08** / **H47@α≤8** /
**H46@lr≤2.5e-6** / **H48@lr≤1e-6** / **H45@r≤8** / **H49@α=4** /
**H50@lr=7.5e-6** / **H52@lr=6e-6**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
H51 pre-freeze method proven — do not relaunch chall while n80 alive.

## Next action

1. Poll H53 (nearest ~64/80) → `h53_decision.json` first.
2. Poll H51 → `h51_decision.json`; H54/H55/H56 train→n80.
3. REFUTE → `lium rm mine-hN-1` only; fill non-α H28-neighbour (not dead).
4. Live: H53 lr4e-6 · H51 α16 · H54 lr8e-6 · H55 lr5.5e-6 · H56 r24.
5. lr curve so far: **5e-6 (+0.016) > 6e-6 (+0.013) > 7.5e-6 (+0.003)**.
