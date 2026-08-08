# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H45–H49 live (5/5).** H40–H44 REFUTED.
No submit. Best live family = **H42 lr5e-6 m=+0.01613** (still <0.04).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$189,313** · cum mining ~$5,050 · **avail ~$179.3k** |
| miner | τ10.000 free · 0 submissions |
| H44 | **REFUTE** m=−0.00017 (clipL1≥0.08 → null); pod rm'd |
| H45 | chall recover p222 (Triton race); merge done |
| H46 | train.done step26 → merge/n80 next |
| H47 | train.done step26 → merge/n80 next |
| H48 | train.done step26 → merge/n80 next |
| H49 | bootstrap (α=4) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h45-1 | lunar-fox-40 | 152.236.142.236:40299 | ~13:13Z | H45 chall recover→n80 |
| mine-h46-1 | cosmic-fox-ea | 38.255.28.19:20100 | ~13:28Z | H46 merge→n80 |
| mine-h47-1 | golden-comet-01 | 38.255.28.21:20099 | ~13:33Z | H47 merge→n80 |
| mine-h48-1 | zesty-raven-35 | 38.255.28.22:20100 | ~13:33Z | H48 merge→n80 |
| mine-h49-1 | zesty-shark-45 | 86.38.238.54:40300 | ~13:59Z | H49 bootstrap α4 |

known_hosts `/tmp/mine-h{45,46,47,48,49}-1.known_hosts`.
**Free slots: 0.** Burn ~$158/h mining.

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H36
α / H30–H35 king-self / **any TP×king-self** / m7×union@H36 /
**H28@lr≥3e-5** / **H28@epochs≥2** / **H28@r≥32** / **H42@lr=5e-6** /
**H43@α≥64** / **H40@ep≥2** / **H44@clipL1≥0.08**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.

## Next action

1. H45: poll recover→promptable→n80 decision.
2. H46/H47/H48: poll merge→chall→n80 (all train.done).
3. H49: poll bootstrap→train.
4. REFUTE → `lium rm mine-hN-1` only; fill gentler H28 variant (not intensity-up / not data≥0.08).
