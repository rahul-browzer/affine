# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage
**Stage 4 — beat the king; parallel axes.** Reason v3 · win the subnet.
Burn floor **≥$833/h** on mine-* 8×B300 (operator 2026-08-11).

## Live facts

| item | value |
|---|---|
| contract | wvk=**3** · `k_sigma=2.0` · reason_only · n_turns=2080 |
| king | `tolegend/Affine-5fqbxvz29b-ckp333` @ `24c137e8…` **reign 5** |
| challenge | chal-00511 scoring; queue +chal-00514…**00521** (all R2-screened) |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 (API) |
| Lium bal | ~$119,089 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R9** LoRA ~288/354; post armed (R2bm cleared) |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R3b** GRPO ~step136/200; king ckp333 READY |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R12** BoN-CE train ~step5/150; post→ckp333 |
| host fleet-rent | pid**2978630** | — | api-POST-rent; next=**R24** |
| host fleet-boot | pid**2756348** | — | POLL=5s |
| host hist bridge | pid**3080195** | — | +chal-00521 map |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4/R12: `ssh root@86.38.182.50 -p 40307`
**p2176:** **R2bm REFUTE** m=−0.0057 z=−1.49 hr−0.74× vs ckp333; R9 gate unlocked.
R9: `tail -f /root/logs/h99_train.nohup` · post `/root/logs/r9_post_train.nohup`
R12: `tail -f /root/logs/h137_train.nohup` · post `/root/logs/r12_post_train.nohup`
R3b: `tail -f /root/logs/r3_train.nohup` · Soft 15:29Z / Dead 15:59Z
Fleet: `tail -f experiments/fleet-rent/logs/wait_fleet_b300.log`

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.
R10: need Hub access to `ammazon/…-sbs-v2` (or public merge parent).
Queue parents through chal-00521 all screened (no new board parent).

## Next action
**R9:** wait train.done → merge → n80 vs ckp333 (hr≥1.5×).
**R12:** wait train.done → merge → n80 vs ckp333.
**R3b:** wait train.done → merge → n80.
**Rent:** snatch via api-POST-rent (**R24** first). Bootstrap auto-arms.
