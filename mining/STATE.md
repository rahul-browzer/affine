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
| challenge | chal-00490 (duel; snapshot ~18:02Z) |
| miner burn | **$116.25/h** (B300 $64 + B200 $52.25) · floor $833/h · **gap −$717/h** |
| B300 stock | **0** free 8×B300 (also 0×B200) |
| Lium bal | ~$121,278 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2ax** tt chall loading :8002; R2av **REFUTE** |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **GRPO** pid**23755** step≥3 mean_r≈0.005; T:8000 K:8001@65536 |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051` · TTL→2026-08-12T16:29Z
R2av: **REFUTE** m=−0.00027 z=−0.065 hr_live2σ **−0.033×** (n=80; Bittoby v2)
R2ax check: `tail -f /root/logs/r2ax_tt_reload.log` · `curl :8002/v1/models`
R3 check: `grep r3-log /root/logs/r3_train.nohup | tail`

## Blocked

- No free 8×B300/B200 — cannot close $833/h gap this pass.
- Do not serialize more pure board-copies as "parallelism" on crown alone.

## Next action

**R3:** watch GRPO steps → `train.done` → post_train merge+chall+n80.
**Crown:** wait R2ax tt chall ready → n80; collect decision.
Re-check `lium ls --gpu B300 --count 8`; rent any free 8× into distinct axis.
