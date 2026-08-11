# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage
**Stage 4 — beat the king; parallel axes.** Reason v3 · win the subnet.
Burn floor **≥$833/h** on mine-* 8×B300 (operator 2026-08-11).

## Live facts

| item | value |
|---|---|
| contract | wvk=**3** · `k_sigma=2.0` · reason_only · n_turns=2080 |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` reign 4 |
| challenge | chal-00497 scoring; queue 502/504/508/511… |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 · fleet **blind-fire** POLL=0 |
| Lium bal | ~$120,425 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | TK 200; **R2be** hope12 n80 live (`2fe3c39d…`) |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | GRPO step≥**182**/200 |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R4b** train.done; need post_train→n80 |
| host fleet-rent | pid**2471342** | — | blind-fire →25 @POLL=0 |
| host fleet-boot | pid**2463724** | — | auto-upload @5s |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307`
R2be: `tail -f /root/logs/r2be_hope12_reason_sim.log` · dec `r2be_hope12_decision.json`
R4b: `train.done` @22:01Z · check post_train / chall reload
R3: `tail -f /root/logs/r3_train.nohup` · hb `[r3-hb]`
Fleet: `tail -f experiments/fleet-rent/logs/wait_{fleet_b300,bootstrap_fleet}.log`
Crown `/root` freed **1.3T** (p2119 purge); keep GLM+Tok+hope12 only.

## Blocked
No free 8×B300/B200. R2bc+R2bd UNSERVABLE. False FALSE_PROBE@22:11 archived (accidental :8002 kill).

## Next action
**Rent:** snatch next B300 → `mine-r5-nonking-1` (blind-fire@0).
**Crown:** wait R2be n80 → `r2be_hope12_decision.json` (retry after disk fix).
**R4b:** kick/verify post_train→fresh n80 on new full-FT weights.
**R3:** train.done→n80 (step≥182/200).
