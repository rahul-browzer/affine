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
| Lium / spend | **~$190,531** · cum mining ~$3,250 · **avail ~$180.5k** |
| miner | τ10.000 free · 0 submissions |
| H29 | n80 **~49/80** · probes OK · watchers up |
| H30 | n80 **~11/80** · probes OK (post-recover192) |
| H31 | recover193 probe **ok** @i=24 → n80 **live** + watchers |
| H32 | recover192 king probe ok → n80 **~15/80** |
| H33 | train **~60/92** loss≈0.413 · t/k up · no merge yet |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h29-1 | golden-wolf-bc | 38.255.28.21:20100 | ~07:28Z | H29 n80 ~49/80 |
| mine-h30-1 | golden-hawk-9f | 38.255.28.22:20100 | ~07:39Z | H30 n80 ~11/80 |
| mine-h31-1 | golden-raven-d8 | 152.236.142.236:40301 | ~07:42Z | H31 n80 live post-recover193 |
| mine-h32-1 | noble-raven-24 | 150.136.71.147:20300 | ~07:48Z | H32 n80 ~15/80 |
| mine-h33-1 | gentle-comet-aa | 152.236.142.232:40309 | ~08:15Z | H33 train ~60/92 |

known_hosts `/tmp/mine-h2{9,0,1,2}-1.known_hosts` + `/tmp/mine-h33-1.known_hosts`.
**Free slots: 0.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21–H28 / α.**
Never tear down on ConnectError/unpromptable — quarantine + recover.
Health=/v1/models ≠ alive — require `/v1/completions` before n80.

## Next action

1. H29: poll n80 → decision; m>0.04→Stage 5 else REFUTE+rm.
2. H30: poll n80 → decision (same).
3. H31: poll n80 → decision (same).
4. H32: poll n80 → decision (same).
5. H33: poll train.done → merge → n80.
6. On any REFUTE: `lium rm` that `mine-*` only; free slot → next non-α variant.
