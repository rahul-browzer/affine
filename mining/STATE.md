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
| challenge | chal-00501 scoring; queue +chal-00516 IntoLayer |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 · fleet **api-POST-rent** pid**2784801** |
| Lium bal | ~$119,861 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2bh** IntoLayer n80 ~40/80 |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R3b** GRPO ~step42 |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R6b** long-z LoRA train (post R6 REFUTE) |
| host fleet-rent | pid**2784801** | — | **api-POST-rent** (cap-protect + CLI fallback) |
| host fleet-boot | pid**2756348** | — | POLL=5s / 86400iters |
| host hist bridge | pid**2777023** | — | +chal-00516 |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3/R3b: `ssh root@204.9.206.245 -p 40051`
SSH R4/R6b: `ssh root@86.38.182.50 -p 40307`
R2bh: `tail -f /root/logs/r2bh_intolayer_reason_sim.log` · dec `r2bh_intolayer_decision.json`
R3b: `tail -f /root/logs/r3_train.nohup` · pipe `r3_pipeline.nohup`
R6b: `tail -f /root/logs/h101_train.nohup` · post `h101_post_train.nohup` · dec `h101_decision.json`
Fleet: `tail -f experiments/fleet-rent/logs/wait_fleet_b300.log`
**p2143:** R6 short REFUTE (m=−0.0006 z=−0.07); **R6b** armed warm TKC GPUs6–7; B300×8=0; burn **$180.25/h**.

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.

## Next action
**Rent:** snatch via api-POST-rent pid2784801 (R7 first). Bootstrap auto-arms.
**R6b:** wait train.done → merge/n80 → `h101_decision.json`.
**Crown:** wait R2bh n80 → `r2bh_intolayer_decision.json`.
**R3b:** wait train.done → merge/n80 → `r3b_decision.json`.
