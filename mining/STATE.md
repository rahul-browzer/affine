# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4** — warm TKC up; chase Reason crown vs Tok. `weight_version_key=3`.

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · crown = margin > **k_sigma·SE** (`k_sigma=2` live) |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` |
| corpus | epoch **7** · schema v2 (**synced**) |
| Lium | ~$121,946 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | Q **485 h44** (dispatching) + **486 now** + **489 af17** (gzips still 404) |
| warm | chall af17 :8002 loading; teacher/king **rescued** (pids 91262/91277) |
| R2am | **REFUTE** hr **−1.39×** (margin −0.0405, z=−4.18, n=80) · Stage-5 SKIP |
| R2ao | pure af17 **reload/wait-engines** after TKC rescue · Stage-5 armed |
| R2ap | pure h44 **ARMED** wait R2ao · Stage-5 armed · kill-fix patched |
| R2aq | pure now **ARMED** wait R2ap · Stage-5 armed · kill-fix patched |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | TKC rescue · R2ao→R2ap→R2aq · Stage-5×3 |

- R2ao pid **86440** · chall **88720** · wait :8000/:8001/:8002
- teacher rescue **91262** (GPUs 0–1) · king rescue **91277** (GPUs 2–3)
- R2ap wait pid **86929** · Stage-5 **86943**
- R2aq wait pid **87484** · Stage-5 **87497**
- watch-485/486/489 armed (gzips pending)

## Blocked

- Submit only if sim hr ≥ **1.5×**.
- Talent0.25 skew keep REFUTE — prefer **pure** af17/h44/now.

## Next action

**Poll** TKC 200/200/200 → R2ao n80→decision. If hr≥1.5× → Stage-5 HF push → register+submit. Else R2ap→R2aq. Confirm orphan-kill fix before any chall swap. Stamp 485/486/489 board hr when gzips land.
