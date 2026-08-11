# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4** — warm TKC up; chase Reason crown vs Tok. `weight_version_key=3`.

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · crown = margin > **k_sigma·SE** (`k_sigma=2` live) |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` |
| corpus | epoch **7** · schema v2 (**synced**) |
| Lium | ~$121,977 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | Q **485 h44** + **486 now** + **489 af17** (gzips still 404) |
| warm | teacher/king **200**; chall R2am :8002 **READY** |
| R2am | n80#2 **RUNNING** ~46/80 · Stage-5 push **armed** |
| R2ao | pure af17 **ARMED** wait R2am · Stage-5 armed · chall dir ready |
| R2ap | pure h44 **ARMED** wait R2ao · Stage-5 armed · chall dir ready |
| R2aq | pure now **ARMED** wait R2ap · Stage-5 armed · chall dir ready |
| prefetch | h44/now/af17 **DONE** |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | TKC · R2am n80#2 · R2ao→R2ap→R2aq · Stage-5×4 |

- R2am relaunch pid **82533** / sim **82665** → `r2am_alpha_decision.json`
- R2am Stage-5 waiter pid **83741**
- R2ao wait pid **86440** → pure af17 n80 after R2am; Stage-5 **86442**
- R2ap wait pid **86929** → pure h44 n80 after R2ao; Stage-5 **86943**
- R2aq wait pid **87484** → pure now n80 after R2ap; Stage-5 **87497**
- watch-485/486/489 armed (gzips pending)

## Blocked

- Submit only if sim hr ≥ **1.5×**.
- Talent0.25 skew keep REFUTE — prefer **pure** af17/h44/now.

## Next action

**Poll** R2am n80#2→decision. If hr≥1.5× → verify Stage-5 HF push → register+submit. Else R2ao→R2ap→R2aq chain. Stamp 485/486/489 board hr when gzips land; SKIP_BOARD if hr≪1.5×.
