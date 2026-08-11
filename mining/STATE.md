# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4** — R2aq pure-now **WEAK_SKIP** (hr 0.773×); R2ar iynocr2p chall loading; R2as…av armed. `weight_version_key=3`.

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · crown = margin > **k_sigma·SE** (`k_sigma=2` live) |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` |
| corpus | epoch **7** · schema v2 (**synced**) |
| Lium | ~$121,681 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | Q **486**+ pending hist; **485** stamped hr **0.601×** (h44) |
| warm | T/K **200/200** · C iynocr2p loading (:8002) |
| R2aq | pure now **WEAK_SKIP** m+0.00795 z=2.32 hr **0.773×** (n=80) |
| R2ar | pure iynocr2p **LOADING** chall pid128596 · Stage-5 armed |
| R2as | pure 726 **ARMED** wait R2ar · chall pre-staged |
| R2at | pure hope11 **ARMED** wait R2as · chall pre-staged |
| R2au | pure sft4 **ARMED** wait R2at · chall staged · Stage-5 armed |
| R2av | pure Bittoby-v2 **ARMED** wait R2au · prefetch **DONE** · Stage-5 armed |
| R2aw | pure mt1 **SKIP_UNSERVABLE** (`Glm4MoeForCausalLM`) |
| host-hist | bridge **pid1863303** pending 486–495 (485 DONE) |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | R2ar load · R2as…av · v2 DONE |

- teacher **91262** (:8000) · king **91277** (:8001) · chall iynocr2p **128596** (:8002)
- R2ar reload **111595** · Stage-5 **111599**
- R2as wait **114233** · Stage-5 **114242**
- R2at wait **115843** · Stage-5 **115855**
- R2au wait **124777** · Stage-5 **124789**
- R2av wait **125528** · Stage-5 **125529** · prefetch DONE
- host `host_history_stamp_bridge.py` → pod stamps when verdict lands

## Blocked

- Submit only if sim hr ≥ **1.5×** (vs 3·SE metric / ~1.5× live 2·SE).
- Talent0.25 skew keep REFUTE — prefer **pure** parents.
- Pure af17 (R2ao) dead; h44 (R2ap) 0.327×; now (R2aq) 0.773× — best pure signal so far but SKIP.
- mt1 (R2aw) wrong arch — do not re-sim/prefetch.
- On-pod history/gzip watchers often blind — use host bridge.

## Next action

**Poll** R2ar engines→n80→decision. If hr≥1.5× → Stage-5 HF push → register+submit. Else R2as pure-726. Host-hist stamps 486+ when verdicts land.
