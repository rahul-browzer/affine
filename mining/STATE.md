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
| challenge | chal-00490 (duel; scoring king ~1636/2080) |
| miner burn | **$116.25/h** (B300 $64 + B200 $52.25) · floor $833/h · **gap −$717/h** |
| B300 stock | **0** free 8×B300 (also 0×B200) |
| Lium bal | ~$121,263 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2ax** n80 ~8–9/80; **R2ay** sbs-v2 prefetch+waiter armed |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **GRPO** pid**23755** step≥5; T:8000 K:8001@65536 |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051` · TTL→2026-08-12T16:29Z
R2av: **REFUTE** m=−0.00027 z=−0.065 hr_live2σ **−0.033×**
R2ax check: `cat /root/affine_data/r2ax_tt_reason_progress.json`
R2ay check: `tail -f /root/logs/r2_prefetch_sbs_v2.log` · `tail -f /root/logs/r2ay_sbs_v2_reload.log`
R3 check: `grep r3-log /root/logs/r3_train.nohup | tail`
Host-hist: pid**2113721** pending 490–495 + **497–504**

## Blocked

- No free 8×B300/B200 — cannot close $833/h gap this pass.
- Do not serialize more pure board-copies as "parallelism" on crown alone.

## Next action

**Crown:** collect R2ax n80 → decision; R2ay auto-continues (board-first on chal00499).
**R3:** watch GRPO → `train.done` → post_train merge+chall+n80.
Re-check `lium ls --gpu B300 --count 8`; rent any free 8× into distinct axis.
