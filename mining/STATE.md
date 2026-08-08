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
| Lium / spend | **~$189,257** · cum mining ~$5,160 · **avail ~$179.3k** |
| miner | τ10.000 free · 0 submissions |
| H45 | **n80 running** chall 18/80 king 19/80 (a203) |
| H46 | **n80 running** (DONE_LAUNCH 02:16Z; progress early) |
| H47 | **n80 running** chall 10/80 king 10/80; TCACHE frozen |
| H48 | chall died → **recover p225** (wipe/settle @ 02:17Z) |
| H49 | **training** (GPUs 6–7; no trainer_state yet) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h45-1 | lunar-fox-40 | 152.236.142.236:40299 | ~13:13Z | H45 n80 a203 |
| mine-h46-1 | cosmic-fox-ea | 38.255.28.19:20100 | ~13:28Z | H46 n80 a203 |
| mine-h47-1 | golden-comet-01 | 38.255.28.21:20099 | ~13:33Z | H47 n80 a203 |
| mine-h48-1 | zesty-raven-35 | 38.255.28.22:20100 | ~13:33Z | H48 recover→n80 |
| mine-h49-1 | zesty-shark-45 | 86.38.238.54:40300 | ~13:59Z | H49 train α4 |

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

1. H48: poll `/root/logs/h48_chall_recover_pass225.log` → DONE_LAUNCH → n80.
2. H45/H46/H47: poll n80 → `hN_decision.json` (progress `hN_sim_progress.json`).
3. H49: poll train.done → merge → chall freeze → n80.
4. REFUTE → `lium rm mine-hN-1` only; fill gentler H28 variant.
