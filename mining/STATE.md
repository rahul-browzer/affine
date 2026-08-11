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
| challenge | chal-00498 scoring; queue 502/504/508/511… |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 · fleet blind-fire →`mine-r6-fmt-1` |
| Lium bal | ~$120,299 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | TK; **R2be** n80 ~60/80; R2bf waiter |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **merged+visual graft** → chall :8002 loading → n80 |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R5** engines 200; **n80 retry armed** (was missing) |
| host fleet-rent | pid**2597099** | — | blind-fire →25 @POLL=0 next=R6 |
| host fleet-boot | pid**2463724** | — | auto-upload @5s |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4/R5: `ssh root@86.38.182.50 -p 40307`
R2be: `tail -f /root/logs/r2be_hope12_reason_sim.log` · dec `r2be_hope12_decision.json`
R3: `tail -f /root/logs/r3_resume_p2123.nohup` · MERGED=`/tmp/r3_merged` · dec `r3_decision.json`
R5: `tail -f /root/logs/h122_n80_retry.nohup` · dec `h122_decision.json` · **chall still 32768**
Fleet: `tail -f experiments/fleet-rent/logs/wait_{fleet_b300,bootstrap_fleet}.log`
**p2123:** R3 merge `save_file` Bad address → graft 333 visual via `/root` then copy; resume chall@65536→n80. Armed R5 n80 (watcher was absent).

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.

## Next action
**Rent:** snatch next B300 → `mine-r6-fmt-1` (blind-fire@0).
**R3:** wait chall health → n80 → `r3_decision.json`.
**Crown:** wait R2be n80 → decision; else R2bf auto-serve.
**R5:** wait n80; if ContextLengthError, relaunch chall **65536** then retry.
