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
| min_submission_block | 8767079 |
| Lium / spend | **~$191,176** · cum mining ~$2,020 · **avail ~$181k** (floor $10k) |
| miner | τ10.000 free · 0 submissions |
| H25 | **n80 ~30/80** (best clip-L1 α0.90); retry writes decision |
| H24 | chall loading GPU4/5; fix-wait i≈15 c=000 → probe→n80 |
| H23 | merge done; engines loading; **probe-gated start** armed |
| H26 | kkk DL ~55G (10/11) → merge→n80 |
| H27 | train step ~3/51 (~50s/it); post-train armed |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h23-1 | gentle-fox-b5 | 204.9.206.244:40300 | 00:10Z | H23 wait→probe→n80 |
| mine-h24-1 | brave-orbit-31 | 152.236.142.234:40311 | 00:17Z | H24 chall load→probe→n80 |
| mine-h25-1 | golden-shark-c8 | 152.236.142.232:40305 | 00:08Z | H25 n80 ~30/80 |
| mine-h26-1 | swift-matrix-98 | 38.255.28.22:20100 | 01:21Z | H26 kkk DL→merge |
| mine-h27-1 | noble-orbit-fb | 38.255.28.21:20099 | 05:34Z | H27 LoRA train |

known_hosts `/tmp/mine-h{23,24,25,26,27}-1.known_hosts`. **0 free slots.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21 / H22 / α lottery.**
Never tear down on null-margin + `ConnectError`/`unpromptable` — false probe.
Never `pkill -f` a pattern that appears in the SSH remote cmdline.
H24/H23: health=200 ≠ alive — require `/v1/completions` probe before n80.

## Next action

1. Poll H25 `h25_decision.json` / progress→80; genuine REFUTE → `lium rm` h25.
2. H24: `tail /root/logs/h24_fix_recover.nohup` — probe=ok then n80; if 120 fails, kill GPU4/5 + relaunch.
3. H23: `tail /root/logs/h23_n80_probe_gated.nohup` — wait ALL_READY + probe=ok → n80.
4. H26 kkk.done → merge→n80. H27: scrape `trainer_state.json` (not tqdm).
