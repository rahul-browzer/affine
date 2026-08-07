# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H32–H36 live (5/5).** H30/H31 **REFUTED** (near-null). No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 (llms/contract; API field null) |
| Lium / spend | **~$190,378** · cum mining ~$3,400 · **avail ~$180.4k** |
| miner | τ10.000 free · 0 submissions |
| H30 | **REFUTE** m=−0.00316 z=−0.37 base×1.165 (rm) |
| H31 | **REFUTE** m=+0.00016 z=0.025 base×1.077 (rm) |
| H32 | n80 ~32/80 |
| H33 | n80 ~27/80 |
| H34 | train ~45/92 (ep≈0.98 of 2); teacher 200 / king loading |
| H35 | bootstrap live (m7×ks lr1e-4) |
| H36 | bootstrap live (m7×union za∪ks) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h32-1 | noble-raven-24 | 150.136.71.147:20300 | ~07:48Z | H32 n80 ~32/80 |
| mine-h33-1 | gentle-comet-aa | 152.236.142.232:40309 | ~08:15Z | H33 n80 ~27/80 |
| mine-h34-1 | calm-wolf-a8 | 38.255.28.19:20100 | ~08:59Z | H34 train ~45/92 |
| mine-h35-1 | calm-fox-12 | 38.255.28.21:20100 | ~09:19Z | H35 bootstrap |
| mine-h36-1 | calm-orbit-65 | 38.255.28.22:20098 | ~09:21Z | H36 bootstrap |

known_hosts `/tmp/mine-h3{2,3,4,5,6}-1.known_hosts`.
**Free slots: 0.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H31
α / H30@1e-5 / H31@3e-5 / TP×king-self@1ep. Never tear down on
ConnectError/unpromptable — quarantine + recover. Health=/v1/models ≠ alive —
require `/v1/completions` before n80.

## Next action

1. H32: poll n80 → decision; m>0.04→Stage 5 else REFUTE+rm.
2. H33: poll n80 → decision (same).
3. H34: poll train → merge → chall probe → n80.
4. H35: poll bootstrap→train→merge→n80.
5. H36: poll bootstrap→train→merge→n80.
6. On any REFUTE: `lium rm` that `mine-*` only; free slot → next non-α
   (m7 axis preferred; avoid requeue of H30/H31 cells).
