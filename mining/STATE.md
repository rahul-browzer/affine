# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H54–H58 live (5/5).** No submit.
Best family still **H42 lr5e-6 m=+0.01613** (<0.04).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$188,573** · cum mining ~$6,530 · **avail ~$178.6k** |
| miner | τ10.000 free · 0 submissions |
| H51 | **REFUTE** m=+0.00855 · pod rm'd |
| H54 | merge OK; chall prefreeze a2 loading (`relaunch_chall_pass246`) |
| H55 | merge done → chall re-serve |
| H56 | merge done → chall re-serve |
| H57 | merge writing shards |
| H58 | bootstrap live (lr5.1e-6) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h54-1 | calm-matrix-9c | 152.236.142.236:40300 | ~16:23Z | H54 chall recover→n80 |
| mine-h55-1 | lunar-shark-0b | 38.255.28.19:20100 | ~16:36Z | H55 chall serve→n80 |
| mine-h56-1 | swift-fox-1d | 152.236.142.237:40099 | ~16:38Z | H56 chall serve→n80 |
| mine-h57-1 | eager-shark-95 | 38.255.28.18:20100 | ~16:44Z | H57 merge→n80 |
| mine-h58-1 | eager-matrix-0d | 38.255.28.21:20099 | ~17:22Z | H58 bootstrap→train |

known_hosts `/tmp/mine-h{54,55,56,57,58}-1.known_hosts`.
**Free slots: 0.** Burn ~$152/h mining.

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H36
α / H30–H35 king-self / **any TP×king-self** / m7×union@H36 /
**H28@lr≥3e-5** / **H28@epochs≥2** / **H28@r≥32** / **H42@lr=5e-6** /
**H43@α≥64** / **H40@ep≥2** / **H44@clipL1≥0.08** / **H47@α≤8** /
**H46@lr≤2.5e-6** / **H48@lr≤1e-6** / **H45@r≤8** / **H49@α=4** /
**H50@lr=7.5e-6** / **H52@lr=6e-6** / **H53@lr=4e-6** / **H51@α=16**.
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
King-seed+prefreeze can still ENOENT on w1 (H54 a1) — keep outer×3.

## Next action

1. H54: wait `h54_chall_freeze_pass246.done` → n80; if a2/a3 fail, re-run
   prefreeze (do not `lium rm`).
2. H55/H56: if chall dies on `__triton_launcher.so`, same prefreeze recipe
   (`relaunch_chall_pass246.sh` adapted).
3. H57: merge.done → chall → n80; H58: train→merge→n80.
4. REFUTE → `lium rm mine-hN-1` only; fill non-α lr-ridge neighbour (not α).
5. lr curve: **5e-6 (+0.016) > 6e-6 (+0.013) > 7.5e-6 (+0.003) > 4e-6 (−0.009)**;
   open **5.1 / 5.25 / 5.5 / 8**.
