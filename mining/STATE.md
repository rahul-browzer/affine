# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage
**Stage 4 — beat the king; parallel axes.** Reason v3 · win the subnet.
Burn floor **≥$833/h** on mine-* 8×B300 (operator 2026-08-11).

## Live facts

| item | value |
|---|---|
| contract | wvk=**3** · `k_sigma=2.0` · reason_only · n_turns=2080 |
| king | `tolegend/Affine-5fqbxvz29b-ckp333` @ `24c137e8…` **reign 5** (crowned 01:17Z) |
| challenge | chal-00502 scoring; queue +chal-00504… |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 (API empty) |
| Lium bal | ~$119,611 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2bj** n80 ~50/80 + **R9** LoRA ~76/354; **king→ckp333 retarget armed** |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R3b** GRPO ~step69 |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R8** REINFORCE ~step42 GPUs6–7 |
| host fleet-rent | pid**2919638** | — | api-POST-rent; next=**R7** |
| host fleet-boot | pid**2756348** | — | POLL=5s / 86400iters |
| host hist bridge | pid**2925457** | — | crowned-event fix; +chal-00501 stamped |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3/R3b: `ssh root@204.9.206.245 -p 40051`
SSH R4/R8: `ssh root@86.38.182.50 -p 40307`
R2bj: `tail -f /root/logs/r2bj_saysth_reason_sim.log` · dec `r2bj_saysth_decision.json`
King retarget: `tail -f /root/logs/retarget_king_tolegend_ckp333.log` · done `retarget_king_tolegend_ckp333.done`
Prefetch: `tail -f /root/logs/r2_prefetch_ckp333.log` (hub was evicted; re-download live)
R9: `tail -f /root/logs/h99_train.nohup` · gate post_train on R2bj terminal
R3b: `tail -f /root/logs/r3_train.nohup` · pipe `r3_pipeline.nohup`
R8: `tail -f /root/logs/r8_train.nohup` · post `/root/logs/r8_post_train.nohup` · dec `r8_decision.json`
Fleet: `tail -f experiments/fleet-rent/logs/wait_fleet_b300.log`
**p2152:** reign-5 king swap; crown prefetch+retarget armed; bridge accepts `crowned`; B300×8=0; burn **$180.25/h**.

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.

## Next action
**Rent:** snatch via api-POST-rent (R7 first). Bootstrap auto-arms.
**Crown:** wait R2bj → king retarget DONE → R9 post_train n80 vs **ckp333**.
**R8/R3b:** patch post_train `KING_REPO`→ckp333 before their n80 (still Tok defaults).
**Fleet:** keep snatcher; axes still R7,R24… when stock returns.
