# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4** — Reason v3 crown push. `weight_version_key=3`. King-watch revoked.

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · crown = margin > 3·SE |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` |
| corpus | epoch **7** · schema v2 |
| Lium | ~$122,573 · burn **$64/h** (≤$833/h) |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| **R2ag** | pure tpc9 **REFUTE** hr **−0.52×** |
| **R2ah/R2z** | **SKIP_BOARD** chal-00467 v9 hr **0.21×** |
| **R2ai** | sbs-v0 relaunched · chall **299985** :8002 · script **299876** |
| **R2aa–ad** | wait 468–471 Reason+ · blocked on R2ai PID |
| board | duel **chal-00468** sbs-v0 |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TKC@65536 · R2ai loading · Stage-5 watch |

- R2ai: `tail -f /root/logs/r2ai_sbs_reload.log`
- Stage-5: `tail -f /root/logs/watch_r2ai_stage5_push.log`
- Host bridge pid **1202431**: `experiments/r2-multiking-merge/logs/host_history_stamp_bridge.log`
- p1993: killed orphan R2ah EngCore/workers (GPU4/5 OOM) → relaunched R2ai

## Blocked

- Submit only if sim hr ≥ **1.5×**. sth gated=manual. tpc9 unservable.
- Pod CF 403 on affine.io — use host bridge. Kill EngCore orphans after API pidfile kill.

## Next action

**Watch R2ai** → n80 → `r2ai_sbs_decision.json`. hr≥1.5× → Stage-5. Else next Reason+ **469–471** (pure > Talent).
