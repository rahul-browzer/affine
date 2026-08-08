# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H56/H59–H62 live (5/5).** No submit.
Best family still **H42 lr5e-6 m=+0.01613** (<0.04).
**H58 REFUTE** m=+0.01466 @ lr=5.1e-6 (pass259).
**H54/H57/H55** also REFUTE this wave. H62 launched on freed slot.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$188,205** · cum mining ~$7,180 · **avail ~$178.2k** |
| miner | τ10.000 free · 0 submissions |
| H56 | n80 b203 @ **~31**/80 |
| H59 | n80 b203 @ **~26**/80 |
| H60 | merge save (~62G) after train.done @ lr=5.3e-6 |
| H61 | merge load after train.done @ lr=5.15e-6 |
| H62 | bootstrap (fresh rent) @ **r=20** |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h56-1 | swift-fox-1d | 152.236.142.237:40099 | ~16:38Z | n80 b203 |
| mine-h59-1 | lunar-comet-0f | 152.236.142.232:40300 | ~18:17Z | n80 b203 |
| mine-h60-1 | swift-eagle-4e | 38.255.28.22:20100 | ~18:27Z | merge→chall→n80 |
| mine-h61-1 | golden-matrix-4b | 38.255.28.18:20100 | ~18:47Z | merge→chall→n80 |
| mine-h62-1 | golden-matrix-66 | 152.236.142.236:40310 | ~19:01Z | bootstrap→train |

known_hosts `/tmp/mine-h{56,59,60,61,62}-1.known_hosts`.
**Free slots: 0.** Burn ~$148/h mining.

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H36
α / H30–H35 king-self / **any TP×king-self** / m7×union@H36 /
**H28@lr≥3e-5** / **H28@epochs≥2** / **H28@r≥32** / **H42@lr=5e-6** /
**H43@α≥64** / **H40@ep≥2** / **H44@clipL1≥0.08** / **H47@α≤8** /
**H46@lr≤2.5e-6** / **H48@lr≤1e-6** / **H45@r≤8** / **H49@α=4** /
**H50@lr=7.5e-6** / **H52@lr=6e-6** / **H53@lr=4e-6** / **H51@α=16** /
**H55@lr=5.5e-6** / **H57@lr=5.25e-6** / **H54@lr=8e-6** /
**H58@lr=5.1e-6**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
**p253 diverse-freeze worked**. Prefer UUID rent ≥$28/h.

## Next action

1. H56/H59: wait n80 → decision.json; REFUTE/teardown if m≤0.04.
2. H60/H61: wait merge→chall→n80; H62: wait bootstrap→train→merge→n80.
3. First free slot → denser one-axis neighbour of best remaining open
   (after H56 r24 / H61 5.15 / H60 5.3 report). Prefer UUID ≥$28/h; COUNT=8;
   patch SOFT/DEADMAN to TTL−1h at rent.
