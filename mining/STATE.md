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
| challenge | chal-00495 |
| miner burn | **$116.25/h** · floor $833/h · **gap −$717/h** |
| B300 stock | **0** free 8×B300/B200 · fleet rent@**10s** |
| Lium bal | ~$120,781 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2bb** ckp333 chall loading → n80 |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | GRPO pid28660 step≥**100** + wedge |
| host fleet-rent | pid**2416934** | — | →25 mines @10s (R4…R29) |
| host fleet-boot | pid**2417447** | — | auto-upload R4–R29 |
| host r3-wedge | pid**2176107** | — | GRPO wedge relaunch |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
R2bb: `tail -f` crown `/root/logs/r2bb_ckp333_reload.log`
Fleet: `tail -f experiments/fleet-rent/logs/wait_{fleet_b300,bootstrap_fleet}.log`

## Blocked
No free 8×B300/B200 — rent polls 10s (target **25** / cap 25). **R29** HiRank armed.

## Next action
**Crown:** R2bb n80 → decision; if WEAK/REFUTE arm **R2bc** ec08 (chal-00502) then ckp55.
**R3:** train.done→n80 (step≥100/200).
**Else:** fleet-boot on B300×8 (R4 first; R29 HiRank queued after R28).
**Else:** next structural axis >R29 (e.g. HiAlpha α=2r alone / EMA-β).
