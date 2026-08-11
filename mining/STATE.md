# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4** — R2aq pure-now n80 ~10/80; R2ar/as/at armed; host-hist 485–495; sft4 prefetch. `weight_version_key=3`.

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · crown = margin > **k_sigma·SE** (`k_sigma=2` live) |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` |
| corpus | epoch **7** · schema v2 (**synced**) |
| Lium | ~$121,752 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | Q **485 h44** scoring (~1302/2080) + **486–495** (now…sft4) |
| warm | T/K/C **200/200/200** · R2aq n80 **~10/80** |
| R2ap | pure h44 **WEAK_SKIP** hr **0.327×** · Stage-5 SKIP |
| R2aq | pure now **~10/80** (pid122306) · Stage-5 armed |
| R2ar | pure iynocr2p **ARMED** wait R2aq · chall pre-staged |
| R2as | pure 726 **ARMED** wait R2ar · chall pre-staged |
| R2at | pure hope11 **ARMED** wait R2as · chall pre-staged |
| sft4 | chal-00495 prefetch **running** (pid123772) · host-hist +495 |
| host-hist | bridge **pid1863303** pending 485–495 |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | R2aq n80 · R2ar…at · sft4 prefetch |

- teacher **91262** (:8000) · king **91277** (:8001) · chall now **117156** (:8002)
- R2aq sim **122306** · Stage-5 **87497**
- R2ar wait **111595** · Stage-5 **111599**
- R2as wait **114233** · Stage-5 **114242**
- R2at wait **115843** · Stage-5 **115855**
- prefetch sft4 **123772**
- host `host_history_stamp_bridge.py` → pod stamps when verdict lands

## Blocked

- Submit only if sim hr ≥ **1.5×**.
- Talent0.25 skew keep REFUTE — prefer **pure** parents.
- Pure af17 (R2ao) dead; pure h44 (R2ap) below bar — do not re-sim.
- On-pod history/gzip watchers often blind (CF 403 / gzip 404) — use host bridge.

## Next action

**Poll** R2aq n80→decision. If hr≥1.5× → Stage-5 HF push → register+submit. Else R2ar pure-iynocr2p (orphan-kill CUDA4,5 only). Confirm sft4 prefetch DONE; host-hist stamps when 485+ verdicts land.
