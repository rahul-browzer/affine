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
| challenge | chal-00514 scoring; queue +…**00525** |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 (p2189 700-iter burst) |
| Lium bal | ~$118,609 · floor $10k OK |
| submissions | 0 |
| R9 | **REFUTE** m=−0.0172 z=−3.36 hr−1.68× (p2189) |
| R13 | **REFUTE** m=−0.0191 z=−2.86 hr−1.43× (p2189) |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **idle TKC** after R9 REFUTE (warm :8000/1/2) |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **R3b** n80 vs ckp333 (just launched p2189) |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **idle** after R13 REFUTE — next axis |
| host fleet-rent | pid**3164256** | — | api-POST-rent; next=**R24** |
| host fleet-boot | pid**2756348** | — | POLL=5s |
| host hist bridge | pid**3174953** | — | +chal-00525 |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307`
R3b: `cat /root/affine_data/r3_sim_progress.json` · `tail -f /root/logs/r3_sim.nohup`
Fleet: `tail -f experiments/fleet-rent/logs/wait_fleet_b300.log`
Crown Removal **2026-08-13T02:35:59Z**. R4 Removal **2026-08-12T20:57Z**.

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.
R10: need Hub access to `ammazon/…-sbs-v2` (or public merge parent).

## Next action
**Rent:** snatch via api-POST-rent (**R24** first); pass-burst = `SKIP_PID_LOCK=1` + SIGSTOP long waiter.
**R3b:** wait n80 decision (hr≥1.5× live 2σ) → Stage-5 if ADVANCE.
**Crown + R4:** warm-arm distinct open axes (not R9/R13/R12/R11 refuted family) while fleet snatches.
