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
| challenge | chal-00491 (hope11 load) · queue 492–504 + awesome-v10/ckp333/ckp55 |
| miner burn | **$116.25/h** (B300 $64 + B200 $52.25) · floor $833/h · **gap −$717/h** |
| B300 stock | **0** free 8×B300 (also 0×B200) · **rent waiter armed** |
| Lium bal | ~$121,216 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2ax** n80 ~34/80; **R2ay/R2az** armed; **v10** prefetch |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **GRPO** pid**23755** step≥20 mean_r≈0.044; T:8000 K:8001@65536 |
| host waiter | pid**2139807** | — | `wait_rent_b300.sh` → `mine-r4-fullft-1` (R4 full-FT) |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051` · TTL→2026-08-12T16:29Z
R2av: **REFUTE** m=−0.00027 z=−0.065 hr_live2σ **−0.033×**
R2ax check: `cat /root/affine_data/r2ax_tt_reason_progress.json`
R2ay check: `tail -f /root/logs/r2ay_sbs_v2_reload.log`
R2az check: `tail -f /root/logs/r2az_vvv_reload.log`
v10 check: `tail -f /root/logs/r2_prefetch_awesome_v10.log`
R3 check: `grep r3-log /root/logs/r3_train.nohup | tail`
R4 rent: `tail -f experiments/r4-fullft-reason/logs/wait_rent_b300.log`
Host-hist: pid**2113721** →504 (incl. 498–504)

## Blocked

- No free 8×B300/B200 right now — waiter polls every 45s (~6h).
- Do not serialize more pure board-copies as the only parallelism.

## Next action

**If `artifacts/rented.json` appears:** bootstrap R4 full-FT on new pod (reuse s4-h121 stack).
**Crown:** R2ax→R2ay→R2az; then pure awesome-v10 n80 (prefetching).
**R3:** watch GRPO → `train.done` → post_train merge+chall+n80.
