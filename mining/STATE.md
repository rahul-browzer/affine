# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage
**Stage 4 — beat the king; parallel axes.** Reason v3 · win the subnet.
Burn floor **≥$833/h** on mine-* 8×B300 (operator 2026-08-11).

## Live facts

| item | value |
|---|---|
| contract | wvk=**3** · `k_sigma=2.0` · reason_only · n_turns=2080 |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` reign 4 |
| challenge | chal-00497 scoring; queue has 502/504… |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 · fleet **blind-fire** POLL=0 |
| Lium bal | ~$120,550 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | TK healthy; **R2bc chall DEAD** (weight-load) |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | GRPO step≥**158**/200 + wedge |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R4b train** lr=5e-6 ep2 pid**25058** |
| host fleet-rent | pid**2471342** | — | blind-fire →25 @POLL=0 (R5…) |
| host fleet-boot | pid**2463724** | — | auto-upload @5s; next R5 |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307`
R4b: `tail -f /root/logs/h121_train.nohup` · meta `/root/affine_data/r4b_train_launched.json`
R3: `tail -f /root/logs/r3_train.nohup` · hb `[r3-hb]`
R2bc: chall ValueError weight-init; next serve HF id / skip→R2bd
Fleet: `tail -f experiments/fleet-rent/logs/wait_{fleet_b300,bootstrap_fleet}.log`

## Blocked
No free 8×B300/B200. R2bc chall cannot load ec08cldg (same keys as king; still `language_model.model.*` uninit).

## Next action
**Rent:** snatch next B300 → `mine-r5-nonking-1` (blind-fire@0).
**R4b:** wait train.done→post_train→n80 (`h121_decision.json`).
**Crown:** fix R2bc serve (HF `arbosfan/…-ec08cldg@24a3a65e` + preprocessor) or skip→**R2bd** ckp55.
**R3:** train.done→n80 (step≥158/200).
