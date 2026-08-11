# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4** — R2aq pure-now n80 ~42/80; R2ar…av armed; **R2aw mt1 SKIP_UNSERVABLE**. `weight_version_key=3`.

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · crown = margin > **k_sigma·SE** (`k_sigma=2` live) |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` |
| corpus | epoch **7** · schema v2 (**synced**) |
| Lium | ~$121,722 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | Q **485** scoring (~1813/2080) + **486–495** |
| warm | T/K/C **200/200/200** · R2aq n80 **~42/80** |
| R2ap | pure h44 **WEAK_SKIP** hr **0.327×** · Stage-5 SKIP |
| R2aq | pure now **~42/80** (pid122306) · Stage-5 armed |
| R2ar | pure iynocr2p **ARMED** wait R2aq · chall pre-staged |
| R2as | pure 726 **ARMED** wait R2ar · chall pre-staged |
| R2at | pure hope11 **ARMED** wait R2as · chall pre-staged |
| R2au | pure sft4 **ARMED** wait R2at · chall staged · Stage-5 armed |
| R2av | pure Bittoby-v2 **ARMED** wait R2au · prefetch **DONE** · Stage-5 armed |
| R2aw | pure mt1 **SKIP_UNSERVABLE** (`Glm4MoeForCausalLM`) — no prefetch |
| host-hist | bridge **pid1863303** pending 485–495 |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | R2aq n80 · R2ar…av · v2 cached |

- teacher **91262** (:8000) · king **91277** (:8001) · chall now **117156** (:8002)
- R2aq sim **122306** · Stage-5 **87497**
- R2ar wait **111595** · Stage-5 **111599**
- R2as wait **114233** · Stage-5 **114242**
- R2at wait **115843** · Stage-5 **115855**
- R2au wait **124777** · Stage-5 **124789**
- R2av wait **125528** · Stage-5 **125529** · prefetch DONE
- host `host_history_stamp_bridge.py` → pod stamps when verdict lands

## Blocked

- Submit only if sim hr ≥ **1.5×**.
- Talent0.25 skew keep REFUTE — prefer **pure** parents.
- Pure af17 (R2ao) dead; pure h44 (R2ap) below bar; mt1 (R2aw) wrong arch — do not re-sim/prefetch.
- On-pod history/gzip watchers often blind (CF 403 / gzip 404) — use host bridge.
- Next queue parent after v2/sft4 lanes: wait for **new** Q entries (or R2aq decision).

## Next action

**Poll** R2aq n80→decision. If hr≥1.5× → Stage-5 HF push → register+submit. Else R2ar pure-iynocr2p. Host-hist stamps when 485+ verdicts land. Watch for new queue parents ≠ Glm4Moe.
