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
| challenge | chal-00508 scoring (~1271/2080); queue +chal-00511…**00521** |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 (API; only 1×) |
| Lium bal | ~$119,193 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2bm n80** ~10/80; R9 LoRA ~242/354 |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R3b** GRPO ~step114/200; king ckp333 READY |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R11** online-DPO ~step85/150; Soft 19:57Z |
| host fleet-rent | pid**2978630** | — | api-POST-rent; next=**R24** |
| host fleet-boot | pid**2756348** | — | POLL=5s |
| host hist bridge | pid**3080195** | — | +chal-00521 map |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4/R11: `ssh root@86.38.182.50 -p 40307`
**p2170:** R9 `post_train_pipeline.sh` +**R2bm gate** (host+pod) so merge cannot yank `:8002` mid-n80; SKIP if R2bm hr≥1.5×.
R2bm: `tail -f /root/logs/r2bm_tttt_guass_reason_sim.log` · prog `r2bm_tttt_guass_reason_progress.json` · dec `r2bm_tttt_guass_decision.json`
R9: train `h99_train.nohup`; post waits train.done → **R2bm terminal** →merge→n80
R11: `tail -f /root/logs/h139_train.nohup` · post `r11_post_train.nohup`
R3b: `tail -f /root/logs/r3_train.nohup` · Soft 15:29Z / Dead 15:59Z
Fleet: `tail -f experiments/fleet-rent/logs/wait_fleet_b300.log`

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.
R10: need Hub access to `ammazon/…-sbs-v2` (or public merge parent).

## Next action
**R2bm:** wait n80 → decision (ADVANCE iff hr≥1.5× vs live 2σ).
**R9:** after train.done, gate holds for R2bm then merge→n80 (or SKIP if R2bm clears).
**Rent:** snatch via api-POST-rent (**R24** first). Bootstrap auto-arms.
**R3b / R11:** wait train.done → merge → n80 vs ckp333.
**Fleet:** keep snatcher; axes R24… when stock returns.
