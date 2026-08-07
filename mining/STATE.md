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
| Lium / spend | **~$191,253** · cum mining ~$1,870 · **avail ~$181k** (floor $10k) |
| miner | τ10.000 free · 0 submissions |
| H21 | **REFUTE** m=−0.00682 z=−0.70 base×1.001 (pod rm) |
| H22 | **REFUTE** m=−0.01179 z=−1.58 base×1.045 (pod rm) |
| H25 | n80 restart after king Triton crash; auto-recover running |
| H24 | false-probe ConnectError quarantined; chall relaunch+n80 recover |
| H23 | merge shards ~15/16 → serve→n80 |
| H26 | bootstrap just launched (kkk α0.90 lottery) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h23-1 | gentle-fox-b5 | 204.9.206.244:40300 | 00:10Z | H23 merge→serve→n80 |
| mine-h24-1 | brave-orbit-31 | 152.236.142.234:40311 | 00:17Z | H24 chall recover→n80 |
| mine-h25-1 | golden-shark-c8 | 152.236.142.232:40305 | 00:08Z | H25 king recover→n80 |
| mine-h26-1 | swift-matrix-98 | 38.255.28.22:20100 | 01:21Z | H26 bootstrap |

known_hosts `/tmp/mine-h{23,24,25,26}-1.known_hosts`. **1 free slot.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21 / H22.**
Never tear down on null-margin + `ConnectError`/`unpromptable` — false probe.

## Next action

1. Poll H25 `h25_decision.json` (best clip-L1 parent). Confirm engines t/k/c=200
   and progress advancing; if king dies again, wipe unique `TRITON_CACHE_DIR`,
   `kill -9` GPU2/3 orphans, relaunch king, then `kick_h25_n80.sh`.
2. Poll H24 recover (`h24_recover_and_n80.nohup`) — false probe was not REFUTE.
3. H23 merge.done → engines → n80. H26 bootstrap → n80.
4. Genuine REFUTE → `lium rm` that `mine-h*-1` only. Free slot: **clip-L1-shaping**
   recipe (not another mid-pack α0.90). Never relaunch plmk/H21/H22.
