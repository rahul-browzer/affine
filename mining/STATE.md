# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — parallel: H6 train+pipe (mine-h5c-1); H7 n80 (mine-h7-1); H8 n80 (mine-h8-1).**

0–3 done. H2/H1/H1v2/H5/H5b/H5c **REFUTED**. H6/H7/H8 open. No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | **8767079** · min_margin 0.02 |
| Lium / spend | $33,444 · ~$349 · cap rem ~$3,651 |
| miner | τ10.000 free · 0 submissions |
| H5c n80 | **REFUTE** margin **−0.01640** z=−2.25 · r=0.883 · clipL1 0.017≪0.028 |
| H5c HF | public `unconst/Affine-5czsc2fc98-h5c-merged` (do not submit) |
| H6 train | **RUNNING** pid 46680 · ~40/99 loss≈0.520@40 |
| H6 pipe | **WAITING** pid 53727 on train.done |
| H7 n80 | **RUNNING** pid 11769 · ~28/80 |
| H8 n80 | **RUNNING** pid 12199 · ~16/80 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h5c-1 | golden-hawk-dc | 152.236.142.234:40298 | 19:37Z | H6 train+pipe (H5c done) |
| mine-h7-1 | lunar-orbit-1b | 152.236.142.232:40299 | ~19:28Z | H7 n80 |
| mine-h8-1 | zesty-fox-15 | 152.236.142.237:40301 | ~19:32Z | H8 n80 |

known_hosts `/tmp/mine-h{5c,7,8}-1.known_hosts`. Validator pods — do not touch.

## Blocked

No submit until some n80 margin > 0.04.

## Next action

**Poll H6 train + H7/H8 decisions; act on first decision artifact.**

```bash
ssh … -p 40298 … 'grep train-log /root/logs/h6_train.nohup | tail -2; \
  test -f /root/affine_data/h6_decision.json && cat $_; \
  test -f /root/h6/train.done -o -f /root/affine_data/h6_train.done && echo TRAIN_DONE'
ssh … -p 40299 … 'cat /root/affine_data/h7_sim_progress.json; \
  test -f /root/affine_data/h7_decision.json && cat $_'
ssh … -p 40301 … 'cat /root/affine_data/h8_sim_progress.json; \
  test -f /root/affine_data/h8_decision.json && cat $_'
```

H7/H8: REFUTE→`lium rm` that `mine-h*-1` only (name-check); TRY_ALPHA_085 if 0.02≤m≤0.04; ADVANCE if m>0.04. Keep mine-h5c-1 until H6 resolves. No submit without margin>0.04.
