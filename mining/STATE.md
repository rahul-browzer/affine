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
| challenge | chal-00502 scoring (~1328/2080); queue +chal-00504…**00520** |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 (API; only 1× singles) |
| Lium bal | ~$119,423 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2bk REFUTE** m=+0.0004 z=0.13; **R2bl** Bittoby :8002 loading→n80; **R9** LoRA ~160/354 |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R3b** GRPO ~step93/200; post→ckp333 |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R7** train DONE; TKC serving; n80 watcher→ckp333 |
| host fleet-rent | pid**2978630** | — | api-POST-rent; next=**R24** |
| host fleet-boot | pid**2756348** | — | POLL=5s |
| host hist bridge | pid**2964435** | — | +chal-00520 map |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R7: `ssh root@86.38.182.50 -p 40307`
**p2160:** R2bk CLOSED (noise vs ckp333); fixed R2bl R9-premerge deadlock → Bittoby reload.
R2bl: `tail -f /root/logs/r2bl_bittoby_v3_reload.log` · dec `r2bl_bittoby_v3_decision.json`
R9: train `h99_train.nohup`; post waits train→**R2bl**→merge→n80
R7: `tail -f /root/logs/vllm_*.log` · retry n80 · dec `h121_decision.json`
R3b: `tail -f /root/logs/r3_train.nohup`
Fleet: `tail -f experiments/fleet-rent/logs/wait_fleet_b300.log`

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.

## Next action
**Rent:** snatch via api-POST-rent (**R24** first). Bootstrap auto-arms.
**R2bl:** wait Bittoby serve→n80 vs ckp333 → decision (Stage-5 only if hr≥1.5×(2·SE)).
**R7:** wait engines ready→n80 vs ckp333 → `h121_decision.json`.
**R9:** wait train→R2bl terminal→merge→n80.
**R3b:** wait train.done → merge → RESTART_KING ckp333 → n80.
**Fleet:** keep snatcher; axes R24… when stock returns.
