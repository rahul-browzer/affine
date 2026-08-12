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
| challenge | chal-00502 scoring; queue +chal-00504…**00520** |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 (API empty) |
| Lium bal | ~$119,527 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2bk** n80~15/80 saysth vs ckp333; **R9** LoRA ~112/354; **R2bl** prefetch+wait Bittoby v3 |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R3b** GRPO ~step81/200; post→ckp333 |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R8** REINFORCE ~step184/300; post→ckp333 |
| host fleet-rent | pid**2919638** | — | api-POST-rent; next=**R7** |
| host fleet-boot | pid**2756348** | — | POLL=5s |
| host hist bridge | pid**2964435** | — | +chal-00520 map |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R8: `ssh root@86.38.182.50 -p 40307`
**R2bj** vs Tok: m=+0.00427 z=0.80 hr0.27× → SIGNAL_POS (not crown).
R2bk: `tail -f /root/logs/r2bk_saysth_ckp333_reason_sim.log` · dec `r2bk_saysth_ckp333_decision.json`
R2bl: `tail -f /root/logs/r2_prefetch_bittoby_v3.log` · `/root/logs/r2bl_bittoby_v3_reload.log`
R9: train `h99_train.nohup`; post waits train→R2bk→**R2bl**→merge→n80
R3b/R8: `tail -f /root/logs/r3_train.nohup` · `r8_train.nohup`
Fleet: `tail -f experiments/fleet-rent/logs/wait_fleet_b300.log`
**p2156:** armed R2bl Bittoby v3 (chal-00520); R9 waits R2bl; B300×8=0; burn **$180.25/h**.

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.

## Next action
**Rent:** snatch via api-POST-rent (R7 first). Bootstrap auto-arms.
**Crown:** wait R2bk decision; if weak → R2bl Bittoby n80 (after prefetch) while R9 trains; then R9 merge→n80.
**R8/R3b:** wait train.done → merge → RESTART_KING ckp333 → n80.
**Fleet:** keep snatcher; axes R7,R24… when stock returns.
