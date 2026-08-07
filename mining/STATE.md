# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H23–H27 live (5/5). H21/H22 REFUTED.**
H1–H22/H5c/H6/H20 **REFUTED**. No submit. Clip-L1 rank: `s2-clip-l1-rank`.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | check contract before submit |
| Lium / spend | **~$191,198** · cum mining ~$1,930 · **avail ~$181k** (floor $10k) |
| miner | τ10.000 free · 0 submissions |
| H25 | **n80 18/80** (best clip-L1 α0.90) |
| H24 | **n80 LIVE** (t/k/c=200 after chall recover) |
| H23 | merge writing shard 15/16 → serve→n80 |
| H26 | kkk DL ~44G / talentpigs.done |
| H27 | **NEW** clip-L1 shape: winner-zA harvest 406 → train bootstrapping |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h23-1 | gentle-fox-b5 | 204.9.206.244:40300 | 00:10Z | H23 merge→serve→n80 |
| mine-h24-1 | brave-orbit-31 | 152.236.142.234:40311 | 00:17Z | H24 n80 live |
| mine-h25-1 | golden-shark-c8 | 152.236.142.232:40305 | 00:08Z | H25 n80 ~18/80 |
| mine-h26-1 | swift-matrix-98 | 38.255.28.22:20100 | 01:21Z | H26 kkk DL→merge |
| mine-h27-1 | noble-orbit-fb | 38.255.28.21:20099 | 05:34Z | H27 train→merge→n80 |

known_hosts `/tmp/mine-h{23,24,25,26,27}-1.known_hosts`. **0 free slots.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21 / H22 / α lottery.**
Never tear down on null-margin + `ConnectError`/`unpromptable` — false probe.
Never `pkill -f` a pattern that appears in the SSH remote cmdline.

## Next action

1. Poll H24/H25 `*_decision.json` first (both n80). Genuine REFUTE → `lium rm` that pod.
2. H23 merge.done → engines→n80. H26 kkk.done → merge→n80.
3. H27: confirm train launched (`h27_train_launched.json` / trainer_state); post-train armed.
4. On any free slot after REFUTE: deepen H27-style (more high-L1 z_A) — not α0.90.
