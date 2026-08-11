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
| Lium | ~$122,375 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | **chal-00470 google** scoring chall ~51/80 · queue **471 pig** |
| warm | teacher/king **200**; chall reloading pig |
| R2ak | **DONE** `SIGNAL_POS_BELOW_3SE` hr**0.641×** (margin+0.0064 z=1.92) — no Stage-5 |
| R2al | **LOADING** pure pig chall pid27491 (post-R2ak) |
| R2ab | Talent×sky merge **DONE** Δ0.626 · waits R2al holding |
| R2ac | eager weights **DONE** Δ0.626 · DONE gates 470 hr>0 |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | TKC · R2al pig load · R2ab/R2ac wait · watch470/471 |

- R2ak closed: local google below 1.5× bar (`r2ak_google_decision.json`)
- R2al: reload pig → n80; Stage-5 only if hr≥1.5×
- R2ab: Talent×sky n80 after R2al terminal
- R2ac: merge_reload waits chal-00470 Reason+ then siblings
- Host hist bridge pid **1264563** (pending 470–471)

## Blocked

- Submit only if sim hr ≥ **1.5×**.
- R2ac DONE only after chal-00470 Reason+ (else SKIP+purge).
- R2ab n80 only after R2al terminal (holding gate).

## Next action

**Poll** R2al → `r2al_pig_decision.json`. If hr≥1.5× → Stage-5. Else R2ab Talent×sky n80. Stamp 470/471 when verdicts land; unblock R2ac if 470 hr>0.
