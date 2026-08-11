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
| challenge | chal-00499 load_challenger; queue +chal-00514 |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 (only 1× each) · fleet **api-unfiltered-8x** pid**2771543** |
| Lium bal | ~$120,028 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2bg** n80 ~40/80 cp1266 |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R3b** GRPO ~step23 |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R6** train ~64/96 |
| host fleet-rent | pid**2771543** | — | **api-unfiltered-8x** (cap-protect) |
| host fleet-boot | pid**2756348** | — | POLL=5s / 86400iters |
| host hist bridge | pid**2733446** | — | +chal-00514 |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3/R3b: `ssh root@204.9.206.245 -p 40051`
SSH R4/R6: `ssh root@86.38.182.50 -p 40307`
R2bg: `tail -f /root/logs/r2bg_cp1266_reason_sim.log` · dec `r2bg_cp1266_decision.json`
R3b: `tail -f /root/logs/r3_train.nohup` · pipe `r3_pipeline.nohup`
R6: `tail -f /root/logs/h101_train.nohup` · dec `h101_decision.json`
Fleet: `tail -f experiments/fleet-rent/logs/wait_fleet_b300.log`
Boot: `tail -f experiments/fleet-rent/logs/wait_bootstrap_fleet.log`
**p2137:** fleet→**api-unfiltered-8x** pid**2771543** (no rent on /pods fail; 1× GET/iter); B300×8=0; burn **$180.25/h**.

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.

## Next action
**Rent:** snatch via api-unfiltered-8x pid2771543 (R7 first). Bootstrap auto-arms.
**Crown:** wait R2bg n80 → `r2bg_cp1266_decision.json`.
**R3b:** wait train.done → merge/n80 → `r3b_decision.json`.
**R6:** wait train.done → merge/n80 → `h101_decision.json`.
