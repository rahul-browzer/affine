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
| Lium | ~$122,201 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | live **chal-00481** `Talucampe037/…-cp13` load_challenger |
| warm | teacher/king/chall **200**; R2ac n80 ~31/80 |
| R2ab | **REFUTE** Talent×sky hr**−1.59×** |
| R2ac | **RUNNING** Talent×google n80 (~31/80) · Stage-5 push **armed** |
| R2ad | premerge DONE Δ0.626 · wait R2ac |
| R2am | **DONE+armed** Δ**0.671** · wait R2ad (480 hr0.503×) |
| R2an | **EAGER** Talent×cp13 α-merge CPU (~9/16 shards) · merge_reload armed |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | TKC · R2ac n80 · Stage5 waiter · R2an merge |

- R2ac → `r2ac_*decision*` · Stage-5 HF auto-push if hr≥1.5× (no submit)
- R2ad → after R2ac terminal · R2am → after R2ad · R2an → after R2am (if 481 hr>0)

## Blocked

- Submit only if sim hr ≥ **1.5×**.
- R2ad/R2am/R2an serial behind active n80; R2an DONE gated on 481 Reason+.

## Next action

**Poll** R2ac → decision. If hr≥1.5× → verify HF push then Stage-5 submit. Else R2ad→R2am. If 481 hr>0 → R2an n80 after R2am; else SKIP_BOARD + purge.
