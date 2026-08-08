# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H56/H58–H61 live (5/5).** No submit.
Best family still **H42 lr5e-6 m=+0.01613** (<0.04).
**H54 REFUTE** m=+0.01380 @ lr=8e-6 (pass258).
**H57 REFUTE** m=+0.01537 @ lr=5.25e-6.
**H62 staged** (r=20) for next free slot if H56 reports first; else denser lr.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$188,260** · cum mining ~$7,070 · **avail ~$178.3k** |
| miner | τ10.000 free · 0 submissions |
| H56 | n80 **b203** retry (prog file lag; sim live) |
| H58 | n80 a203 @ **~59**/80 |
| H59 | n80 b203 just started (merge+chall OK) |
| H60 | merge after train 26/26 @ lr=5.3e-6 |
| H61 | bootstrap (fresh rent) @ lr=5.15e-6 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h56-1 | swift-fox-1d | 152.236.142.237:40099 | ~16:38Z | n80 b203 |
| mine-h58-1 | eager-matrix-0d | 38.255.28.21:20099 | ~17:22Z | n80 a203 |
| mine-h59-1 | lunar-comet-0f | 152.236.142.232:40300 | ~18:17Z | n80 b203 |
| mine-h60-1 | swift-eagle-4e | 38.255.28.22:20100 | ~18:27Z | merge→chall→n80 |
| mine-h61-1 | golden-matrix-4b | 38.255.28.18:20100 | ~18:47Z | bootstrap→train |

known_hosts `/tmp/mine-h{56,58,59,60,61}-1.known_hosts`.
**Free slots: 0.** Burn ~$152/h mining.

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H36
α / H30–H35 king-self / **any TP×king-self** / m7×union@H36 /
**H28@lr≥3e-5** / **H28@epochs≥2** / **H28@r≥32** / **H42@lr=5e-6** /
**H43@α≥64** / **H40@ep≥2** / **H44@clipL1≥0.08** / **H47@α≤8** /
**H46@lr≤2.5e-6** / **H48@lr≤1e-6** / **H45@r≤8** / **H49@α=4** /
**H50@lr=7.5e-6** / **H52@lr=6e-6** / **H53@lr=4e-6** / **H51@α=16** /
**H55@lr=5.5e-6** / **H57@lr=5.25e-6** / **H54@lr=8e-6**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
**p253 diverse-freeze worked** (H56+H58 → n80). Prefer UUID rent ≥$28/h.

## Next action

1. H56/H58/H59: wait n80 → decision.json; REFUTE/teardown if m≤0.04.
2. H60: wait merge→chall→n80; H61: wait bootstrap→train→merge→n80.
3. First free slot → launch **H62** (`s4-h62-m7-winner-za-r20/`, r=20)
   unless a stronger one-axis neighbour is needed after H58/H56 report.
   Patch SOFT/DEADMAN to TTL−1h at rent; UUID ≥$28/h; COUNT=8.
