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
| challenge | chal-00489 (scoring; snapshot 17:06Z) |
| miner burn | **$116.25/h** (B300 $64 + B200 $52.25) · floor $833/h · **gap −$717/h** |
| B300 stock | **0** free 8×B300 (B200×8=0; only 1×B300 listed) |
| Lium bal | ~$121,449 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | **R2au** sft4 n80 **~35/80** (pid160236); R2av/ax armed |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **16-way range DL** Tok shard2 ~3→35GB @~90MB/s → waiter→bootstrap→teacher→GRPO |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051` · TTL→2026-08-12T16:29Z
R2at: hope11 **WEAK_SKIP** m=+0.01223 z=1.93 hr**0.97×** vs live 2·SE
R3 check: `tail -f /root/logs/fast_range_dl.log` → `tok_init.done` → `bootstrap_r3.log` → `r3_train_launched.stamp`
R3 pids: fast_range_dl=7247 · wait_tok_bootstrap=7308

## Blocked

- No free 8×B300/B200 — cannot close $833/h gap this pass.
- Do not serialize more pure board-copies as "parallelism" on crown alone.

## Next action

**R3:** confirm `tok_init.done` + teacher :8000 + `r3_train_launched.stamp` (ETA ~6m from 17:09Z @~90MB/s).
**Crown:** collect R2au sft4 n80 decision; then R2av→R2ax.
Re-check `lium ls --gpu B300 --count 8`; rent any free 8× into distinct axis (full-FT / non-king / format).
