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
| B300 stock | **0** free 8×B300/B200 (API; only 1×B300) |
| Lium bal | ~$119,464 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2bk** n80~50/80 saysth vs ckp333; **R9** LoRA ~140/354; **R2bl** waits R2bk |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R3b** GRPO ~step88/200; post→ckp333 |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R7** top-250 FT ~10/28; n80 defaults→ckp333 |
| host fleet-rent | pid**2978630** | — | api-POST-rent; next=**R24** |
| host fleet-boot | pid**2756348** | — | POLL=5s |
| host hist bridge | pid**2964435** | — | +chal-00520 map |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R7: `ssh root@86.38.182.50 -p 40307`
**p2159:** patched R7 `retry_*_n80` defaults Tok→ckp333 (pod+local); `mine.env` already OK.
R2bk: `tail -f /root/logs/r2bk_saysth_ckp333_reason_sim.log` · dec `r2bk_saysth_ckp333_decision.json`
R2bl: waits R2bk; Bittoby v3 prefetch armed
R9: train `h99_train.nohup`; post waits train→R2bk→**R2bl**→merge→n80
R7: `tail -f /root/logs/h121_train.nohup` · post `r7_post_train.nohup` · dec `h121_decision.json`
R3b: `tail -f /root/logs/r3_train.nohup`
Fleet: `tail -f experiments/fleet-rent/logs/wait_fleet_b300.log`

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.

## Next action
**Rent:** snatch via api-POST-rent (**R24** first). Bootstrap auto-arms.
**R7:** wait train→post→n80 vs ckp333 → `h121_decision.json` (Stage-5 only if hr≥1.5×(2·SE)).
**Crown:** wait R2bk decision; if weak → R2bl Bittoby n80; then R9 merge→n80.
**R3b:** wait train.done → merge → RESTART_KING ckp333 → n80.
**Fleet:** keep snatcher; axes R24… when stock returns.
