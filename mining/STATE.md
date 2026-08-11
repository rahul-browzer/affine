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
| challenge | chal-00498 scoring; queue 502/504/508/511… |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 · fleet **parallel×4** @POLL=1s |
| Lium bal | ~$120,174 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2bf** n80 ~43/80 dpo2@90ea78ff |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R3b** GRPO sole pid**51672** @step1+ |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R6** train ~10/96 @max_len16384 |
| host fleet-rent | pid**2696613** | — | **parallel×4** →R7/R8/R24/R25 @1s |
| host fleet-boot | pid**2463724** | — | auto-upload @5s |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3/R3b: `ssh root@204.9.206.245 -p 40051`
SSH R4/R6: `ssh root@86.38.182.50 -p 40307`
R2bf: `tail -f /root/logs/r2bf_dpo2_reload.log` · dec `r2bf_dpo2_decision.json`
R3b: `tail -f /root/logs/r3_train.nohup` · pipe `r3b_pipeline.nohup`
R6: `tail -f /root/logs/h101_train.nohup` · dec `h101_decision.json`
Fleet: `tail -f experiments/fleet-rent/logs/wait_{fleet_b300,bootstrap_fleet}.log`
**p2129:** fleet serial→**parallel×4** (R7/R8/R24/R25); B300×8=0; burn still **$180.25/h**.

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.

## Next action
**Rent:** snatch via parallel×4 (R7 first). Bootstrap auto-arms.
**R3b:** wait train.done → merge/n80 → `r3b_decision.json`.
**R6:** wait train.done → merge/n80 → `h101_decision.json`.
**Crown:** wait R2bf n80 → decision.
