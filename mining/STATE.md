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
| challenge | chal-00489 (scoring; snapshot 16:42Z) |
| miner burn | **$116.25/h** (B300 $64 + B200 $52.25) · floor $833/h · **gap −$717/h** |
| B300 stock | **0** free 8×B300 (only 1×B300 listed) |
| Lium bal | ~$121,511 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | R2at hope11 n80 **~62/80**; R2au…ax armed |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **HF parallel_dl** tok+teacher (~8–12G@16:46Z); bootstrap waits stamps |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051` · TTL→2026-08-12T16:29Z
R3: `tail -f /root/logs/parallel_dl.log` → stamps → teacher :8000 → `r3_train_launched.stamp`
R3 check: `ps -p $(cat /root/logs/parallel_dl.pid)` · `ls /root/logs/{tok_init,teacher}.done`

## Blocked

- No free 8×B300/B200 — cannot close $833/h gap this pass.
- Do not serialize more pure board-copies as "parallelism" on crown alone.

## Next action

**R3:** wait `{tok_init,teacher}.done` → teacher :8000 → GRPO train (`r3_train_launched.stamp`).
Re-check `lium ls --gpu B300 --count 8`; rent any free 8× into distinct axis (full-FT / non-king / format).
Crown: collect R2at hope11 n80 decision when done (~62→80).
