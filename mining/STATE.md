# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H6 mid50+train; H8/H9 n80; H10 kevin dl.** 0–3 done.
H2/H1/H1v2/H5/H5b/H5c/H7 **REFUTED**. H6/H8/H9/H10 open. No submit. Cap **4/5** mine-*.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | **8767079** · min_margin 0.02 |
| Lium / spend | $33,362 · ~$414 · cap rem ~$3,586 |
| miner | τ10.000 free · 0 submissions |
| H5c | **REFUTE** n80 −0.01640 |
| H7 | **REFUTE** n80 invalid base×**2.21** (band); pod rm'd ~$28 |
| H6 | train~75/99; mid50 n40 ~19/40 |
| H8 | n80 ~71/80 |
| H9 | ALL_READY; n80 **RUNNING** |
| H10 | kevin dl ~31G (2 incomplete shards) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h5c-1 | golden-hawk-dc | 152.236.142.234:40298 | 19:37Z | H6 train+mid50+fix |
| mine-h8-1 | zesty-fox-15 | 152.236.142.237:40301 | ~19:32Z | H8 n80 + fix |
| mine-h9-1 | noble-lion-ac | 38.255.28.21:20100 | ~20:07Z | H9 n80 + fix |
| mine-h10-1 | gentle-eagle-d5 | 38.255.28.19:20099 | ~20:10Z | H10 kevin dl + fix |

known_hosts `/tmp/mine-h{5c,8,9,10}-1.known_hosts`. **Slot free** (was h7). Validator pods — do not touch.

## Blocked

No submit until some n80 margin > 0.04. Do not merge pandora into TalentPigs again (H7).

## Next action

**Poll H8/H6/H9/H10 for first nested `*_decision.json`.** H6 mid50 = SIGNAL only.
REFUTE→`lium rm` that `mine-h*-1` only; TRY_ALPHA_085 if 0.02≤m≤0.04; ADVANCE if m>0.04.
With 4/5 slots: after acting on a decision, rent next independent hyp into the free slot
(not pandora; not kevin-dom — see LESSONS/HYPOTHESES).

```bash
ssh …40298… 'cat /root/affine_data/h6_mid50_decision.json 2>/dev/null; cat /root/affine_data/h6_mid50_sim_progress.json; grep train-log /root/logs/h6_train.nohup | tail -1'
ssh …40301… 'cat /root/affine_data/h8_decision.json 2>/dev/null; cat /root/affine_data/h8_sim_progress.json'
ssh …20100… 'cat /root/affine_data/h9_decision.json 2>/dev/null; cat /root/affine_data/h9_sim_progress.json'
ssh …20099… 'test -f /root/logs/kevin.done && echo KEVIN_DONE; du -sh /root/hf/hub/models--kevin954*; cat /root/affine_data/h10_decision.json 2>/dev/null'
```
