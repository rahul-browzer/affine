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
| Lium | ~$121,997 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | **chal-00485** load_challenger (h44); Q **486 now** + **489 af17** |
| warm | teacher/king **200**; chall R2am :8002 **READY** |
| R2am | n80#2 **RUNNING** ~20–23/80 · Stage-5 push **armed** |
| R2an | wait R2am decision · Δ0.626 (481 hist hr0.16×) |
| prefetch | h44 **DONE**; now **DONE**; **af17 downloading** (after now) |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | TKC · R2am n80#2 · af17 prefetch · Stage-5 arm |

- R2am relaunch pid **82533** / sim **82665** → `r2am_alpha_decision.json`
- Stage-5 waiter pid **83741** → HF push if hr≥1.5× (no submit)
- af17 prefetch pid **85553**; watch-489 **85542**; watch-485/486 armed
- chal-00484 **UNSERVABLE** (cgpb9) — Talent×cgpb9 SKIP

## Blocked

- Submit only if sim hr ≥ **1.5×**.
- Talent0.25 skew keeps REFUTEing — prefer pure parents (af17 / now / h44).

## Next action

**Poll** R2am n80#2→decision. If hr≥1.5× → verify Stage-5 HF push → register+submit. Else R2an reload→n80 (or SKIP_BOARD). Confirm af17 DONE; stamp 485/486/489 board hr; prefer **pure af17** screen over Talent skew if board Reason+.
