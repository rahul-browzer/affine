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
| Lium | ~$122,446 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | duel **chal-00469** (sky, scoring chall **74**/80) · queue 470 google / 471 pig |
| warm | **READY** engines **200/200/200** @65536 |
| sky/google/pig | prefetch+chall prestage **DONE** |
| Talent | prefetch **DONE** @dbfbb3e2… |
| R2ab | eager Talent×sky **RUNNING** pid **19092** (~8 GiB mid-blend) |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | TKC · R2aj **3857** · R2ak **5813** · R2al **17285** · R2ab pre **19092** / merge **19191** · watch469–471 |

- R2aj: wait `chal00469_reason.json` → SKIP if hr&lt;1.5× else sky chall→n80
- R2ak/R2al: board-first pure google/pig after prior terminal
- R2ab: eager α now; `premerge.done` only on 469 Reason+; merge waits R2aj/ak/al
- Host hist bridge pid **1264563** (pending 469–471)

## Blocked

- R2aj gated on board stamp for chal-00469 (gzip 404; chall 74/80).
- Submit only if sim hr ≥ **1.5×**.
- R2ab n80 only after pure SKIP + Reason+ (hr>0).

## Next action

**Poll** 469 stamp / `r2ab_eager_weights.done`: if SKIP_BOARD, confirm R2ak→google; if R2ab eager DONE + Reason+, let merge_reload take chall after pure terminals. Harvest any ≥1.5× for Stage-5.
