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
| Lium | ~$122,018 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | **chal-00481** duel phase; queue cgpb9 + kevin h44 |
| warm | teacher/king **200**; chall R2am :8002 **READY** |
| R2ad | **REFUTE** hr**−1.18×** (m−0.037 z−3.54 n80) · pig blend purged |
| R2am | n80#1 **ReadTimeout@61/80** → patched 600s×5 → **n80#2 RUNNING** ~1/80 |
| R2an | wait R2am decision · Δ0.626 (481 hist hr0.16×) |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | TKC · R2am n80#2 · R2an wait |

- R2am relaunch pid **82533** / sim **82665** → `r2am_alpha_decision.json`
- Stage-5 only if hr≥1.5×; else R2an reload→n80 (or SKIP_BOARD)

## Blocked

- Submit only if sim hr ≥ **1.5×**.
- Talent0.25 skew keeps REFUTEing Reason+ parents — treat R2am/R2an as last skews this wave.

## Next action

**Poll** R2am n80#2→decision. If hr≥1.5× → Stage-5 HF push+submit. Else R2an reload→n80 (or SKIP_BOARD if pattern holds). Stamp 481 final when scoring ends.
