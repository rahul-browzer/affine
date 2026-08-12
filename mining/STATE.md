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
| challenge | chal-00501 scoring; queue +chal-00517 thrivepath mt2 |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 · fleet **api-POST-rent** pid**2840405** |
| Lium bal | ~$119,757 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2bi** mt2 chall :8002 loading → n80 + **R9** LoRA ~step30/354 |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R3b** GRPO ~step56 |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R6b** long-z LoRA ~step90/132 |
| host fleet-rent | pid**2840405** | — | **api-POST-rent** (R7 next) |
| host fleet-boot | pid**2756348** | — | POLL=5s / 86400iters |
| host hist bridge | pid**2860424** | — | +chal-00517 |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3/R3b: `ssh root@204.9.206.245 -p 40051`
SSH R4/R6b: `ssh root@86.38.182.50 -p 40307`
R2bi: `tail -f /root/logs/r2bi_mt2_reload.log` · dec `r2bi_mt2_decision.json`
R9: `tail -f /root/logs/h99_train.nohup` · gate post_train on R2bi terminal
R3b: `tail -f /root/logs/r3_train.nohup` · pipe `r3_pipeline.nohup`
R6b: `tail -f /root/logs/h101_train.nohup` · post `h101_post_train.nohup` · dec `h101_decision.json`
Fleet: `tail -f experiments/fleet-rent/logs/wait_fleet_b300.log`
**p2146:** R2bi self-PID wait bug fixed → chall killed → mt2 vLLM :8002 pid266179; B300×8=0; burn **$180.25/h**.

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.

## Next action
**Rent:** snatch via api-POST-rent pid2840405 (R7 first). Bootstrap auto-arms.
**Crown:** wait R2bi chall PROMPTABLE → n80 → `r2bi_mt2_decision.json` (Glm4Moe may UNSERVABLE).
**R9:** wait train.done (gate post_train on R2bi decision).
**R6b:** wait train.done → merge/n80 → `h101_decision.json`.
**R3b:** wait train.done → merge/n80 → `r3b_decision.json`.
