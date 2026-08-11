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
| challenge | chal-00495 (scoring) |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 · fleet **blind-fire** POLL=0 |
| Lium bal | ~$120,675 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2bb** n80 ~**60/80** |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | GRPO pid28660 step≥**129** + wedge |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R4** train 26/26 → **writing shards** + post_train |
| host fleet-rent | pid**2471342** | — | blind-fire →25 @POLL=0 (R5…) |
| host fleet-boot | pid**2463724** | — | auto-upload @5s; R4 done; next R5 |
| host r3-wedge | pid**2176107** | — | GRPO wedge relaunch |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307`
R2bb: `tail -f` crown `/root/logs/r2bb_ckp333_reason_sim.log`
R4: `tail -f` `/root/logs/h121_{train,post_train}.nohup`
Fleet: `tail -f experiments/fleet-rent/logs/wait_{fleet_b300,bootstrap_fleet}.log`

## Blocked
No free 8×B300/B200. p2111: skip `stock_ok` (blind-fire `lium up`); 90s burst 41 tries miss. Next rent = **R5**.

## Next action
**Rent:** snatch next B300 → `mine-r5-nonking-1` (blind-fire@0).
**R4:** wait `train.done` → merge → n80 (post_train armed).
**Crown:** R2bb n80 → decision; if WEAK/REFUTE arm **R2bc**.
**R3:** train.done→n80 (step≥129/200).
