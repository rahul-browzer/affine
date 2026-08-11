# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4** — R2ao pure-af17 n80 gathering vs Tok. `weight_version_key=3`.

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · crown = margin > **k_sigma·SE** (`k_sigma=2` live) |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` |
| corpus | epoch **7** · schema v2 (**synced**) |
| Lium | ~$121,905 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | Q **485 h44** (dispatching) + **486 now** + **489 af17** (gzips still 404) |
| warm | TKC **200/200/200** · chall af17 :8002 · teacher/king rescued |
| R2am | **REFUTE** hr **−1.39×** · Stage-5 SKIP |
| R2ao | pure af17 **n80 RUNNING** (cont pid **102750** / sim **102808**) |
| R2ap | pure h44 **ARMED** wait R2ao · Stage-5 armed |
| R2aq | pure now **ARMED** wait R2ap · Stage-5 armed |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | R2ao n80 · R2ap→R2aq wait · Stage-5×3 |

- R2ao cont `/root/continue_r2ao_n80.sh` pid **102750** · sim **102808**
- teacher **91262** (:8000) · king **91277** (:8001) · chall af17 **88720** (:8002)
- R2ap wait pid **86929** · Stage-5 **86943**
- R2aq wait pid **87484** · Stage-5 **87497**
- watch-485/486/489 armed (gzips pending)

## Blocked

- Submit only if sim hr ≥ **1.5×**.
- Talent0.25 skew keep REFUTE — prefer **pure** af17/h44/now.

## Next action

**Poll** R2ao n80→decision. If hr≥1.5× → Stage-5 HF push → register+submit. Else R2ap→R2aq (orphan-kill CUDA4,5 only; never edit running launch scripts). Stamp 485/486/489 board hr when gzips land.
