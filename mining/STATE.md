# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H37–H41 live (5/5).** H34/H35/H36 REFUTED.
No submit. Best live family = H28 winner-zA variants.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium / spend | **~$189,814** · cum mining ~$4,300 · **avail ~$179.8k** |
| miner | τ10.000 free · 0 submissions |
| H37 | n80 a203 @ chall/king **61/80** |
| H38 | n80 a203 @ chall **59**/king **60**/80 |
| H39 | n80 a203 sole sim (bare post_train killed p211) |
| H40 | merge.done; chall loading; post_train disarmed; retry wait |
| H41 | merge shard2; disarm watcher armed for CHALL_SERVE_DONE |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h37-1 | swift-matrix-54 | 152.236.142.232:40311 | ~09:53Z | H37 n80 a203 |
| mine-h38-1 | golden-matrix-b9 | 152.236.142.236:40298 | ~09:52Z | H38 n80 a203 |
| mine-h39-1 | swift-wolf-6e | 86.38.238.54:40301 | ~11:11Z | H39 n80 a203 |
| mine-h40-1 | gentle-eagle-c9 | 150.136.71.147:20300 | ~11:12Z | H40 chall→retry n80 |
| mine-h41-1 | zesty-lion-26 | 38.255.28.19:20099 | ~11:14Z | H41 merge→disarm→n80 |

known_hosts `/tmp/mine-h{37,38,39,40,41}-1.known_hosts`.
**Free slots: 0.** Burn ~$162/h mining.

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H36
α / H30–H35 king-self / **any TP×king-self** / m7×union@H36.
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.
post_train bare n80 races retry — prefer retry; H41 has
`disarm_bare_n80_pass211.sh`.

## Next action

1. H37/H38: poll n80 → decision. Margin >0.04 → Stage 5.
2. H39: poll a203 n80 → decision (sole sim pid keep).
3. H40: wait chall promptable → retry starts hashed n80.
4. H41: wait merge.done → chall → disarm kills post_train →
   retry hashed n80. REFUTE → `lium rm mine-hN-1` only; fill non-α H28.
