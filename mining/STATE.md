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
| challenge | queue empty (latest stamped chal-00525) |
| miner burn | **$220.25/h** · floor $833/h · **gap −$613/h** |
| B300 stock | **0** free 8×B300/B200 (burst snatching) |
| Lium bal | ~$117,411 · floor $10k OK |
| submissions | 0 |
| R10 / R18 | **BLOCKED** sbs-v2 index **403** |
| R5b arm | **p2225** sim-king→**guass** + prestaged stack |
| crown / R26 | train~**109**/200 LoTemp; guass :8001; post**356966** |
| R3 / R24 | train~**104**/200; teacher **32768** + tmax**96210**; post**96662** |
| R25 | train~**72**/200; teacher **65536**; guass :8001; post**19722** |
| R21 | train~**120**/200; teacher **65536**; post**143108** |
| R17 / R20 | **REFUTE** vs guass |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R26** LoTemp-GRPO + guass TK |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R24** train + guass + tmax + n80-gate |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R21** pandora-GRPO + guass |
| mine-r25-hitemp-1 | zesty-fox-bc | $40.00 | **R25** train + guass |
| host fleet-burst | pid**3745530** | — | **86400**-iter snatch next **R5b** |
| host fleet-rent | pid**3373328** (**STOP**) | — | CONT if burst ends empty |
| host fleet-boot | pid**2756348** | — | POLL=5s |

SSH crown/R26: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307` · R25: `ssh root@150.136.71.147 -p 20309`
Burst: `tail -f experiments/fleet-rent/logs/burst_p2224.log`
R5b arm: `experiments/r5b-talent-base/artifacts/p2225_guass_king_arm.json`
Crown Removal **2026-08-13T02:35Z**. R3 **04:29Z**. R4 **08:57Z**. R25 **08:46Z**.

## Blocked
Under $833/h — need more 8×B300 (B200 fallback OK until B300 appears).
R10/R18 blocked on gated `ammazon/…-sbs-v2` (index 403).

## Next action
**Rent:** keep burst **3745530** snatching **R5b** (now guass-armed) then R19/R22/R23…; CONT **3373328** only if it exits.
**R5b:** on rent → Talent full-FT → n80 vs **guass** (not Tok).
**R24:** train.done → tmax **65536** → merge → n80 vs guass.
**R21/R25/R26:** train→merge→n80 vs guass.
