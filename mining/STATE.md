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
| Lium / spend | **~$191,155** · cum mining ~$2,060 · **avail ~$181k** (floor $10k) |
| miner | τ10.000 free · 0 submissions |
| H25 | **n80 ~42/80** (best clip-L1 α0.90) |
| H24 | **n80 live ~2/80** (probe=ok 17:44Z) |
| H23 | B300 sm_103 FA patched; engines reloading → wait→probe→n80 |
| H26 | kkk.done; **merge ~4/16** → serve→n80 |
| H27 | train step ~10/51 loss≈0.65; post-train armed |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h23-1 | gentle-fox-b5 | 204.9.206.244:40300 | 00:10Z | H23 engines reload→probe→n80 |
| mine-h24-1 | brave-orbit-31 | 152.236.142.234:40311 | 00:17Z | H24 n80 live |
| mine-h25-1 | golden-shark-c8 | 152.236.142.232:40305 | 00:08Z | H25 n80 ~42/80 |
| mine-h26-1 | swift-matrix-98 | 38.255.28.22:20100 | 01:21Z | H26 merge→serve→n80 |
| mine-h27-1 | noble-orbit-fb | 38.255.28.21:20099 | 05:34Z | H27 LoRA train |

known_hosts `/tmp/mine-h{23,24,25,26,27}-1.known_hosts`. **0 free slots.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21 / H22 / α lottery.**
Never tear down on null-margin + `ConnectError`/`unpromptable` — false probe.
Never `pkill -f` a pattern that appears in the SSH remote cmdline.
H24/H23: health=200 ≠ alive — require `/v1/completions` probe before n80.
**B300:** after venv install run `s3-duel-sim/patch_b300_sm103_flash_attn.sh` or engines die at profile_run.

## Next action

1. Poll H25 `h25_decision.json` / progress→80; genuine REFUTE → `lium rm` h25.
2. Poll H24 progress/decision; same teardown rule.
3. H23: confirm t/k/c health=200 + probe=ok → n80 (patch already applied).
4. H26 merge.done → serve→n80. H27: scrape `trainer_state.json` (not tqdm).
