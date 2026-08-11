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
| challenge | chal-00493 |
| miner burn | **$116.25/h** · floor $833/h · **gap −$717/h** |
| B300 stock | **0** free 8×B300/B200 · fleet rent+bootstrap armed |
| Lium bal | ~$120,952 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | R2ay WEAK; **R2az** n80 ~73/80 |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | GRPO pid28660 step≥48; wedge-watch |
| host fleet-rent | pid**2296322** | — | rent →**25** mines (R4…R15) |
| host fleet-boot | pid**2296323** | — | auto-upload **R4–R15** |
| host r3-wedge | pid**2176107** | — | GRPO wedge relaunch |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051`
Fleet: `tail -f experiments/fleet-rent/logs/wait_{fleet_b300,bootstrap_fleet}.log`

## Blocked

- No free 8×B300/B200 — rent polls 30s (target **25** / cap 25).

## Next action

**Rented+boot R4–R15:** watch axis train log. **Else:** fleet-boot / rent log.
**R3:** steps→train.done→n80. **Crown:** R2az→decision→v10. **Else:** next axis >R15.
