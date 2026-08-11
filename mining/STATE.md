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
| Lium | ~$122,426 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | **chal-00470 google** `load_challenger` · queue **471 pig** · 469 stamped hr0.459× |
| warm | **READY** engines teacher/king/chall **200/200/200** |
| R2aj | **SKIP_BOARD_FIRST** hr0.459× < 1.5× |
| R2ak | **n80 RUNNING** pid24452 · progress **~12/80 chall · 9/80 king** |
| R2ab | eager+premerge **DONE** Δ=0.626 · merge_reload waits R2ak |
| R2al | pure pig wait R2ak |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | TKC · R2ak google n80 · R2al wait · R2ab wait-R2ak · watch470/471 |

- R2ak: n80 vs Tok in flight; Stage-5 only if hr≥1.5× → `r2ak_google_decision.json`
- R2ab: Talent×sky reload after R2ak(+R2al) terminal; already Reason+ gated
- Host hist bridge pid **1264563** (pending 470–471)

## Blocked

- Submit only if sim hr ≥ **1.5×**.
- R2ab n80 only after pure-google/pig terminals (holding gate).

## Next action

**Poll** R2ak → `r2ak_google_decision.json`. If hr≥1.5× → Stage-5 push. Else let R2al pig then R2ab Talent×sky n80. Stamp 470/471 via host bridge when verdicts land.
