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
| Lium bal | ~$120,279 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2be BELOW bar** (m=+0.004 z=1.0); **R2bf** chall loading |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | chall :8002 loading (~8m) → n80 |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R5** n80 ~42/80 after reseat |
| host fleet-rent | pid**2597099** | — | blind-fire →25 @POLL=0 next=R6 |
| host fleet-boot | pid**2463724** | — | auto-upload @5s |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4/R5: `ssh root@86.38.182.50 -p 40307`
R2bf: `tail -f /root/logs/r2bf_dpo2_reload.log` · dec `r2bf_dpo2_decision.json`
R3: `tail -f /root/logs/r3_resume_p2123.nohup` · MERGED=`/tmp/r3_merged` · dec `r3_decision.json`
R5: `tail -f /root/logs/h122_n80.log` · dec `h122_decision.json` · chall **`/tmp/h122_merged`@65536**
Fleet: `tail -f experiments/fleet-rent/logs/wait_{fleet_b300,bootstrap_fleet}.log`
**p2124:** R5 FALSE_PROBE=404 (symlink serve id) → reseat `/tmp/h122_merged`@65536; n80 live. R2be SIGNAL_POS_BELOW_3SE → R2bf armed. B300×8=0.

## Blocked
No free 8×B300/B200. Cannot hit $833/h burn until stock returns.

## Next action
**Rent:** snatch next B300 → `mine-r6-fmt-1` (blind-fire@0).
**R5:** wait n80 → `h122_decision.json` (should clear FALSE_PROBE now).
**R3:** wait chall health → n80 → `r3_decision.json`.
**Crown:** wait R2bf chall → n80 → decision.
