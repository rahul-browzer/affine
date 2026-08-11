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
| challenge | chal-00491 (hope11 load) |
| miner burn | **$116.25/h** (B300 $64 + B200 $52.25) · floor $833/h · **gap −$717/h** |
| B300 stock | **0** free 8×B300 · fleet rent+bootstrap armed |
| Lium bal | ~$121,061 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2ay** n80 ~77/80; R2az waiter; v10 cached |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **GRPO** pid28660 step≥13 (mean_r≈0.036); T+K live |
| host fleet-rent | pid**2146782** | — | `wait_fleet_b300.sh` → rent R4… until 13 mines |
| host fleet-boot | pid**2228441** | — | `wait_bootstrap_fleet.sh` → **R4–R8 + R3b** auto-upload |
| host r3-wedge | pid**2176107** | — | `watch_r3_wedge.sh` stale>600s+CWAIT+no ESTAB → relaunch |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051` · TTL→2026-08-12T16:29Z
Fleet rent: `tail -f experiments/fleet-rent/logs/wait_fleet_b300.log`
Fleet boot: `tail -f experiments/fleet-rent/logs/wait_bootstrap_fleet.log`
R3 wedge: `tail -f experiments/r3-reason-grpo/logs/watch_r3_wedge.log`
R2ay: `cat /root/affine_data/r2ay_sbs_v2_reason_progress.json`
R3: `grep -E 'r3-log|r3-hb' /root/logs/r3_train.nohup | tail`

## Blocked

- No free 8×B300/B200 — rent polls 30s (target 13 / cap 25).
- Do not serialize more pure board-copies as the only parallelism.

## Next action

**If `fleet-rent/artifacts/bootstrapped/rented_mine-r4-fullft-1.json.bootstrapped`:**
watch R4 train (`/root/logs/bootstrap_h121.log` / `h121_train.nohup`).
**If `…rented_mine-r5-nonking-1.json.bootstrapped`:**
watch R5 Genesis FT (`/root/logs/bootstrap_h122.log` / `r5_pipeline.nohup`).
**If `…rented_mine-r6-fmt-1.json.bootstrapped`:**
watch R6 (`/root/logs/bootstrap_h101.log` / `h101_train.nohup` / `r6_train_launched.json`).
**If `…rented_mine-r7-datafilt-1.json.bootstrapped`:**
watch R7 (`/root/logs/bootstrap_h121.log` / `r7_pipeline.nohup` / `r7_train_launched.json`).
**If `…rented_mine-r8-reinforce-1.json.bootstrapped`:**
watch R8 (`/root/logs/bootstrap_r8.log` / `r8_train.nohup` `[r8-hb]`).
**If `…rented_mine-r3-grpo-2.json.bootstrapped`:**
watch R3b (`/root/logs/bootstrap_r3.log` / `r3_train.nohup` `[r3-hb]` · knobs lr=2e-5 r=64 G=8).
**Else if `rented_*.json` without bootstrapped:** check fleet-boot log (should auto R4–R8+R3b).
**R3:** steps→`train.done`→post_train merge+chall+n80 (armed).
**Crown:** R2ay finish → R2az → pure awesome-v10 n80.
**R9+:** still stamp `needs_axis_uploader` until next pass builds them.
