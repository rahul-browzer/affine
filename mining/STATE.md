# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H34–H38 live (5/5).** H32/H33 **REFUTED**. No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | **~$190,170** · cum mining ~$3,710 · **avail ~$180.2k** |
| miner | τ10.000 free · 0 submissions |
| H34 | n80 **~31/80** (engines healthy) |
| H35 | merge.done · t/k=200 (king recover 201b) · **chall loading** |
| H36 | merge.done non-id · t/k=200 (teacher recover) · **chall relaunch loading** |
| H37 | **training** (m7×winner-zA lr1e-4) |
| H38 | **training** (m7×winner-zA ep2) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h34-1 | calm-wolf-a8 | 38.255.28.19:20100 | ~08:59Z | H34 n80 |
| mine-h35-1 | calm-fox-12 | 38.255.28.21:20100 | ~09:19Z | H35 chall→n80 |
| mine-h36-1 | calm-orbit-65 | 38.255.28.22:20098 | ~09:21Z | H36 chall→n80 |
| mine-h37-1 | swift-matrix-54 | 152.236.142.232:40311 | ~09:53Z | H37 train |
| mine-h38-1 | golden-matrix-b9 | 152.236.142.236:40298 | ~09:52Z | H38 train |

known_hosts `/tmp/mine-h3{4,5,6,7,8}-1.known_hosts`.
**Free slots: 0.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue** plmk / H21–H33
α / H30@1e-5 / H31@3e-5 / **any TP×king-self** (H29/H32/H33 dead).
Never tear down on ConnectError/unpromptable — quarantine + recover.
Reject catalog pods with nvidia-smi COUNT≠8 or $/h<$20 (H37@$11.6 was 4 GPU).
Engine recover: wipe `role_*` caches **before** new TCACHE + ≥5s settle
(pass201).

## Next action

1. H34: poll n80 → `h34_decision.json`. Margin >0.04 → Stage 5 prep;
   else REFUTE → `lium rm mine-h34-1` only; fill slot with next non-α neighbour.
2. H35/H36: poll chall health+`/v1/completions` → n80 → decision. If chall
   dies on Triton again, wipe→settle→unique `chall_p*` relaunch (see
   `results/recover_pass201.md`).
3. H37/H38: poll train → merge → n80.
