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
| B300 stock | **0** free 8×B300/B200 · fleet blind-fire →`mine-r6-fmt-1` |
| Lium bal | ~$120,237 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2bf** n80 live (~10/80) dpo2@90ea78ff |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R3** n80 live (~19/80) after p2125 unblock |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R5 REFUTE** m=−0.039 z=−3.24 — retarget next |
| host fleet-rent | pid**2597099** | — | blind-fire →25 @POLL=0 next=R6 |
| host fleet-boot | pid**2463724** | — | auto-upload @5s |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4/R5: `ssh root@86.38.182.50 -p 40307`
R2bf: `tail -f /root/logs/r2bf_dpo2_reload.log` · dec `r2bf_dpo2_decision.json`
R3: `tail -f /root/logs/r3_sim.nohup` · prog `r3_sim_progress.json` · dec `r3_decision.json`
R5 done: `/root/affine_data/h122_decision.json` REFUTE_H122
Fleet: `tail -f experiments/fleet-rent/logs/wait_{fleet_b300,bootstrap_fleet}.log`
**p2125:** R3 n80 was aborted (no PYTHONPATH + stale `run_sim_duel` needing turns.jsonl). Patched resume + scp'd schema-v2 sim; n80 gathering. R5 REFUTE stamped. B300×8=0.

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.

## Next action
**Rent:** snatch next B300 → `mine-r6-fmt-1` (blind-fire@0).
**R4 pod:** retarget idle `mine-r4-fullft-1` → R6 thought-format (R5 closed).
**R3:** wait n80 → `r3_decision.json`.
**Crown:** wait R2bf n80 → decision.
