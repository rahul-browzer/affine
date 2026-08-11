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
| challenge | chal-00491 (hope11 load) |
| miner burn | **$116.25/h** (B300 $64 + B200 $52.25) · floor $833/h · **gap −$717/h** |
| B300 stock | **0** free 8×B300/B200 · **fleet rent waiter** target=13 |
| Lium bal | ~$121,201 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2ax** n80 ~46/80; R2ay→R2az; **v10 cached** |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **GRPO** pid23755 step≥25 mean_r≈0.001; T+K live |
| host fleet | pid**2146782** | — | `wait_fleet_b300.sh` → rent R4…R10 until 13 mines |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051` · TTL→2026-08-12T16:29Z
Fleet log: `tail -f experiments/fleet-rent/logs/wait_fleet_b300.log`
R2ax: `cat /root/affine_data/r2ax_tt_reason_progress.json`
R3: `grep r3-log /root/logs/r3_train.nohup | tail`

## Blocked

- No free 8×B300/B200 — fleet polls 30s (target 13 mines / cap 25).
- Do not serialize more pure board-copies as the only parallelism.

## Next action

**If `fleet-rent/artifacts/rented_*.json`:** bootstrap that axis (R4 full-FT first).
**Crown:** R2ax→R2ay→R2az→pure awesome-v10 n80 (weights cached).
**R3:** watch GRPO → `train.done` → post_train merge+chall+n80.
