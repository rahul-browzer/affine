# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H28 recovering (1/5). H23/H27 REFUTED this pass.**
H1–H27/H5c/H6/H20–H26 **REFUTED**. No submit. Clip-L1 rank: `s2-clip-l1-rank`.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | see contract.submission |
| Lium / spend | **~$190,793** · cum mining ~$2,770 · **avail ~$181k** (floor $10k) |
| miner | τ10.000 free · 0 submissions |
| H27 | **REFUTE** m=−0.00792 z=−1.34 (gates OK) · pod rm ~$58 |
| H23 | **REFUTE** m=−0.00777 z=−1.08 (gates OK) · pod rm ~$204 |
| H28 | king died mid-n80; relaunch+probe+retry armed (pass183) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h28-1 | swift-hawk-e1 | 152.236.142.232:40311 | ~06:11Z | king recover→n80 |

known_hosts `/tmp/mine-h28-1.known_hosts`. **Free slots: 4.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21–H27 / α lottery.**
H27 winner-zA@TP-init dead. Never tear down on ConnectError/unpromptable.
Health=200 ≠ alive — require `/v1/completions` probe.
`pgrep -f` false-matches SSH — use awk `/[w]atch…/`.
recover-wait must be a **separate .sh** (not `bash -c` embedding start path).

## Next action

1. H28: poll recover log → king probe=ok → n80 progress → decision; m>0.04 → Stage 5; else REFUTE+rm.
2. Free slots (4): rent **new non-α** hyps (H27/H23 signal = both REFUTE). Candidates: alt init / alt data filter / king-self high-clipL1 z_A — not another α merge.
