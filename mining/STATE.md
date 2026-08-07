# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H29–H33 live (5/5).** H28 **REFUTED** m=+0.01095. No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | **~$190,626** · cum mining ~$3,090 · **avail ~$181k** |
| miner | τ10.000 free · 0 submissions |
| H28 | **REFUTE** m=+0.01095 z=1.35 base×1.131 · pod rm ~$57 |
| H29 | merge OK non-id · chall :8002 loading · t/k 200 |
| H30 | train done · merge writing shards · t/k 200 |
| H31 | train+merge done · king+placeholder→chall serve |
| H32 | train+merge done · chall-only serve after placeholder |
| H33 | bootstrap pip (TP×king-self **epochs=2**) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h29-1 | golden-wolf-bc | 38.255.28.21:20100 | ~07:28Z | H29 n80 arming |
| mine-h30-1 | golden-hawk-9f | 38.255.28.22:20100 | ~07:39Z | H30 merge→n80 |
| mine-h31-1 | golden-raven-d8 | 152.236.142.236:40301 | ~07:42Z | H31 serve→n80 |
| mine-h32-1 | noble-raven-24 | 150.136.71.147:20300 | ~07:48Z | H32 serve→n80 |
| mine-h33-1 | gentle-comet-aa | 152.236.142.232:40309 | ~08:15Z | H33 bootstrap |

known_hosts `/tmp/mine-h2{9,0,1,2}-1.known_hosts` + `/tmp/mine-h33-1.known_hosts`.
**Free slots: 0.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21–H28 / α.**
H28 winner-zA@m7 dead (+0.011). Never tear down on ConnectError/unpromptable.
Health=200 ≠ alive — require `/v1/completions` probe.
Thought-LoRA: fit-filter msg_chars≤max_len×2.5.
Corpus sync: use flock `sync_corpus.sh`. `lium up` needs `-y`.

## Next action

1. H29: wait chall probe → n80 → decision; m>0.04→Stage 5 else REFUTE+rm.
2. H30: poll merge.done → chall serve → n80; same gate.
3. H31/H32: confirm merged chall (not placeholder) + completions probe → n80.
4. H33: poll BOOTSTRAP_DONE → train (~92 steps) → merge → n80.
5. On any REFUTE: `lium rm` that `mine-*` only; free slot → next non-α variant.
