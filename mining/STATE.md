# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H28 recovering + H29 launched (2/5).**
H1–H27/H5c/H6/H20–H26 **REFUTED**. No submit. Clip-L1 rank: `s2-clip-l1-rank`.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | **~$190,785** · cum mining ~$2,810 · **avail ~$181k** (floor $10k) |
| miner | τ10.000 free · 0 submissions |
| H28 | king recover mid-warmup (pass183); probe→n80 when ready |
| H29 | **LAUNCHED** king-self 686ex · bootstrap pip→train |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h28-1 | swift-hawk-e1 | 152.236.142.232:40311 | ~06:11Z | H28 m7-init → king recover→n80 |
| mine-h29-1 | golden-wolf-bc | 38.255.28.21:20100 | ~07:28Z | H29 king-self LoRA bootstrap |

known_hosts `/tmp/mine-h28-1.known_hosts`, `/tmp/mine-h29-1.known_hosts`. **Free slots: 3.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21–H27 / α lottery.**
H27 winner-zA@TP-init dead. Never tear down on ConnectError/unpromptable.
Health=200 ≠ alive — require `/v1/completions` probe.
`pgrep -f` false-matches SSH — use awk `/[w]atch…/`.
recover-wait must be a **separate .sh** (not `bash -c` embedding start path).

## Next action

1. H28: poll recover → king probe=ok → n80 → decision; m>0.04 → Stage 5; else REFUTE+rm.
2. H29: poll bootstrap → train.done → merge → n80; m>0.04 → Stage 5; else REFUTE+rm.
3. Free slots (3): next non-α only after H28/H29 signal (alt init e.g. kevin+king-self, or stricter filter) — not α.
