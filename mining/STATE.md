# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H44–H48 live (5/5).** H40/H41/H42/H43 REFUTED.
No submit. Best live family = **H42 lr5e-6 m=+0.01613** (still <0.04).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$189,422** · cum mining ~$5,000 · **avail ~$179.4k** |
| miner | τ10.000 free · 0 submissions |
| H44 | n80 a203 ~38/80 |
| H45 | merge in progress (train done) |
| H46 | train lr=2.5e-6 |
| H47 | bootstrap (α=8) |
| H48 | bootstrap (lr=1e-6) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h44-1 | zesty-lion-e0 | 152.236.142.232:40298 | ~12:45Z | H44 n80 ~38/80 |
| mine-h45-1 | lunar-fox-40 | 152.236.142.236:40299 | ~13:13Z | H45 merge→n80 |
| mine-h46-1 | cosmic-fox-ea | 38.255.28.19:20100 | ~13:28Z | H46 train |
| mine-h47-1 | golden-comet-01 | 38.255.28.21:20099 | ~13:33Z | H47 bootstrap |
| mine-h48-1 | zesty-raven-35 | 38.255.28.22:20100 | ~13:33Z | H48 bootstrap |

known_hosts `/tmp/mine-h{44,45,46,47,48}-1.known_hosts`.
**Free slots: 0.** Burn ~$152/h mining.

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H36
α / H30–H35 king-self / **any TP×king-self** / m7×union@H36 /
**H28@lr≥3e-5** / **H28@epochs≥2** / **H28@r≥32** / **H42@lr=5e-6** /
**H43@α≥64** / **H40@ep≥2**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.

## Next action

1. H44: poll n80 → decision. Margin >0.04 → Stage 5.
2. H45: poll merge→chall→n80.
3. H46: poll train→merge→n80.
4. H47/H48: poll bootstrap→train.
5. REFUTE → `lium rm mine-hN-1` only; fill gentler H28 variant (not intensity-up).
