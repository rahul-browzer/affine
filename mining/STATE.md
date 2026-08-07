# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H34–H38 live (5/5).** H32/H33 **REFUTED**. No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | **~$190,259** · cum mining ~$3,620 · **avail ~$180.3k** |
| miner | τ10.000 free · 0 submissions |
| H32 | **REFUTE** m=−0.00601 (a198); rm ~$80 |
| H33 | **REFUTE** m=−0.00158; rm ~$42 |
| H34 | train.done → **merge** writing shards |
| H35 | train.done → **merge** |
| H36 | train.done → **merge** |
| H37 | bootstrap (m7×winner-zA lr1e-4) |
| H38 | bootstrap (m7×winner-zA ep2) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h34-1 | calm-wolf-a8 | 38.255.28.19:20100 | ~08:59Z | H34 merge |
| mine-h35-1 | calm-fox-12 | 38.255.28.21:20100 | ~09:19Z | H35 merge |
| mine-h36-1 | calm-orbit-65 | 38.255.28.22:20098 | ~09:21Z | H36 merge |
| mine-h37-1 | swift-matrix-54 | 152.236.142.232:40311 | ~09:53Z | H37 bootstrap |
| mine-h38-1 | golden-matrix-b9 | 152.236.142.236:40298 | ~09:52Z | H38 bootstrap |

known_hosts `/tmp/mine-h3{4,5,6,7,8}-1.known_hosts`.
**Free slots: 0.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H33
α / H30@1e-5 / H31@3e-5 / **any TP×king-self** (H29/H32/H33 dead).
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20 (H37@$11.6 was 4 GPU).

## Next action

1. H34/H35/H36: poll merge → chall probe → n80 → decision.
2. H37/H38: poll train → merge → n80.
3. On any REFUTE: `lium rm` that `mine-*` only; free slot → next non-α
   m7×winner-zA / m7×union neighbour (avoid TP×ks / α / H30–H31 cells).
