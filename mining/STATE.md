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
| challenge | chal-00508 scoring; queue +chal-00504…**00520** |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 (API; only 1×) |
| Lium bal | ~$119,277 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R9** LoRA ~214/354; post armed (R2bl done) |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R3b** GRPO ~step108/200; **king ckp333 READY** |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R11** online-DPO LIVE (~step49/150); post armed |
| host fleet-rent | pid**2978630** | — | api-POST-rent; next=**R24** |
| host fleet-boot | pid**2756348** | — | POLL=5s |
| host hist bridge | pid**2964435** | — | +chal-00520 map |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4/R11: `ssh root@86.38.182.50 -p 40307`
**p2166:** **R2bl REFUTE** Bittoby vs ckp333 n80 m=−0.00204 z=−0.48 hr=−0.24×(2σ) — Stage-5 SKIP; R9 unblocked.
R9: train `h99_train.nohup`; post →merge→n80 (no R2bl wait)
R11: `tail -f /root/logs/h139_train.nohup` · post `r11_post_train.nohup`
R3b: `tail -f /root/logs/r3_train.nohup` · preswap `.done` → post skips king reload
Fleet: `tail -f experiments/fleet-rent/logs/wait_fleet_b300.log`

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.
R10: need Hub access to `ammazon/…-sbs-v2` (or public merge parent).

## Next action
**Rent:** snatch via api-POST-rent (**R24** first). Bootstrap auto-arms.
**R9:** wait train.done → merge → n80 vs ckp333 (decision k=2).
**R3b:** wait train.done → merge → chall reload (king already ckp333) → n80.
**R11:** wait train.done → merge → n80 vs ckp333.
**Fleet:** keep snatcher; axes R24… when stock returns.
