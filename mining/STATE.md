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
| challenge | chal-00490 (duel; snapshot ~17:55Z) |
| miner burn | **$116.25/h** (B300 $64 + B200 $52.25) · floor $833/h · **gap −$717/h** |
| B300 stock | **0** free 8×B300 (also 0×B200) |
| Lium bal | ~$121,294 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2av** v2 n80 ~78/80; R2ax armed |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **GRPO** pid**23755** scoring; teacher:8000 + king:8001@65536 |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051` · TTL→2026-08-12T16:29Z
R2au: **REFUTE** m=−0.03071 z=−3.66 hr_live2σ **−1.83×**
R2av check: `cat /root/affine_data/r2av_v2_reason_progress.json`
R3 check: `tail -f /root/logs/r3_train.nohup` · engines `curl :8000/:8001/v1/models`
p2063: killed wedged GRPO 15121 (100%CPU+CLOSE-WAIT after p2062 STOP/CONT); relaunched → step1 mean_r**=0.0198** (4/4 rewards live).

## Blocked

- No free 8×B300/B200 — cannot close $833/h gap this pass.
- Do not serialize more pure board-copies as "parallelism" on crown alone.

## Next action

**R3:** watch GRPO steps/loss → `train.done` → post_train merge+chall+n80.
**Crown:** collect R2av decision (~78/80); R2ax tt auto-continues.
Re-check `lium ls --gpu B300 --count 8`; rent any free 8× into distinct axis.
