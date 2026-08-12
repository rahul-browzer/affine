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
| B300 stock | **0** free 8×B300/B200 (API empty; only 1×B300/1×B200) |
| Lium bal | ~$119,506 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2bk** n80~25/80 saysth vs ckp333; **R9** LoRA ~125/354; **R2bl** waits R2bk |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R3b** GRPO ~step85/200; post→ckp333 |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R8** n80~17/80 vs ckp333 (train DONE) |
| host fleet-rent | pid**2919638** | — | api-POST-rent; next=**R7** |
| host fleet-boot | pid**2756348** | — | POLL=5s |
| host hist bridge | pid**2964435** | — | +chal-00520 map |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R8: `ssh root@86.38.182.50 -p 40307`
**R2bj** vs Tok: m=+0.00427 z=0.80 hr0.27× → SIGNAL_POS (not crown).
R2bk: `tail -f /root/logs/r2bk_saysth_ckp333_reason_sim.log` · dec `r2bk_saysth_ckp333_decision.json`
R2bl: waits R2bk; prefetch Bittoby v3 armed
R9: train `h99_train.nohup`; post waits train→R2bk→**R2bl**→merge→n80
R8: `tail -f /root/logs/r8_post_train.nohup` · prog `/root/affine_data/r8_sim_progress.json` · dec `r8_decision.json`
R3b: `tail -f /root/logs/r3_train.nohup`
Fleet: `tail -f experiments/fleet-rent/logs/wait_fleet_b300.log`
**p2157:** R8 train→merge→ckp333 serve→**n80 launched** (~17/80); B300×8=0; burn **$180.25/h**.

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.

## Next action
**Rent:** snatch via api-POST-rent (R7 first). Bootstrap auto-arms.
**R8:** wait n80 → `r8_decision.json` (Stage-5 only if margin >1.5×(2·SE) vs ckp333).
**Crown:** wait R2bk decision; if weak → R2bl Bittoby n80; then R9 merge→n80.
**R3b:** wait train.done → merge → RESTART_KING ckp333 → n80.
**Fleet:** keep snatcher; axes R7,R24… when stock returns.
