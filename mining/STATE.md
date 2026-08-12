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
| B300 stock | **0** free 8×B300/B200 (burst polling R26) |
| Lium bal | ~$117,727 · floor $10k OK |
| submissions | 0 |
| crown / R3 / R4 :8001 | **guass** |
| R17 | **REFUTE** vs guass m=−0.014 (p2210) |
| R20 | **REFUTE** vs guass m=**−0.0196** z=−2.13 hr−1.07× (p2211) |
| R21 | **training** pandora-GRPO pid**140130** on R4 (p2212 warm-arm) |
| R24 | **training** Tok LongCtx-GRPO ~step **39**/200 |
| R25 | **bootstrap** teacher serving → hitemp train |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | warm TKC; free post-R17 |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R24** train + guass :8001 |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R21** pandora-GRPO + guass |
| mine-r25-hitemp-1 | zesty-fox-bc | $40.00 | **R25** hitemp bootstrap |
| host fleet-burst | pid**3623101** | — | snatching next **R26** |
| host fleet-rent | pid**3373328** (**STOP**) | — | CONT if burst ends empty |
| host fleet-boot | pid**2756348** | — | POLL=5s |
| host hist bridge | pid**3174953** | — | pending chal-00525 |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307` · R25: `ssh root@150.136.71.147 -p 20309`
R21: `tail -f /root/logs/r3_train.nohup` · artifact `experiments/r21-pandora-grpo/artifacts/p2212_r21_warm_arm.json`
R24: `tail -f /root/logs/r3_train.nohup` · R25: `tail -f /root/logs/bootstrap_r3.log`
Burst: `tail -f experiments/fleet-rent/logs/burst_p2212.log`
Crown Removal **2026-08-13T02:35Z**. R3 **04:29Z**. R4 **08:57Z**. R25 **08:46Z**.

## Blocked
Still under $833/h — need more 8×B300 (B200 fallback OK until B300 appears).
R10: need Hub access to `ammazon/…-sbs-v2`.

## Next action
**Rent:** keep burst **3623101** snatching (next **R26**); CONT **3373328** on TIMEOUT.
**R21:** train→merge→n80 vs guass (post **140137**).
**R25:** finish bootstrap → hitemp GRPO train → n80 vs guass.
**R24:** train→merge→n80 vs guass.
