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
| B300 stock | **0** free 8×B300 (burst got 1× **B200**; still polling) |
| Lium bal | ~$117,774 · floor $10k OK |
| submissions | 0 |
| crown / R3 / R4 :8001 | **guass** |
| R17 | **REFUTE** vs guass m=−0.014 (p2210) |
| R20 | **REFUTE** vs guass m=**−0.0196** z=−2.13 hr−1.07× (p2211) |
| R24 | **training** Tok LongCtx-GRPO ~step **31**/200 |
| R25 | **RENTED** `mine-r25-hitemp-1` 8×B200 $40/h · bootstrapping |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | warm TKC; free post-R17 |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R24** train + guass :8001 |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | R20 closed — **arm next axis** |
| mine-r25-hitemp-1 | zesty-fox-bc | $40.00 | **R25** hitemp GRPO bootstrap |
| host fleet-burst | pid**3557663** | — | still polling (mine=4/25) |
| host fleet-rent | pid**3373328** (**STOP**) | — | CONT if burst ends empty |
| host fleet-boot | pid**2756348** | — | POLL=5s |
| host hist bridge | pid**3174953** | — | pending chal-00525 |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307` · R25: `ssh root@150.136.71.147 -p 20309`
R20 dec: `experiments/r20-kevin-grpo/artifacts/r20_decision_vs_guass_p2211.json`
R24: `tail -f /root/logs/r3_train.nohup` · R25: `tail -f /root/logs/bootstrap_r3.log`
Burst: `tail -f experiments/fleet-rent/logs/burst_p2205.log`
Crown Removal **2026-08-13T02:35Z**. R3 **04:29Z**. R4 **08:57Z**. R25 **08:46Z**.

## Blocked
Still under $833/h — need more 8×B300 (B200 fallback OK until B300 appears).
R10: need Hub access to `ammazon/…-sbs-v2`.

## Next action
**R4:** warm-arm next distinct QUEUE axis (R21 pandora-GRPO or R26+) on freed TKC.
**Rent:** keep burst **3557663** snatching (next **R26**); CONT **3373328** on TIMEOUT.
**R25:** finish bootstrap → hitemp GRPO train → n80 vs guass.
**R24:** train→merge→n80 vs guass.
