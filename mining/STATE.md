# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4** — **R2at** pure-hope11 n80 **~4/80**. `weight_version_key=3`.

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · crown = margin > **k_sigma·SE** (`k_sigma=2` live) |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` |
| corpus | epoch **7** · schema v2 (**synced**) |
| Lium | ~$121,579 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | Q **489** load_challenger(af17); **491**=hope11 queued; host-hist 489–499 |
| warm | T/K/C **200/200/200** · hope11 chall serving :8002 |
| R2as | pure 726 **WEAK_SKIP** hr **0.060×** (done) |
| R2at | pure hope11 n80 **~4/80** pid**151923** · Stage-5 armed |
| R2au | pure sft4 **ARMED** wait R2at · chall staged |
| R2av | pure Bittoby-v2 **ARMED** wait R2au · v2_chall staged |
| R2ax | pure **tt** **ARMED** wait R2av · tt_chall ready · Stage-5 armed |
| host-hist | bridge **pid1863303** pending 489–495 (+497–499) |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | R2at hope11 n80 · R2au…ax wait |

- teacher **91262** (:8000) · king **91277** (:8001) · chall hope11 **146738** (:8002)
- R2at n80 **151923** · reload **115843** · Stage-5 **115855**
- R2au wait **124777** · Stage-5 **124789**
- R2av wait **125528** · Stage-5 **125529** · `/root/r2_out/v2_chall` ready
- R2ax wait **143276** · Stage-5 **143277** · `/root/r2_out/tt_chall` ready
- host `host_history_stamp_bridge.py` → pod stamps when verdict lands

## Blocked

- Submit only if sim hr ≥ **1.5×** (vs 3·SE metric / ~1.5× live 2·SE).
- Talent0.25 skew keep REFUTE — prefer **pure** parents.
- Pure af17 (R2ao) dead; h44 0.327×; now 0.773×; **726 0.060×** — Stage-5 SKIP.
- iynocr2p / mt1 unservable; diane/new + adambell ckpt1000 **gated** — do not prefetch.
- On-pod history/gzip watchers often blind — use host bridge.

## Next action

**Poll** R2at hope11 n80 → decision. If hr≥1.5× → Stage-5. Else R2au→av→ax (challs prestaged). Host-hist stamps 489+ when verdicts land.
