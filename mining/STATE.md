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
| Lium / spend | **~$188,425** · cum mining ~$6,690 · **avail ~$178.4k** |
| miner | τ10.000 free · 0 submissions |
| H54 | n80 b203 @ **42**/80 |
| H55 | n80 b203 @ **52**/80 |
| H56 | FALSE_PROBE (OV4T43 ENOENT) → **p253 recover** diverse-freeze |
| H57 | n80 a203 @ **37**/80 |
| H58 | n80 died same hash (default chall cache) → **p253 recover** |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h54-1 | calm-matrix-9c | 152.236.142.236:40300 | ~16:23Z | n80 b203 @42/80 |
| mine-h55-1 | lunar-shark-0b | 38.255.28.19:20100 | ~16:36Z | n80 b203 @52/80 |
| mine-h56-1 | swift-fox-1d | 152.236.142.237:40099 | ~16:38Z | p253 chall recover |
| mine-h57-1 | eager-shark-95 | 38.255.28.18:20100 | ~16:44Z | n80 a203 @37/80 |
| mine-h58-1 | eager-matrix-0d | 38.255.28.21:20099 | ~17:22Z | p253 chall recover |

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
**King-seed+prefreeze-before-w1 DEAD; short-only post-w1 freeze ≠ n80-safe**
(OV4T43 ENOENT). **p253 = diverse writable warmups → freeze.**
Reap orphans via **ppid=1 VLLM::Worker**, not only nvidia-smi PIDs.

## Next action

1. H56/H58: wait `h*_chall_freeze_pass253.done` + n80 start; if ABORT×3
   log tails — do not `lium rm`.
2. H54/H55/H57: wait n80 → decision.json; REFUTE/teardown if m≤0.04.
3. Next free slot → **lr=5.75e-6** (5.0 off-limits).
