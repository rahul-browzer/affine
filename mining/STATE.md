# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H6 mid50+train; H7/H8 n80; H9 serve→n80; H10 kevin dl.** 0–3 done.
H2/H1/H1v2/H5/H5b/H5c **REFUTED**. H6–H10 open. No submit. Cap 5/5 mine-*.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | **8767079** · min_margin 0.02 |
| Lium / spend | $33,399 · ~$386 · cap rem ~$3,614 |
| miner | τ10.000 free · 0 submissions |
| H5c | **REFUTE** n80 −0.01640 — do not submit |
| H6 | train~65/99 loss0.530; mid50 n40 ~5/40; fix-watchers on |
| H7 / H8 | n80 ~65/80 · ~58/80 |
| H9 | MERGE_DONE non-id; teacher/king/chall loading; wait_ready→n80 |
| H10 | kevin shards ~16G+11G incomplete (growing) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h5c-1 | golden-hawk-dc | 152.236.142.234:40298 | 19:37Z | H6 train+mid50+fix |
| mine-h7-1 | lunar-orbit-1b | 152.236.142.232:40299 | ~19:28Z | H7 n80 + fix |
| mine-h8-1 | zesty-fox-15 | 152.236.142.237:40301 | ~19:32Z | H8 n80 + fix |
| mine-h9-1 | noble-lion-ac | 38.255.28.21:20100 | ~20:07Z | H9 serve→n80 + fix |
| mine-h10-1 | gentle-eagle-d5 | 38.255.28.19:20099 | ~20:10Z | H10 kevin dl + fix |

known_hosts `/tmp/mine-h{5c,7,8,9,10}-1.known_hosts`. Validator pods — do not touch.

## Blocked

No submit until some n80 margin > 0.04.

## Next action

**Poll for first `*_decision.json` with `parser: write_merge_decision.py#nested_verdict`.**
H6 mid50 emits `SIGNAL_*` (signal_only; do not tear down h5c). H7–H10/H6 final:
REFUTE→`lium rm` that `mine-h*-1` only; TRY_ALPHA_085 if 0.02≤m≤0.04; ADVANCE if m>0.04.

```bash
ssh …40298… 'cat /root/affine_data/h6_mid50_decision.json 2>/dev/null; cat /root/affine_data/h6_mid50_sim_progress.json; grep train-log /root/logs/h6_train.nohup | tail -1'
ssh …40299… 'cat /root/affine_data/h7_decision.json 2>/dev/null; cat /root/affine_data/h7_sim_progress.json'
ssh …40301… 'cat /root/affine_data/h8_decision.json 2>/dev/null; cat /root/affine_data/h8_sim_progress.json'
ssh …20100… 'cat /root/affine_data/h9_decision.json 2>/dev/null; cat /root/affine_data/h9_sim_progress.json; tail -3 /root/logs/h9_n80.nohup'
ssh …20099… 'test -f /root/logs/kevin.done && echo KEVIN_DONE; tail -5 /root/logs/bootstrap_h10.log; cat /root/affine_data/h10_decision.json 2>/dev/null'
```
