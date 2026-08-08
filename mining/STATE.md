# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H54/H56/H58–H60 live (5/5).** No submit.
Best family still **H42 lr5e-6 m=+0.01613** (<0.04).
**H57 REFUTE** m=+0.01537 @ lr=5.25e-6.
**H61 staged** (lr=5.15e-6) for next free slot.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$188,333** · cum mining ~$6,900 · **avail ~$178.3k** |
| miner | τ10.000 free · 0 submissions |
| H54 | n80 **c203** @ **~47**/80 |
| H56 | n80 a203 @ **~37**/80 |
| H58 | n80 a203 @ **~31**/80 |
| H59 | train **~21**/26 @ lr=5.75e-6 · lunar-comet-0f |
| H60 | train launched @ lr=5.3e-6 · swift-eagle-4e |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h54-1 | calm-matrix-9c | 152.236.142.236:40300 | ~16:23Z | n80 c203 |
| mine-h56-1 | swift-fox-1d | 152.236.142.237:40099 | ~16:38Z | n80 a203 |
| mine-h58-1 | eager-matrix-0d | 38.255.28.21:20099 | ~17:22Z | n80 a203 |
| mine-h59-1 | lunar-comet-0f | 152.236.142.232:40300 | ~18:17Z | train→merge→n80 |
| mine-h60-1 | swift-eagle-4e | 38.255.28.22:20100 | ~18:27Z | train→merge→n80 |

known_hosts `/tmp/mine-h{54,56,58,59,60}-1.known_hosts`.
**Free slots: 0.** Burn ~$148/h mining.

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H36
α / H30–H35 king-self / **any TP×king-self** / m7×union@H36 /
**H28@lr≥3e-5** / **H28@epochs≥2** / **H28@r≥32** / **H42@lr=5e-6** /
**H43@α≥64** / **H40@ep≥2** / **H44@clipL1≥0.08** / **H47@α≤8** /
**H46@lr≤2.5e-6** / **H48@lr≤1e-6** / **H45@r≤8** / **H49@α=4** /
**H50@lr=7.5e-6** / **H52@lr=6e-6** / **H53@lr=4e-6** / **H51@α=16** /
**H55@lr=5.5e-6** / **H57@lr=5.25e-6**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
**p253 diverse-freeze worked** (H56+H58 → n80). Prefer UUID rent ≥$28/h.

## Next action

1. H54/H56/H58: wait n80 → decision.json; REFUTE/teardown if m≤0.04.
2. H59/H60: wait train→merge→n80; stall → `bootstrap_h*.log` / train.nohup.
3. First free slot → launch **H61** (`experiments/s4-h61-m7-winner-za-lr515e6/`,
   lr=5.15e-6) via `upload_and_launch.sh` — unless H56 reports first, then
   prefer **r=20**. Patch SOFT/DEADMAN to TTL−1h at rent.
