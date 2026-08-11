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
| challenge | chal-00497 scoring (vvv); queue has 502/504… |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 · fleet **blind-fire** POLL=0 |
| Lium bal | ~$120,612 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2bc** prefetch+reload+n80 (ec08cldg) |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | GRPO step≥**141**/200 + wedge |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | TKC **200/200/200** @65536 · n80 retrying |
| host fleet-rent | pid**2471342** | — | blind-fire →25 @POLL=0 (R5…) |
| host fleet-boot | pid**2463724** | — | auto-upload @5s; next R5 |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307`
R2bc: pids prefetch**200560** / reload**200562** / stage5**200566**
`tail -f /root/logs/{r2_prefetch_ec08,r2bc_ec08_reload,watch_r2bc_stage5_push}.log`
R4: `tail -f /root/logs/{h121_chall_recover_pass264,h121_n80_retry}.nohup`
Fleet: `tail -f experiments/fleet-rent/logs/wait_{fleet_b300,bootstrap_fleet}.log`

## Blocked
No free 8×B300/B200. p2114 rent miss; blind-fire continues. Next rent = **R5**.

## Next action
**Rent:** snatch next B300 → `mine-r5-nonking-1` (blind-fire@0).
**Crown:** wait **R2bc** n80 (`arbosfan/…-ec08cldg@24a3a65e`); then **R2bd** ckp55.
**R4:** n80 gather → decision (engines healthy).
**R3:** train.done→n80 (step≥141/200).
