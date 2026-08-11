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
| challenge | chal-00497 scoring; queue 502/504/508/511… |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 · fleet **blind-fire** →`mine-r6-fmt-1` |
| Lium bal | ~$120,383 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | TK; **R2be** n80 ~15/80; **R2bf** dpo2 prefetch+waiter |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **train.done** → LoRA merge → chall → n80 |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R5** Genesis full-FT step≥5/26 |
| host fleet-rent | pid**2597099** | — | blind-fire →25 @POLL=0 next=R6 |
| host fleet-boot | pid**2463724** | — | auto-upload @5s |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4/R5: `ssh root@86.38.182.50 -p 40307`
R2be: `tail -f /root/logs/r2be_hope12_reason_sim.log` · dec `r2be_hope12_decision.json`
R2bf: `tail -f /root/logs/r2_prefetch_dpo2.log` · waiter `r2bf_dpo2_reload.log`
R3: `tail -f /root/logs/r3_pipeline.nohup` · dec `r3_decision.json` / `affine_data/r3_sim_result.json`
R5: `tail -f /root/logs/h122_train.nohup` · then `h122_decision.json`
Fleet: `tail -f experiments/fleet-rent/logs/wait_{fleet_b300,bootstrap_fleet}.log`
**p2121:** armed R2bf trangd dpo2@90ea78ff (chal-00511) while R2be flies; R3 train DONE→merge.

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.

## Next action
**Rent:** snatch next B300 → `mine-r6-fmt-1` (blind-fire@0).
**R3:** wait merge→chall reload→n80 decision.
**Crown:** wait R2be n80 → decision; else R2bf auto-serve (prefetch armed).
**R5:** wait full-FT → post_train→n80 (`h122_decision.json`).
