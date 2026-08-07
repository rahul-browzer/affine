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
| Lium / spend | **~$191,134** · cum mining ~$2,100 · **avail ~$181k** (floor $10k) |
| miner | τ10.000 free · 0 submissions |
| H25 | **n80 ~61/80** · form+retry watchers re-armed (pass171) |
| H24 | **n80 ~18/80** · form+retry watchers re-armed (pass171) |
| H23 | engines dead→**relaunching** (SERVE_STAGGER=45); start_h23 waiting |
| H26 | merge **~15/16** → serve→n80 |
| H27 | LoRA train live (GPU6 util~50%); no trainer_state yet |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h23-1 | gentle-fox-b5 | 204.9.206.244:40300 | 00:10Z | H23 serve relaunch→probe→n80 |
| mine-h24-1 | brave-orbit-31 | 152.236.142.234:40311 | 00:17Z | H24 n80 ~18/80 |
| mine-h25-1 | golden-shark-c8 | 152.236.142.232:40305 | 00:08Z | H25 n80 ~61/80 |
| mine-h26-1 | swift-matrix-98 | 38.255.28.22:20100 | 01:21Z | H26 merge→serve→n80 |
| mine-h27-1 | noble-orbit-fb | 38.255.28.21:20099 | 05:34Z | H27 LoRA train |

known_hosts `/tmp/mine-h{23,24,25,26,27}-1.known_hosts`. **0 free slots.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21 / H22 / α lottery.**
Never tear down on null-margin + `ConnectError`/`unpromptable` — false probe.
Never `pkill -f` a pattern that appears in the SSH remote cmdline.
H24/H23: health=200 ≠ alive — require `/v1/completions` probe before n80.
**B300:** FA patch already applied; flashinfer JIT can still kill engines — relaunch with stagger≥45s.

## Next action

1. Poll H25 `h25_decision.json` (watchers armed); genuine REFUTE → `lium rm` h25.
2. Poll H24 progress/decision; same teardown rule.
3. H23: confirm t/k/c health=200 + probe=ok → n80 starts; if engines die again, read `vllm_*.log` root cause (not FA — already patched).
4. H26 merge.done → serve→n80. H27: scrape `trainer_state.json`.
