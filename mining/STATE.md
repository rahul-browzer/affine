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
| Lium bal | ~$119,298 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2bl** Bittoby n80 ~63/80; **R9** LoRA ~205/354 |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R3b** GRPO ~step105/200; **king ckp333 READY** |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R11** online-DPO LIVE (~step35/150); post armed |
| host fleet-rent | pid**2978630** | — | api-POST-rent; next=**R24** |
| host fleet-boot | pid**2756348** | — | POLL=5s |
| host hist bridge | pid**2964435** | — | +chal-00520 map |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4/R11: `ssh root@86.38.182.50 -p 40307`
**p2165:** patched `write_reason_decision.py` → live **k_sigma=2.0** + `headroom_vs_live_2se` on crown/R3/R11 (was defaulting 3.0; R2bl decision path).
R2bl: `tail -f /root/logs/r2bl_bittoby_v3_reason_sim.log` · dec `r2bl_bittoby_v3_decision.json`
R11: `tail -f /root/logs/h139_train.nohup` · post `r11_post_train.nohup`
R9: train `h99_train.nohup`; post waits train→**R2bl**→merge→n80
R3b: `tail -f /root/logs/r3_train.nohup` · preswap `.done` → post skips king reload
Fleet: `tail -f experiments/fleet-rent/logs/wait_fleet_b300.log`

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.
R10: need Hub access to `ammazon/…-sbs-v2` (or public merge parent).

## Next action
**Rent:** snatch via api-POST-rent (**R24** first). Bootstrap auto-arms.
**R2bl:** wait n80 → decision (now k=2). If ADVANCE → Stage-5 path.
**R3b:** wait train.done → merge → chall reload (king already ckp333) → n80.
**R11:** wait train.done → merge → n80 vs ckp333.
**R9:** wait train→R2bl terminal→merge→n80 (TTL OK to 14:36Z).
**Fleet:** keep snatcher; axes R24… when stock returns.
