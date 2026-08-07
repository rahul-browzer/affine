# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H23/H27/H28 live (3/5). H26 REFUTED.**
H1–H22/H5c/H6/H20/H24–H26 **REFUTED**. No submit. Clip-L1 rank: `s2-clip-l1-rank`.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | **~$190,928** · cum mining ~$2,415 · **avail ~$181k** (floor $10k) |
| miner | τ10.000 free · 0 submissions |
| H26 | **REFUTE** m=+0.00592 z=0.92 base×1.094; pod rm'd (~$44) |
| H23 | king Triton `.so` death@graph → **recover178** launched 18:44Z |
| H27 | merge OK non-id; chall probe+n80 live ~3/80; form watcher relaunched |
| H28 | TRAIN ~step43/51 loss≈0.36–0.41 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h23-1 | gentle-fox-b5 | 204.9.206.244:40300 | ~00:10Z | king recover178→n80 |
| mine-h27-1 | noble-orbit-fb | 38.255.28.21:20099 | ~05:34Z | H27 n80 ~3/80 |
| mine-h28-1 | swift-hawk-e1 | 152.236.142.232:40311 | ~06:11Z | H28 LoRA ~43/51 |

known_hosts `/tmp/mine-h{23,27,28}-1.known_hosts`. **Free slots: 2.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21–H26 / α lottery.**
Never tear down on null-margin + `ConnectError`/`unpromptable`/`EngineDeadError`.
Health=200 ≠ alive — require `/v1/completions` probe; if probe kills engine
(Triton `.so` missing), wipe `king_*` caches + unique TCACHE + relaunch (not wait).
**B300:** FA patch + SERVE_STAGGER_S≥45. recover-wait must exit if king pid dies.

## Next action

1. H27: poll n80 → decision; m>0.04 → Stage 5 prep; else REFUTE+rm.
2. H23: `tail /root/logs/h23_king_recover_pass178.log` for probe=ok + n80.
3. H28: poll `train.done` / merge→chall→n80 (keep ≥1 free slot).
4. Free slots (2): only rent for a **new non-α** hyp after H27/H28 signal.
