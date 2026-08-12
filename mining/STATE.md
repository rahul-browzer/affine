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
| miner burn | **$220.25/h** · floor $833/h · **gap −$613/h** |
| B300 stock | **0** free 8×B300/B200 (burst polling R27) |
| Lium bal | ~$117,582 · floor $10k OK |
| submissions | 0 |
| crown / R3 / R4 :8001 | **guass** |
| R25 | **guass :8001 DONE**; train ~step **36**/200 · mean_r back |
| R17 | **REFUTE** vs guass m=−0.014 (p2210) |
| R20 | **REFUTE** vs guass m=**−0.0196** z=−2.13 hr−1.07× (p2211) |
| R21 | **training** pandora-GRPO ~step **61**/200 on R4 |
| R24 | **training** Tok LongCtx-GRPO ~step **71**/200; **post KING→guass** (p2217) |
| R26 | **training** LoTemp GRPO temp=0.5 ~step **47**/200 on crown |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R26** LoTemp-GRPO + guass TK |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R24** train + guass :8001 |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R21** pandora-GRPO + guass |
| mine-r25-hitemp-1 | zesty-fox-bc | $40.00 | **R25** train + **guass DONE** |
| host fleet-burst | pid**3682673** | — | snatching next **R27** |
| host fleet-rent | pid**3373328** (**STOP**) | — | CONT if burst ends empty |
| host fleet-boot | pid**2756348** | — | POLL=5s |
| host hist bridge | pid**3174953** | — | pending chal-00525 |

SSH crown/R26: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307` · R25: `ssh root@150.136.71.147 -p 20309`
R24 post: pid**94952** KING=guass · form pid**94957** · train pid**88309**
Burst: `tail -f experiments/fleet-rent/logs/burst_p2217.log`
Crown Removal **2026-08-13T02:35Z**. R3 **04:29Z**. R4 **08:57Z**. R25 **08:46Z**.

## Blocked
Still under $833/h — need more 8×B300 (B200 fallback OK until B300 appears).
R10: need Hub access to `ammazon/…-sbs-v2`.

## Next action
**Rent:** keep burst **3682673** snatching (next **R27**); CONT **3373328** on TIMEOUT.
**R24:** train→merge→n80 vs guass (post KING fixed p2217).
**R25/R26/R21:** train→merge→n80 vs guass.
