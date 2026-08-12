# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage
**Stage 4 — beat the king; parallel axes.** Reason v3 · win the subnet.
Burn floor **≥$833/h** on mine-* 8×B300 (operator 2026-08-11).

## Live facts

| item | value |
|---|---|
| contract | wvk=**3** · `k_sigma=2.0` · reason_only · n_turns=2080 |
| king | `tolegend/Affine-5fqbxvz29b-ckp333` @ `24c137e8…` **reign 5** |
| challenge | chal-**00521** |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 (burst+waiter; 429s) |
| Lium bal | ~$118,025 · floor $10k OK |
| submissions | 0 |
| R15 | **CPU merge writing** post pid**80706** / merge**80751** (p2201; GPU auto hung) |
| R17 | **training** coder-REINFORCE crown ~step **60**/200 |
| R20 | **training** kevin-GRPO mine-r4 ~step **17**/200 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R17** coder-REINFORCE (TKC warm) |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R15** merge→chall→n80 |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R20** kevin-GRPO |
| host fleet-rent | pid**3373328** (CONT) | — | api-POST-rent; next=**R24** |
| host fleet-burst | pid**3465495** | — | SKIP_PID_LOCK p2199 |
| host fleet-boot | pid**2756348** | — | POLL=5s |
| host hist bridge | pid**3174953** | — | +chal-00525 |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307`
R15: `tail -f /root/logs/r15_post_train.nohup` · R17: `tail -f /root/logs/h135_train.nohup`
R20: `tail -f /root/logs/r3_train.nohup` · Fleet: `tail -f experiments/fleet-rent/logs/wait_fleet_b300.log`
HF R15: `unconst/Affine-5czsc2fc98-r15-pandora-rl` (armed; not submit)
Crown Removal **2026-08-13T02:35:59Z** (Soft **01:35Z** / Dead **02:05Z**).
R3 Removal **2026-08-13T04:29:36Z** (Soft **03:29Z** / Dead **03:59Z**).
R4 Removal **2026-08-13T08:57:47Z** (Soft **07:57Z** / Dead **08:27Z**).

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.
R10: need Hub access to `ammazon/…-sbs-v2` (or public merge parent).

## Next action
**R15:** wait merge.done (CPU; watch `stat %b` on `.tmp*` — size can sit at ~47G while blocks fill) → chall:8002 → n80 vs ckp333 (hr≥1.5×); `h135_decision.json`.
**Rent:** snatch **R24** via waiter **3373328** / burst **3465495** on first 8×.
**R17/R20:** continue train → merge→n80 when DONE.
