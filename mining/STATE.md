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
| B300 stock | **0** free 8×B300/B200 · fleet rent+bootstrap armed |
| Lium bal | ~$121,138 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2ax REFUTE** m−0.0062; **R2ay** n80 ~10/80; R2az armed; v10 cached |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **GRPO** pid**26401** (p2070 relaunch) step≥10; T+K live |
| host fleet-rent | pid**2146782** | — | `wait_fleet_b300.sh` → rent R4… until 13 mines |
| host fleet-boot | pid**2153833** | — | `wait_bootstrap_fleet.sh` → auto R4 upload on rent |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051` · TTL→2026-08-12T16:29Z
Fleet rent: `tail -f experiments/fleet-rent/logs/wait_fleet_b300.log`
Fleet boot: `tail -f experiments/fleet-rent/logs/wait_bootstrap_fleet.log`
R2ay: `cat /root/affine_data/r2ay_sbs_v2_reason_progress.json`
R3: `grep r3-log /root/logs/r3_train.nohup | tail`

## Blocked

- No free 8×B300/B200 — rent polls 30s (target 13 / cap 25).
- Do not serialize more pure board-copies as the only parallelism.

## Next action

**If `fleet-rent/artifacts/bootstrapped/rented_mine-r4-fullft-1.json.bootstrapped`:**
watch R4 train (`/root/logs/bootstrap_h121.log` / `h121_train.nohup`).
**Else if `rented_*.json` without bootstrapped:** check fleet-boot log (should auto).
**Crown:** R2ay finish → R2az → pure awesome-v10 n80.
**R3:** GRPO → `train.done` → post_train merge+chall+n80; if no new `r3-log` ~5m after a `%5` step + CLOSE-WAIT to :8000, kill-by-PID + `start_r3.sh` (now appends log).
