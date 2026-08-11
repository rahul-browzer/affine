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
| challenge | chal-00489 (snapshot 16:28Z) |
| miner burn | **$116.25/h** (B300 $64 + B200 $52.25) · floor $833/h · **gap −$717/h** |
| B300 stock | **0** free 8×B300 after this rent |
| Lium bal | ~$121,569 · floor $10k OK |
| submissions | 0 |

## What's running

| name | huid | $/h | role |
|---|---|---|---|
| mine-crown-1 | gentle-orbit-bd | $52.25 | R2at hope11 n80 **~15/80**; R2au…ax armed |
| mine-r3-grpo-1 | golden-hawk-ff | $64.00 | **NEW** R3 GRPO axis — SSH OK; bootstrap next |

SSH crown: `ssh root@95.133.253.90 -p 40099`
SSH R3: `ssh root@204.9.206.245 -p 40051` · TTL→2026-08-12T16:29Z

## Blocked

- No more 8×B300 (or 8×B200) on market — cannot close $833/h gap this pass.
- Do not serialize more pure board-copies as "parallelism" on crown alone.

## Next action

**Bootstrap `mine-r3-grpo-1`:** upload mining_src + mine.env, install venv/vLLM,
B300 flash patch, pull teacher+Tok, serve teacher, launch Reason-GRPO train
(adapt `experiments/s4-h132-f37-tok-rl-l2/train_rl_l2.py`). Re-check `lium ls`
for B300 and rent any free 8× into a **distinct** axis (full-FT / non-king /
format) up to cap 25.
