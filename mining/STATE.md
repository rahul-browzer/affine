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
| Lium | ~$122,089 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | **chal-00481** cp13 **scoring** king ~230/2080 (hist hr **0.16×**) |
| warm | teacher/king **200**; chall R2am :8002 **READY** |
| R2ad | **REFUTE** hr**−1.18×** (m−0.037 z−3.54 n80) · pig blend purged |
| R2am | **n80 RUNNING** Talent×sbs-v1 Δ0.671 (480 hr0.503×) |
| R2an | wait R2am · Δ0.626 (481 hist hr0.16×) |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | TKC · R2am n80 · R2an wait |

- R2am → `r2am_*decision*` · Stage-5 only if hr≥1.5×
- R2an → after R2am terminal (hist 481 hr>0 already DONE)

## Blocked

- Submit only if sim hr ≥ **1.5×**.
- Talent0.25 skew keeps REFUTEing Reason+ parents — treat R2am/R2an as last skews this wave.

## Next action

**Poll** R2am n80→decision. If hr≥1.5× → Stage-5 HF push+submit. Else R2an reload→n80 (or SKIP_BOARD if pattern holds). Stamp 481 final when scoring ends.
