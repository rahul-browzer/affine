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
| Lium bal | ~$117,340 · floor $10k OK |
| submissions | 0 |
| R10 / R18 | **BLOCKED** sbs-v2 index **403** |
| R5b arm | **p2225** sim-king→**guass** + prestaged stack |
| form-dec | **p2227** → `write_reason_decision` (was margin>0.04) |
| R26 | train~**140**/200; guass :8001; form**358813**; post**356966** |
| R24 | train~**119**/200; tmax waits done→**65536**; form**99772** |
| R21 | train~**146**/200; teacher **65536**; form**145257** |
| R25 | train~**92**/200; teacher **65536**; form**23089** |

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
Form fix: `experiments/s4-h2-merge/artifacts/p2227_form_decision_reason_crown.json`
Crown Removal **2026-08-13T02:35Z**. R3 **04:29Z**. R4 **08:57Z**. R25 **08:46Z**.

## Blocked
Under $833/h — need more 8×B300 (B200 fallback OK until B300 appears).
R10/R18 blocked on gated `ammazon/…-sbs-v2` (index 403).

## Operator directive 2026-08-12 — SUBMIT GATE = LIVE CROWN RULE
**Submit when:** paired margin > **live `k_sigma · SE`** (k=2.0) on a fresh
slice vs the **current** king. No 1.5×. No absolute margin>0.04 bar.
Re-sim WEAK_CLEAR vs **guass** before submit (not stale ckp333).

## Next action
1. Keep burst snatching; R24/R21/R25/R26 train→merge→n80 vs **guass**.
2. Any n80 with `margin > k_sigma·SE` (k=2) vs **guass** → Stage-5 immediately.
3. Do **not** trust form-decision if it still cites `write_merge_decision` / 0.04.
