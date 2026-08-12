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
| challenge | chal-00501 scoring; queue +chal-00502…517 |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 (API empty) |
| Lium bal | ~$119,652 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2bj** n80 ~25/80 + **R9** LoRA ~65/354 |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R3b** GRPO ~step66 |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R8** REINFORCE loading GPUs6–7 (R6b REFUTE) |
| host fleet-rent | pid**2919638** | — | api-POST-rent; next=**R7** (R8 dequeued) |
| host fleet-boot | pid**2756348** | — | POLL=5s / 86400iters |
| host hist bridge | pid**2860424** | — | +chal-00517 |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3/R3b: `ssh root@204.9.206.245 -p 40051`
SSH R4/R8: `ssh root@86.38.182.50 -p 40307`
R2bj: `tail -f /root/logs/r2bj_saysth_reason_sim.log` · dec `r2bj_saysth_decision.json`
R9: `tail -f /root/logs/h99_train.nohup` · gate post_train on R2bj terminal
R3b: `tail -f /root/logs/r3_train.nohup` · pipe `r3_pipeline.nohup`
R8: `tail -f /root/logs/r8_train.nohup` · post `/root/logs/r8_post_train.nohup` · dec `r8_decision.json`
Fleet: `tail -f experiments/fleet-rent/logs/wait_fleet_b300.log`
**p2151:** R6b n80 REFUTE m=−0.010 z=−1.23 → lean-armed **R8** on warm r4; B300×8=0; burn **$180.25/h**.

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.

## Next action
**Rent:** snatch via api-POST-rent (R7 first). Bootstrap auto-arms.
**R8:** wait train.done → merge/n80 → `r8_decision.json`.
**Crown:** wait R2bj n80 → `r2bj_saysth_decision.json`.
**R9:** wait train.done (gate post_train on R2bj decision).
**R3b:** wait train.done → merge/n80 → `r3b_decision.json`.
