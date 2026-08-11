# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 3** — crown pod restoring warm stack (TKC @65536). `weight_version_key=3`.

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · crown = margin > 3·SE |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` |
| corpus | epoch **7** · schema v2 (**synced** on pod) |
| Lium | ~$122,497 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | duel **chal-00469** (sky) · queue 470 google / 471 pig |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | restore **2138** (HF DL ~40/27/11 GiB) · R2aj **3857** · sky prefetch **3855** |

- Poll: `/root/logs/warm_stack_ready.done` + engines **200/200/200**
- R2aj: wait warm → board `chal00469_reason.json` → skip if hr&lt;1.5× else sky chall→n80
- Prefetch: `/root/logs/r2_prefetch_sky.done` (starts after warm)
- Host hist bridge pid **1264563** (pending 469–471)

## Blocked

- No TKC until restore finishes (HF DL → serve).
- Submit only if sim hr ≥ **1.5×**.

## Next action

**Poll** warm_stack_ready / R2aj log: if SKIP_BOARD on 469, arm pure **google** (470) next; if n80 runs, harvest `r2aj_sky_decision.json` (Stage-5 only if hr≥1.5×).
