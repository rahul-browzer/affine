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
| Lium / spend | **~$189,853** · cum mining ~$4,220 · **avail ~$179.9k** |
| miner | τ10.000 free · 0 submissions |
| H37 | n80 a203 @ chall 36/80 king 37/80 |
| H38 | n80 a203 @ chall 40/80 king 41/80 |
| H39 | train.done; merge writing; t+k :8000/:8001=200 |
| H40 | train ~71/78 (ep3); king :8001=200 |
| H41 | train.done; merge writing; king recover p209 OK; prewarm.done |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h37-1 | swift-matrix-54 | 152.236.142.232:40311 | ~09:53Z | H37 n80 a203 |
| mine-h38-1 | golden-matrix-b9 | 152.236.142.236:40298 | ~09:52Z | H38 n80 a203 |
| mine-h39-1 | swift-wolf-6e | 86.38.238.54:40301 | ~11:11Z | H39 merge→n80 |
| mine-h40-1 | gentle-eagle-c9 | 150.136.71.147:20300 | ~11:12Z | H40 train→n80 |
| mine-h41-1 | zesty-lion-26 | 38.255.28.19:20099 | ~11:14Z | H41 merge→n80 |

known_hosts `/tmp/mine-h{37,38,39,40,41}-1.known_hosts`.
**Free slots: 0.** Burn ~$162/h mining.

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H36
α / H30–H35 king-self / **any TP×king-self** / m7×union@H36.
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
Engine recover: wipe `role_*` caches **before** new TCACHE + ≥20s settle.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.

## Next action

1. H37/H38: poll n80 → decision. Margin >0.04 → Stage 5.
2. H39/H41: wait merge.done → chall serve → n80 (king already up on both).
3. H40: poll train→merge→n80. Same decision; REFUTE → `lium rm mine-hN-1`
   only; fill with non-α H28 neighbour.
4. If H41 chall dies Triton mid-n80 → copy `relaunch_chall_pass207.sh`
   pattern → `relaunch_chall_pass209.sh` (wipe→settle20→unique TCACHE).
