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
| Lium | ~$122,222 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | chal-00480 sbs-v1 **hr0.503×** (lost) · next queue live |
| warm | teacher/king/chall **200**; R2ac n80 ~1/80 |
| R2ab | **REFUTE** Talent×sky hr**−1.59×** (m−0.051 z−4.76 n77) |
| R2ac | **RUNNING** Talent×google n80 |
| R2ad | premerge DONE Δ0.626 · wait R2ac |
| R2am | **DONE+armed** Δ**0.671** · merge_reload waits R2ad (480 hr0.503×) |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | TKC · R2ac n80 · R2ad wait · R2am wait |

- R2ac → `r2ac_*decision*`; Stage-5 only if hr≥1.5×
- R2ad → after R2ac terminal
- R2am → after R2ad terminal (premerge already DONE)

## Blocked

- Submit only if sim hr ≥ **1.5×**.
- R2ad/R2am n80 serial behind R2ac.

## Next action

**Poll** R2ac → decision. If hr≥1.5× → Stage-5. Else confirm R2ad claims chall → then R2am.
