# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H30–H34 live (5/5).** H29 **REFUTED** m=−0.01527. No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 (llms/contract; API field null) |
| Lium / spend | **~$190,453** · cum mining ~$3,320 · **avail ~$180.5k** |
| miner | τ10.000 free · 0 submissions |
| H30 | n80 **~46/80** · probes OK |
| H31 | n80 **~36/80** · post-recover193 |
| H32 | n80 **~29/80** |
| H33 | merge **done** · chall :8002 loading → n80 next |
| H34 | bootstrap on mine-h34-1 (m7×ks ep2) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h30-1 | golden-hawk-9f | 38.255.28.22:20100 | ~07:39Z | H30 n80 ~46/80 |
| mine-h31-1 | golden-raven-d8 | 152.236.142.236:40301 | ~07:42Z | H31 n80 ~36/80 |
| mine-h32-1 | noble-raven-24 | 150.136.71.147:20300 | ~07:48Z | H32 n80 ~29/80 |
| mine-h33-1 | gentle-comet-aa | 152.236.142.232:40309 | ~08:15Z | H33 chall loading |
| mine-h34-1 | calm-wolf-a8 | 38.255.28.19:20100 | ~08:59Z | H34 bootstrap |

known_hosts `/tmp/mine-h3{0,1,2,4}-1.known_hosts` + `/tmp/mine-h33-1.known_hosts`.
**Free slots: 0.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21–H29 / α /
TP×king-self@1ep.** Never tear down on ConnectError/unpromptable — quarantine
+ recover. Health=/v1/models ≠ alive — require `/v1/completions` before n80.

## Next action

1. H30: poll n80 → decision; m>0.04→Stage 5 else REFUTE+rm.
2. H31: poll n80 → decision (same).
3. H32: poll n80 → decision (same).
4. H33: wait chall probe → n80 → decision.
5. H34: poll bootstrap → train → merge → n80.
6. On any REFUTE: `lium rm` that `mine-*` only; free slot → next non-α variant
   (prefer m7-init axis; avoid TP×king-self@1ep).
