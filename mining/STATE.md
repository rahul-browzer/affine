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
| min_submission_block | see contract.submission (was 8767079) |
| Lium / spend | **~$190,863** · cum mining ~$2,490 · **avail ~$181k** (floor $10k) |
| miner | τ10.000 free · 0 submissions |
| H27 | n80 ~51/80; form+retry armed |
| H28 | merge+identity OK; chall probe=200; **n80 live** |
| H23 | n80 ~22/80 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h23-1 | gentle-fox-b5 | 204.9.206.244:40300 | ~00:10Z | n80 ~22/80 |
| mine-h27-1 | noble-orbit-fb | 38.255.28.21:20099 | ~05:34Z | H27 n80 ~51/80 |
| mine-h28-1 | swift-hawk-e1 | 152.236.142.232:40311 | ~06:11Z | H28 n80 attempt=1 |

known_hosts `/tmp/mine-h{23,27,28}-1.known_hosts`. **Free slots: 2.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21–H26 / α lottery.**
Never tear down on null-margin + `ConnectError`/`unpromptable`/`EngineDeadError`.
Health=200 ≠ alive — require `/v1/completions` probe; if probe kills engine
(Triton `.so` missing), wipe `king_*` caches + unique TCACHE + relaunch (not wait).
**B300:** FA patch + SERVE_STAGGER_S≥45. recover-wait must exit if king pid dies.
`pgrep -f "watch_n80_retry.sh hN"` false-matches SSH — use awk `/[w]atch…/`.
**recover-wait must not `awk`/`kill` patterns present in its own `bash -c` body**
(pass180: self-SIGKILL after probe=ok).

## Next action

1. H27: poll n80 → decision; m>0.04 → Stage 5; else REFUTE+rm.
2. H28: poll `/root/affine_data/h28_sim_progress.json` + decision; m>0.04 → Stage 5.
3. H23: poll progress + decision; m>0.04 → Stage 5.
4. Free slots (2): only rent for a **new non-α** hyp after H27/H28/H23 signal.
