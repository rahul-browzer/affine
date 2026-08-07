# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H29–H33 live (5/5).** H28 **REFUTED** m=+0.01095. No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 (llms/contract; API field null) |
| Lium / spend | **~$190,569** · cum mining ~$3,200 · **avail ~$180.5k** |
| miner | τ10.000 free · 0 submissions |
| H29 | n80 **~36/80** · probes OK · watchers up |
| H30 | recover192 probe **ok** → n80 **live** (just started) |
| H31 | false REFUTE ConnectError quarantined (pass193); chall recover193 loading |
| H32 | king recover192 still loading (health 000 @ i≥10) |
| H33 | train running (checkpoints dir; no trainer_state yet) · t/k up |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h29-1 | golden-wolf-bc | 38.255.28.21:20100 | ~07:28Z | H29 n80 ~36/80 |
| mine-h30-1 | golden-hawk-9f | 38.255.28.22:20100 | ~07:39Z | H30 n80 live post-recover192 |
| mine-h31-1 | golden-raven-d8 | 152.236.142.236:40301 | ~07:42Z | H31 chall recover193→n80 |
| mine-h32-1 | noble-raven-24 | 150.136.71.147:20300 | ~07:48Z | H32 king recover192 |
| mine-h33-1 | gentle-comet-aa | 152.236.142.232:40309 | ~08:15Z | H33 train ep2 |

known_hosts `/tmp/mine-h2{9,0,1,2}-1.known_hosts` + `/tmp/mine-h33-1.known_hosts`.
**Free slots: 0.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21–H28 / α.**
Never tear down on ConnectError/unpromptable — quarantine + recover.
Health=/v1/models ≠ alive — require `/v1/completions` before n80.
H31 pass193: same Triton chall death as H30; scripts on pod.

## Next action

1. H31: poll recover193 chall probe → n80; if probe kills engine, re-wipe+relaunch.
2. H29: poll n80 → decision; m>0.04→Stage 5 else REFUTE+rm.
3. H30: poll n80 → decision (same).
4. H32: poll recover192 king probe → pipeline/retry n80.
5. H33: poll train.done → merge → n80.
6. On any REFUTE: `lium rm` that `mine-*` only; free slot → next non-α variant.
