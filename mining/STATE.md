# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H51/H54–H57 live (5/5).** H53 REFUTED this pass (m=−0.00885).
No submit. Best family still **H42 lr5e-6 m=+0.01613** (<0.04).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$188,700** · cum mining ~$6,300 · **avail ~$178.7k** |
| miner | τ10.000 free · 0 submissions |
| H53 | **REFUTE m=−0.00885** (lr4e-6 dead; Λ2_c<0) |
| H51 | n80 b203 **~30/80** |
| H54 | merge after soft-abort recover |
| H55 | train + post_train relaunch (was soft-abort) |
| H56 | train + post_train relaunch (was soft-abort) |
| H57 | bootstrap→train lr5.25e-6 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h51-1 | brave-lion-47 | 152.236.142.232:40300 | ~15:03Z | H51 n80 b203 |
| mine-h54-1 | calm-matrix-9c | 152.236.142.236:40300 | ~16:23Z | H54 merge→n80 |
| mine-h55-1 | lunar-shark-0b | 38.255.28.19:20100 | ~16:36Z | H55 train lr5.5e-6 |
| mine-h56-1 | swift-fox-1d | 152.236.142.237:40099 | ~16:38Z | H56 train r=24 |
| mine-h57-1 | eager-shark-95 | 38.255.28.18:20100 | ~16:44Z | H57 train lr5.25e-6 |

known_hosts `/tmp/mine-h{51,54,55,56,57}-1.known_hosts`.
**Free slots: 0.** Burn ~$148/h mining.

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H36
α / H30–H35 king-self / **any TP×king-self** / m7×union@H36 /
**H28@lr≥3e-5** / **H28@epochs≥2** / **H28@r≥32** / **H42@lr=5e-6** /
**H43@α≥64** / **H40@ep≥2** / **H44@clipL1≥0.08** / **H47@α≤8** /
**H46@lr≤2.5e-6** / **H48@lr≤1e-6** / **H45@r≤8** / **H49@α=4** /
**H50@lr=7.5e-6** / **H52@lr=6e-6** / **H53@lr=4e-6**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
Cloned post_train SOFT defaults at 04:30Z are poison after that wall-clock —
always export SOFT≥TTL−1h (H54/H55/H56 aborted; recovered this pass).

## Next action

1. Poll H51 (~30/80) → `h51_decision.json`.
2. Confirm H54 merge→chall→n80; H55/H56 train→merge (relaunch watchers if needed).
3. H57 bootstrap→train; verify post_train waiting (SOFT 15:30Z).
4. REFUTE → `lium rm mine-hN-1` only; fill non-α peak neighbour (not dead).
5. lr curve: **5e-6 (+0.016) > 6e-6 (+0.013) > 7.5e-6 (+0.003) > 4e-6 (−0.009)**.
