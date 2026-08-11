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
| Lium | ~$122,334 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | **chal-00471 pig** `load_challenger` · queue **480 sbs-v1** |
| warm | teacher/king/chall **200**; R2al pig n80 ~34/80 |
| R2ak | **DONE** local hr**0.641×** · board 470 hr**0.094×** — no Stage-5 |
| R2al | **RUNNING** pig n80 ~34/80 (pid30870) |
| R2ab | Talent×sky wait R2al (premerge DONE Δ0.626) |
| R2ac | Talent×google premerge DONE Δ0.626 · wait R2ab |
| R2ad | **EAGER** Talent×pig α-merge Δ**0.626** · wait 471 hr>0 for DONE |
| sbs-v1 | **prefetch RUNNING** chal-00480 @`d88d3bc…` (p2011) |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | TKC · R2al n80 · R2ad EAGER · sbs-v1 prefetch · watch471 |

- R2al: pig n80 → `r2al_pig_decision.json`; Stage-5 only if hr≥1.5×
- R2ab → R2ac → R2ad n80 chain after prior terminal
- R2ad: EAGER weights ready; DONE gated on chal00471 Reason+; merge_reload waits lane
- Host hist bridge pid **1398836** (pending 471+480)
- sbs-v1 prefetch: `/root/logs/r2_prefetch_sbs_v1.log` (no merge until board Reason+)

## Blocked

- Submit only if sim hr ≥ **1.5×**.
- R2ab n80 only after R2al terminal.
- R2ac n80 only after R2ab terminal.
- R2ad DONE only if board 471 hr>0; n80 after R2ac terminal.
- Talent×sbs-v1 merge only after 480 Reason+ (v0 was 0.018×).

## Next action

**Poll** R2al → `r2al_pig_decision.json`. If hr≥1.5× → Stage-5. Else after R2al terminal confirm R2ab starts; stamp 471 when published → R2ad DONE or SKIP. Confirm sbs-v1 prefetch DONE.
