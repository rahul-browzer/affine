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
| challenge | chal-00495 (scoring) |
| miner burn | **$180.25/h** · floor $833/h · **gap −$653/h** |
| B300 stock | **0** free 8×B300/B200 · fleet **blind-fire** POLL=0 |
| Lium bal | ~$120,654 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2bb DONE** WEAK (live); next **R2bc** |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | GRPO pid28660 step≥**133**/200 + wedge |
| mine-r4-fullft-1 | noble-orbit-9d | $64.00 | **R4** salvaged → finalize OK → **serve_three** |
| host fleet-rent | pid**2471342** | — | blind-fire →25 @POLL=0 (R5…) |
| host fleet-boot | pid**2463724** | — | auto-upload @5s; next R5 |

SSH crown: `ssh root@95.133.253.90 -p 40099` · R3: `ssh root@204.9.206.245 -p 40051`
SSH R4: `ssh root@86.38.182.50 -p 40307`
R4: `tail -f` `/root/logs/h121_{pipeline,post_train}.nohup` + vllm_*.log
R2bb: `artifacts/r2bb_ckp333_decision_p2112.json` · arm R2bc next
Fleet: `tail -f experiments/fleet-rent/logs/wait_{fleet_b300,bootstrap_fleet}.log`

## Blocked
No free 8×B300/B200. p2112: 90s R5 burst 53 miss. Next rent = **R5**.

## Next action
**Rent:** snatch next B300 → `mine-r5-nonking-1` (blind-fire@0).
**R4:** wait serve_three healthy → n80 (watcher armed).
**Crown:** arm **R2bc** (R2bb live-clear but hr1.25× <1.5× submit).
**R3:** train.done→n80 (step≥133/200).
