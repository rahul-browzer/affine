# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H54/H56–H59 live (5/5).** No submit.
Best family still **H42 lr5e-6 m=+0.01613** (<0.04).
**H55 REFUTE** band×1.256 @ lr=5.5e-6 (pass254).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$188,370** · cum mining ~$6,750 · **avail ~$178.4k** |
| miner | τ10.000 free · 0 submissions |
| H54 | n80 **c203** @ **16**/80 (retry after b203) |
| H55 | **REFUTE** band×1.256 · rm lunar-shark-0b (~$53) |
| H56 | p253 freeze OK → n80 a203 @ **16**/80 |
| H57 | n80 a203 @ **63**/80 |
| H58 | p253 freeze OK → n80 a203 @ **1**/80 |
| H59 | bootstrap (lr=5.75e-6) · lunar-comet-0f |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h54-1 | calm-matrix-9c | 152.236.142.236:40300 | ~16:23Z | n80 c203 @16/80 |
| mine-h56-1 | swift-fox-1d | 152.236.142.237:40099 | ~16:38Z | n80 a203 @16/80 |
| mine-h57-1 | eager-shark-95 | 38.255.28.18:20100 | ~16:44Z | n80 a203 @63/80 |
| mine-h58-1 | eager-matrix-0d | 38.255.28.21:20099 | ~17:22Z | n80 a203 @1/80 |
| mine-h59-1 | lunar-comet-0f | 152.236.142.232:40300 | ~18:17Z | bootstrap→train |

known_hosts `/tmp/mine-h{54,56,57,58,59}-1.known_hosts`.
**Free slots: 0.** Burn ~$148/h mining.

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H36
α / H30–H35 king-self / **any TP×king-self** / m7×union@H36 /
**H28@lr≥3e-5** / **H28@epochs≥2** / **H28@r≥32** / **H42@lr=5e-6** /
**H43@α≥64** / **H40@ep≥2** / **H44@clipL1≥0.08** / **H47@α≤8** /
**H46@lr≤2.5e-6** / **H48@lr≤1e-6** / **H45@r≤8** / **H49@α=4** /
**H50@lr=7.5e-6** / **H52@lr=6e-6** / **H53@lr=4e-6** / **H51@α=16** /
**H55@lr=5.5e-6** (band×1.256).
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
**p253 diverse-freeze worked** (H56+H58 → n80). Prefer UUID rent ≥$28/h.

## Next action

1. H57 (~63/80): wait decision → REFUTE/teardown if m≤0.04.
2. H54/H56/H58: wait n80 → decision.json.
3. H59: wait train→merge→n80; if bootstrap stalls, check `bootstrap_h59.log`.
4. Next free slot → **lr=5.3e-6** (between H58 5.1 and H57 5.25) or
   **r=20** if H56 reports first.
