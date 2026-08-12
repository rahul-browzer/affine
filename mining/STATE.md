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
| Lium bal | ~$117,315 · floor $10k OK |
| submissions | 0 |
| R10 / R18 | **BLOCKED** sbs-v2 index **403** |
| R5b arm | **p2225** guass + **p2228** Reason writer in prestage |
| R19 arm | **p2228** guass king + Reason writer + form-dec |
| form-dec | **p2227** → `write_reason_decision` on live 4 pods |
| R26 | train~**149**/200; guass :8001; form**358813**; post**356966** |
| R24 | train~**125**/200; tmax waits done→**65536**; form**99772** |
| R21 | train~**155**/200; teacher **65536**; form**145257** |
| R25 | train~**98**/200; teacher **65536**; form**23089** |

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
R5b prestage: `experiments/r5b-talent-base/artifacts/mine-r5b-stack.prestaged.tar.gz`
R19 arm: `experiments/r19-talent-grpo/artifacts/p2228_guass_king_arm.json`
Crown Removal **2026-08-13T02:35Z**. R3 **04:29Z**. R4 **08:57Z**. R25 **08:46Z**.

## Blocked
Under $833/h — need more 8×B300 (B200 fallback OK until B300 appears).
R10/R18 blocked on gated `ammazon/…-sbs-v2` (index 403).
R22/R23 still Tok-king in bootstrap (arm next if stock empty).

## Operator directive 2026-08-12 — SUBMIT GATE = LIVE CROWN RULE
**Submit when:** paired margin > **live `k_sigma · SE`** (k=2.0) on a fresh
slice vs the **current** king. No 1.5×. No absolute margin>0.04 bar.
Re-sim WEAK_CLEAR vs **guass** before submit (not stale ckp333).

## Next action
1. Keep burst snatching; R5b/R19 boot packs now include Reason writer + guass.
2. R24/R21/R25/R26 train→merge→n80 vs **guass**; any clear → Stage-5.
3. If still empty stock: arm R22/R23 Tok→guass like R19.
