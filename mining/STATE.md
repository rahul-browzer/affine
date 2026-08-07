# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H23/H24/H25/H26 live (4/5). H21/H22 REFUTED.**
H1–H22/H5c/H6/H20 **REFUTED**. No submit. Clip-L1 rank: `s2-clip-l1-rank`.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | check contract before submit |
| Lium / spend | **~$191,235** · cum mining ~$1,890 · **avail ~$181k** (floor $10k) |
| miner | τ10.000 free · 0 submissions |
| H21 | **REFUTE** m=−0.00682 z=−0.70 base×1.001 (pod rm) |
| H22 | **REFUTE** m=−0.01179 z=−1.58 base×1.045 (pod rm) |
| H25 | **n80 LIVE** t/k/c=200 after king Triton recover |
| H24 | chall Triton-died → relaunched unique cache; wait→n80 |
| H23 | merge ~14/16 → serve→n80 |
| H26 | bootstrap DL kkk after talentpigs.done |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h23-1 | gentle-fox-b5 | 204.9.206.244:40300 | 00:10Z | H23 merge→serve→n80 |
| mine-h24-1 | brave-orbit-31 | 152.236.142.234:40311 | 00:17Z | H24 chall load→n80 |
| mine-h25-1 | golden-shark-c8 | 152.236.142.232:40305 | 00:08Z | H25 n80 live |
| mine-h26-1 | swift-matrix-98 | 38.255.28.22:20100 | 01:21Z | H26 bootstrap DL |

known_hosts `/tmp/mine-h{23,24,25,26}-1.known_hosts`. **1 free slot.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21 / H22.**
Never tear down on null-margin + `ConnectError`/`unpromptable` — false probe.
Never `pkill -f` a pattern that appears in the SSH remote cmdline.

## Next action

1. Poll H25 `h25_decision.json` / progress (best clip-L1). Genuine REFUTE → rm.
2. Poll H24: chall health→n80; if Triton `__triton_launcher` again, kill GPU4/5
   compute PIDs by index (not `pkill -f`), unique `TRITON_CACHE_DIR`, relaunch.
3. H23 merge.done → engines → n80. H26 bootstrap → n80.
4. Free slot: **clip-L1-shaping** recipe (not another mid-pack α0.90).
