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
| challenge | chal-00489 (scoring; snapshot ~17:10Z) |
| miner burn | **$116.25/h** (B300 $64 + B200 $52.25) · floor $833/h · **gap −$717/h** |
| B300 stock | **0** free 8×B300 (B200×8=0; only 1×B300 listed) |
| Lium bal | ~$121,371 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2av** v2 n80 ~5/80 (pid167002); R2ax armed |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **GRPO training** pid15121 (LoRA r16 on Tok; teacher :8000 up) |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051` · TTL→2026-08-12T16:29Z
R2au: **REFUTE** m=−0.03071 z=−3.66 hr_live2σ **−1.83×** (n=75; script k=3)
R2av check: `tail -f /root/logs/r2av_v2_reason_sim.log` + progress json
R3 check: `tail -f /root/logs/r3_train.nohup` · stamp `r3_train_launched.stamp`

## Blocked

- No free 8×B300/B200 — cannot close $833/h gap this pass.
- Do not serialize more pure board-copies as "parallelism" on crown alone.

## Next action

**R3:** watch GRPO steps / loss; on train done → merge+reload chall → n80.
**Crown:** collect R2av v2 n80; then R2ax tt.
Re-check `lium ls --gpu B300 --count 8`; rent any free 8× into distinct axis (full-FT / non-king / format).
