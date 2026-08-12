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
| challenge | queue empty (chal-00525 done; alloy lost) |
| miner burn | **$220.25/h** · floor $833/h · **gap −$613/h** |
| B300 stock | **0** free 8×B300/B200 (burst polling R27) |
| Lium bal | ~$117,533 · floor $10k OK |
| submissions | 0 |
| crown / R26 :8001 | **guass** |
| R3 / R24 | train~**85**/200; teacher **32768→65536** sidecar pid**96210** |
| R25 | train~**49**/200; guass :8001 DONE |
| R17 | **REFUTE** vs guass m=−0.014 (p2210) |
| R20 | **REFUTE** vs guass m=**−0.0196** z=−2.13 (p2211) |
| R21 | train~**81**/200 (pandora-GRPO) |
| R24 | train~**85**/200; post+form wait; guass KING; tmax fix armed |
| R26 | train~**71**/200 LoTemp on crown |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R26** LoTemp-GRPO + guass TK |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R24** train + guass :8001 + tmax fix |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R21** pandora-GRPO + guass |
| mine-r25-hitemp-1 | zesty-fox-bc | $40.00 | **R25** train + guass DONE |
| host fleet-burst | pid**3704917** | — | snatching next **R27** (p2219) |
| host fleet-rent | pid**3373328** (**STOP**) | — | CONT if burst ends empty |
| host fleet-boot | pid**2756348** | — | POLL=5s |
| host hist bridge | pid**3174953** | — | chal-00525 stamped |

SSH crown/R26: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307` · R25: `ssh root@150.136.71.147 -p 20309`
R21 post: pid**140137** · form pid**142310** · train pid**140130**
R24 post: pid**94952** · form pid**95235** · train pid**88309** · tmax**96210**
Burst: `tail -f experiments/fleet-rent/logs/burst_p2219.log`
R24 tmax: `tail -f` on pod `/root/logs/r24_fix_teacher_maxlen.nohup`
Crown Removal **2026-08-13T02:35Z**. R3 **04:29Z**. R4 **08:57Z**. R25 **08:46Z**.

## Blocked
Still under $833/h — need more 8×B300 (B200 fallback OK until B300 appears).
R10: need Hub access to `ammazon/…-sbs-v2`.

## Next action
**Rent:** keep burst **3704917** snatching (next **R27**); CONT **3373328** on TIMEOUT.
**R24:** after train.done confirm teacher **65536** (`r24_teacher_maxlen_fix.json`)→merge→n80 vs guass.
**R21/R25/R26:** train→merge→n80 vs guass.
