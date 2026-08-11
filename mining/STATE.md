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
| Lium | ~$122,466 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | duel **chal-00469** (sky, scoring king **58**/80) · queue 470 google / 471 pig |
| warm | **READY** engines **200/200/200** @65536 |
| sky/google/pig | prefetch+chall prestage **DONE** |
| Talent | **prefetch running** pid **18123** (reign-3 @dbfbb3e2…) |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | TKC · R2aj **3857** (board-wait 469) · R2ak **5813** · R2al **17285** · watch469–471 · Talent DL **18123** |

- R2aj: wait `chal00469_reason.json` → SKIP if hr&lt;1.5× else sky chall→n80
- R2ak: wait R2aj terminal → board-first 470 → google chall→n80
- R2al: wait R2ak terminal → board-first 471 → pig chall→n80
- Host hist bridge pid **1264563** (pending 469–471)

## Blocked

- R2aj gated on board stamp for chal-00469 (sky scoring; gzip 404).
- Submit only if sim hr ≥ **1.5×**.
- R2ab/ac/ad need Talent DONE before eager α-merge.

## Next action

**Poll** 469 stamp / `r2_prefetch_talent.done`: if SKIP_BOARD, confirm R2ak→google; if n80, harvest `r2aj_sky_decision.json` (Stage-5 only if hr≥1.5×). After Talent DONE + pure SKIP, arm R2ab Talent×sky.
