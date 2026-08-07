# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H34–H38 live (5/5).** H32/H33 **REFUTED**. No submit.
H37/H38 Triton `__triton_launcher.so` deaths → false_probe **quarantined**;
chall **p205** loading (settle20s + double-completions gate).

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 (verify on submit) |
| Lium / spend | **~$190,022** · cum mining ~$3,875 · **avail ~$180.0k** |
| miner | τ10.000 free · 0 submissions |
| H34 | n80 **a203** ~56/80 (engines 200) |
| H35 | n80 **a203** ~50/80 (engines 200) |
| H36 | n80 **a203** ~51/80 (engines 200) |
| H37 | chall **p205** loading; wait+double-probe; watcher armed |
| H38 | false_probe Q'd; chall **p205** loading; watcher armed |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h34-1 | calm-wolf-a8 | 38.255.28.19:20100 | ~08:59Z | H34 n80 a203 |
| mine-h35-1 | calm-fox-12 | 38.255.28.21:20100 | ~09:19Z | H35 n80 a203 |
| mine-h36-1 | calm-orbit-65 | 38.255.28.22:20098 | ~09:21Z | H36 n80 a203 |
| mine-h37-1 | swift-matrix-54 | 152.236.142.232:40311 | ~09:53Z | H37 chall p205→n80 |
| mine-h38-1 | golden-matrix-b9 | 152.236.142.236:40298 | ~09:52Z | H38 chall p205→n80 |

known_hosts `/tmp/mine-h3{4,5,6,7,8}-1.known_hosts`.
**Free slots: 0.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H33
α / H30@1e-5 / H31@3e-5 / **any TP×king-self** (H29/H32/H33 dead).
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20.
Engine recover: wipe `role_*` caches **before** new TCACHE + ≥20s settle.
**n80 must rotate `--block-hash`** (default 0*64 → teacher 400 @~40/80).
`watch_n80_retry` must **not** `exec`. Retry waits for double
completions200 (20s apart); false_probe decisions auto-quarantine.
`FALSE_PROBE_*` ≠ REFUTE — do not `lium rm`.

## Next action

1. H34/H35/H36: poll n80 → `h*_decision.json`. Margin >0.04 → Stage 5;
   else REFUTE → `lium rm mine-hN-1` only; fill slot with non-α neighbour.
2. H37/H38: wait chall p205 double-promptable → watcher starts a203 n80.
   If Triton dies again → wipe→settle20→`relaunch_chall_pass205.sh` (or new).
