# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage
**Stage 4 — beat the king; parallel axes.** Reason v3 · win the subnet.
Burn floor **≥$833/h** on mine-* 8×B300 (operator 2026-08-11).

## Live facts

| item | value |
|---|---|
| contract | wvk=**3** · `k_sigma=2.0` · reason_only · n_turns=2080 |
| king | `ttttxxxxsada/Affine-5guassq3tu` @ `e86758f5…` **reign 6** |
| challenge | chal-**00525** (in duel) |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 (burst p2205 ~iter561) |
| Lium bal | ~$117,858 · floor $10k OK |
| submissions | 0 |
| crown :8001 | **retargeted** guass (p2206 DONE 08:24Z) |
| R17 | **training** coder-REINFORCE ~step **175**/200 |
| R20 | **training** kevin-GRPO ~step **157**/200 |
| R24 | **training** Tok LongCtx-GRPO ~step **7**/200 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R17** + warm TKC (king=guass) |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R24** Tok LongCtx-GRPO |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R20** kevin-GRPO |
| host fleet-rent | pid**3373328** (**STOP**) | — | paused for burst |
| host fleet-burst | pid**3557663** | — | SKIP_PID_LOCK 3000-iter p2205 |
| host fleet-boot | pid**2756348** | — | POLL=5s |
| host hist bridge | pid**3174953** | — | pending chal-00525 |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307`
R24: `tail -f /root/logs/r3_train.nohup` · R17: `tail -f /root/logs/h135_train.nohup`
R20: `tail -f /root/logs/r3_train.nohup`
Burst: `tail -f experiments/fleet-rent/logs/burst_p2205.log`
Retarget: `cat /root/logs/retarget_king_tttt_guass.done`
Crown Removal **2026-08-13T02:35:59Z** (Soft **01:35Z** / Dead **02:05Z**).
R3 Removal **2026-08-13T04:29:36Z** (Soft **03:29Z** / Dead **03:59Z**).
R4 Removal **2026-08-13T08:57:47Z** (Soft **07:57Z** / Dead **08:27Z**).

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.
R10: need Hub access to `ammazon/…-sbs-v2` (or public merge parent).

## Next action
**Rent:** watch burst **3557663** (next **R25**); on TIMEOUT/`rented_*` → **CONT** waiter **3373328**.
**R17/R20:** finish train→merge→n80 vs **guass** (crown :8001 already live).
**R24:** continue LongCtx-GRPO; merge→n80 when DONE.
**R3/R4 pods:** retarget their :8001 to guass before their n80s (same pattern).
