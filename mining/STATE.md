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
| B300 stock | **0** free 8×B300/B200 · fleet rent@**10s** |
| Lium bal | ~$120,735 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2bb** n80 pid**199154** (~20/80) |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | GRPO pid28660 step≥**115** + wedge |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **NEW** R4 full-FT bootstrap pid**1374** |
| host fleet-rent | pid**2448500** | — | →25 mines @10s (R5…R32) |
| host fleet-boot | pid**2448503** | — | auto-upload; R4 done; R32 armed |
| host r3-wedge | pid**2176107** | — | GRPO wedge relaunch |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307`
R2bb: `tail -f` crown `/root/logs/r2bb_ckp333_reason_sim.log`
R4: `tail -f` `/root/logs/bootstrap_h121.log` / pipeline nohup
Fleet: `tail -f experiments/fleet-rent/logs/wait_{fleet_b300,bootstrap_fleet}.log`

## Blocked
No free 8×B300/B200 after R4 snatch. **R32** KL armed for next B300.

## Next action
**Crown:** R2bb n80 → decision; if WEAK/REFUTE arm **R2bc** ec08 then ckp55.
**R3:** train.done→n80 (step≥100/200; now ≥115).
**R4:** wait bootstrap→full-FT train→n80.
**Else:** fleet snatch next B300 (R5…; **R32** KL queued after R31).
