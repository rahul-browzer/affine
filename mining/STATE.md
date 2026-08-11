# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4** — R2ap pure-h44 n80 loading after R2ao REFUTE. `weight_version_key=3`.

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · crown = margin > **k_sigma·SE** (`k_sigma=2` live) |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` |
| corpus | epoch **7** · schema v2 (**synced**) |
| Lium | ~$121,844 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | Q **485 h44** (duel/dispatching) + **486 now** + **489 af17** (gzips still 404) |
| warm | T/K **200/200** · chall h44 :8002 **loading** (pid **104821**) |
| R2ao | **REFUTE** hr **−0.074×** (margin −0.0007, z=−0.22, n=80) · Stage-5 SKIP |
| R2ap | pure h44 **reload→n80** (launch pid **86929**) · Stage-5 armed |
| R2aq | pure now **ARMED** wait R2ap · Stage-5 armed |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | R2ap h44 reload · R2aq wait · Stage-5×2 |

- teacher **91262** (:8000) · king **91277** (:8001) · chall h44 **104821** (:8002 loading)
- R2ap launch pid **86929** · Stage-5 **86943**
- R2aq wait pid **87484** · Stage-5 **87497**
- watch-485/486/489 armed (gzips pending)

## Blocked

- Submit only if sim hr ≥ **1.5×**.
- Talent0.25 skew keep REFUTE — prefer **pure** af17/h44/now.
- Pure af17 (R2ao) is dead — do not re-sim.

## Next action

**Poll** R2ap engines→n80→decision. If hr≥1.5× → Stage-5 HF push → register+submit. Else R2aq pure-now (orphan-kill CUDA4,5 only). Stamp 485/486/489 board hr when gzips land.
