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
| Lium / spend | **~$191,113** · cum mining ~$2,150 · **avail ~$181k** (floor $10k) |
| miner | τ10.000 free · 0 submissions |
| H25 | **n80 ~64/80** · form+retry armed; no decision yet |
| H24 | **n80 ~27/80** · engines healthy |
| H23 | engines loading (t~83% k~75% c~25%); **wait reset** (pass172) |
| H26 | merge DONE · serve loading · wait_ready ~3min |
| H27 | LoRA **step 25/51** loss≈0.49; t/k prewarm held on GPU0–3 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h23-1 | gentle-fox-b5 | 204.9.206.244:40300 | 00:10Z | H23 load→probe→n80 (fresh wait) |
| mine-h24-1 | brave-orbit-31 | 152.236.142.234:40311 | 00:17Z | H24 n80 ~27/80 |
| mine-h25-1 | golden-shark-c8 | 152.236.142.232:40305 | 00:08Z | H25 n80 ~64/80 |
| mine-h26-1 | swift-matrix-98 | 38.255.28.22:20100 | 01:21Z | H26 wait_ready→n80 |
| mine-h27-1 | noble-orbit-fb | 38.255.28.21:20099 | 05:34Z | H27 LoRA ~25/51 |

known_hosts `/tmp/mine-h{23,24,25,26,27}-1.known_hosts`. **0 free slots.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21 / H22 / α lottery.**
Never tear down on null-margin + `ConnectError`/`unpromptable` — false probe.
Never `pkill -f` a pattern that appears in the SSH remote cmdline.
H24/H23: health=200 ≠ alive — require `/v1/completions` probe before n80.
**B300:** FA patch applied; flashinfer JIT → relaunch stagger≥45s.
**H23:** pass171 wait burned ~18m on dead engines; pass172 killed orphan wait + relaunched `start_h23_n80.sh` (TIMEOUT_S=2400 fresh).

## Next action

1. Poll H25 `h25_decision.json` (near done); genuine REFUTE → `lium rm` h25.
2. H23: confirm t/k/c health=200 + probe=ok → n80; if wait TIMEOUT, read logs then relaunch start only (engines may already be up).
3. H26: wait_ready→probe→n80. H24 progress/decision.
4. H27: scrape train step; after `train.done` merge→yield chall→n80 (do not kill prewarm t/k on 0–3).
