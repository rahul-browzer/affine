# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4** — R2ap pure-h44 n80 gathering; R2aq/ar/as armed; **726 prefetch DONE**. `weight_version_key=3`.

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · crown = margin > **k_sigma·SE** (`k_sigma=2` live) |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` |
| corpus | epoch **7** · schema v2 (**synced**) |
| Lium | ~$121,814 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | Q **485 h44** (dueling) + **486 now** + **489 af17** + **490 iynocr2p** + **491 hope11** + **492 726** |
| warm | T/K/C **200/200/200** · R2ap n80 **~33/80** |
| R2ao | **REFUTE** hr **−0.074×** · Stage-5 SKIP |
| R2ap | pure h44 n80 **gathering** · Stage-5 armed |
| R2aq | pure now **ARMED** wait R2ap · Stage-5 armed |
| R2ar | pure iynocr2p **ARMED** wait R2aq · prefetch DONE |
| R2as | pure 726 **ARMED** wait R2ar · prefetch **DONE** · Stage-5 armed |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | R2ap n80 · R2aq/ar/as wait · 492 |

- teacher **91262** (:8000) · king **91277** (:8001) · chall h44 **104821** (:8002)
- R2ap sim **110708** · Stage-5 **86943**
- R2aq wait **87484** · Stage-5 **87497**
- R2ar wait **111595** · Stage-5 **111599**
- R2as wait **114233** · Stage-5 **114242**
- watch-485/486/489/490/491/492 · prefetch **726 DONE** @57ad3177…

## Blocked

- Submit only if sim hr ≥ **1.5×**.
- Talent0.25 skew keep REFUTE — prefer **pure** parents.
- Pure af17 (R2ao) dead — do not re-sim.

## Next action

**Poll** R2ap n80→decision. If hr≥1.5× → Stage-5 HF push → register+submit. Else R2aq pure-now (orphan-kill CUDA4,5 only). Stamp 485/486/489/490/491/492 board hr when gzips land; R2as auto-runs after R2ar.
