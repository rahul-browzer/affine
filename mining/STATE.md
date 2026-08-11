# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4** — warm TKC up; chase Reason crown vs Tok. `weight_version_key=3`.

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · crown = margin > 3·SE |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` |
| corpus | epoch **7** · schema v2 (**synced**) |
| Lium | ~$122,252 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | **chal-00480 sbs-v1** scoring king~22/80 · queue **481 cp13** |
| warm | teacher/king/chall **200**; R2ab n80 ~57/80 |
| R2ak | **DONE** local hr**0.641×** · board 470 hr**0.094×** — no Stage-5 |
| R2al | **SKIP_BOARD** local ABORT@70/80 · board **471** hr**0.580×** |
| R2ab | **RUNNING** Talent×sky n80 ~57/80 |
| R2ac | waiter **RESTARTED** (p2015 deadlock fix) · wait-lane on R2ab |
| R2ad | premerge DONE Δ0.626 · wait R2ac |
| sbs-v1 | prefetch DONE · **watch480** (scoring live) |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | TKC · R2ab n80 · R2ac/R2ad wait · watch480 |

- R2ab: → `r2ab_alpha_reason_sim.json` / decision; Stage-5 only if hr≥1.5×
- R2ac → reload+n80 after R2ab terminal (holding-stamp yield only)
- R2ad → after R2ac terminal
- watch480 pid **36279** → `chal00480_reason.json`

## Blocked

- Submit only if sim hr ≥ **1.5×**.
- R2ac n80 only after R2ab terminal.
- R2ad n80 only after R2ac terminal.
- Talent×sbs-v1 merge only after 480 Reason+ (v0 was 0.018×).

## Next action

**Poll** R2ab → `r2ab_*decision*`. If hr≥1.5× → Stage-5. Else confirm R2ac claims chall (not stuck on R2ad). When 480 stamps Reason+ → arm Talent×sbs-v1 (else SKIP).
