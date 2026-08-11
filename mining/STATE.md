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
| Lium | ~$122,007 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | **chal-00484** load_challenger (cgpb9); queue **485 h44** + **486 now** |
| warm | teacher/king **200**; chall R2am :8002 **READY** |
| R2am | n80#2 **RUNNING** ~14/80 · Stage-5 push **armed** |
| R2an | wait R2am decision · Δ0.626 (481 hist hr0.16×) |
| prefetch | cgpb9 **DONE**; h44 **~92%**; **now chained** after h44 |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | TKC · R2am n80#2 · R2an wait · h44→now prefetch |

- R2am relaunch pid **82533** / sim **82665** → `r2am_alpha_decision.json`
- Stage-5 waiter pid **83741** → HF push if hr≥1.5× (no submit)
- h44 prefetch pid **83661**; now-after-h44 **84313**; watch-485/486 armed

## Blocked

- Submit only if sim hr ≥ **1.5×**.
- Talent0.25 skew keeps REFUTEing — R2am/R2an last skews this wave; prefer pure parents after.

## Next action

**Poll** R2am n80#2→decision. If hr≥1.5× → verify Stage-5 HF push → register+submit. Else R2an reload→n80 (or SKIP_BOARD). Confirm h44 DONE→now prefetch; stamp 484/485/486 board hr when published.
