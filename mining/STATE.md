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
| R2ak | **n80 RUNNING** pid24452 · progress **~15/80** |
| R2ab | eager+premerge **DONE** Δ=0.626 · merge_reload waits R2ak |
| R2ac | **RE-ARMED** Talent×google eager merge pid25746/25770 · DONE gates 470 hr>0 |
| R2al | pure pig wait R2ak |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | TKC · R2ak n80 · R2ac CPU merge · R2al/R2ab wait · watch470/471 |

- R2ak: n80 vs Tok; Stage-5 only if hr≥1.5× → `r2ak_google_decision.json`
- R2ac: CPU α Talent0.25×google0.75 writing `/root/r2_out/alpha_talent_google_skew`; merge_reload waits siblings + Reason+
- R2ab: Talent×sky reload after R2ak(+R2al) terminal
- Host hist bridge pid **1264563** (pending 470–471)

## Blocked

- Submit only if sim hr ≥ **1.5×**.
- R2ac DONE only after chal-00470 Reason+ (else SKIP+purge).
- R2ab n80 only after pure-google/pig terminals (holding gate).

## Next action

**Poll** R2ak → `r2ak_google_decision.json`. If hr≥1.5× → Stage-5. Else R2al pig then R2ab. Confirm R2ac `r2ac_eager_weights.done`. Stamp 470/471 when verdicts land.
