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
| Lium / spend | **~$188,463** · cum mining ~$6,640 · **avail ~$178.5k** |
| miner | τ10.000 free · 0 submissions |
| H54 | n80 b203 @ **22**/80 |
| H55 | n80 b203 @ **30**/80 |
| H56 | p247 ABORT×3 → **p251 writable-w1 recover** running |
| H57 | n80 a203 @ **15**/80 |
| H58 | merge_lora writing shards (1+ so far) → chall next |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h54-1 | calm-matrix-9c | 152.236.142.236:40300 | ~16:23Z | n80 b203 @22/80 |
| mine-h55-1 | lunar-shark-0b | 38.255.28.19:20100 | ~16:36Z | n80 b203 @30/80 |
| mine-h56-1 | swift-fox-1d | 152.236.142.237:40099 | ~16:38Z | p251 chall recover |
| mine-h57-1 | eager-shark-95 | 38.255.28.18:20100 | ~16:44Z | n80 a203 @15/80 |
| mine-h58-1 | eager-matrix-0d | 38.255.28.21:20099 | ~17:22Z | merge→chall→n80 |

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
**King-seed+prefreeze-before-w1 DEAD for chall** (H56 p247) — use p251
writable-w1 then freeze. King mid-n80 → chall-seed+prefreeze (H57 p249).
Reap orphans via **ppid=1 VLLM::Worker**, not only nvidia-smi PIDs.

## Next action

1. H56: wait `h56_chall_freeze_pass251.done` → n80; if ABORT again try empty
   TCACHE writable (no king seed) or chall-profile seed from another pod.
2. H55/H54/H57: wait n80 → decision.json; REFUTE/teardown if m≤0.04.
3. H58: wait merge.done → chall serve → n80 (retry already armed).
4. Next free slot → **lr=5.75e-6** (5.0 off-limits).
