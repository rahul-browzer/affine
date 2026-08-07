# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H6 mid50+train; H9/H10/H11 n80.** 0–3 done.
H2/H1/H1v2/H5/H5b/H5c/H7/H8 **REFUTED**. H6/H9/H10/H11 open. No submit. Cap **4/5**.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | **8767079** · min_margin 0.02 |
| Lium / spend | $33,345 · ~$415 · cap rem ~$3,585 |
| miner | τ10.000 free · 0 submissions |
| H8 | **REFUTE** n80 INVALID base×**1.97** (band); pod rm'd ~$27 |
| H6 | train~80/99; mid50 n40 ~29/40 |
| H9 | n80 ~15/80 |
| H10 | kevin dl ~58G (1 incomplete) |
| H11 | boot pip; TP×adambell α0.75 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h5c-1 | golden-hawk-dc | 152.236.142.234:40298 | 19:37Z | H6 train+mid50+fix |
| mine-h9-1 | noble-lion-ac | 38.255.28.21:20100 | ~20:07Z | H9 n80 |
| mine-h10-1 | gentle-eagle-d5 | 38.255.28.19:20099 | ~20:10Z | H10 kevin dl |
| mine-h11-1 | swift-fox-b5 | 152.236.142.232:40311 | ~20:33Z | H11 boot→n80 |

known_hosts `/tmp/mine-h{5c,9,10,11}-1.known_hosts`. **Slot free: 1**. Validator pods — do not touch.

## Blocked

No submit until some n80 margin > 0.04. No pandora / golden-crown merges (band).

## Next action

**Poll H9/H6/H11/H10 for first nested `*_decision.json`.** H6 mid50 = SIGNAL only.
REFUTE→`lium rm` that `mine-h*-1` only; TRY_ALPHA_085 if 0.02≤m≤0.04; ADVANCE if m>0.04.
Free slot after next teardown: prefer gate-valid near-miss parents (not null-S earners).

```bash
ssh …40298… 'cat /root/affine_data/h6_mid50_decision.json 2>/dev/null; cat /root/affine_data/h6_mid50_sim_progress.json; grep train-log /root/logs/h6_train.nohup | tail -1'
ssh …20100… 'cat /root/affine_data/h9_decision.json 2>/dev/null; cat /root/affine_data/h9_sim_progress.json'
ssh …20099… 'test -f /root/logs/kevin.done && echo KEVIN_DONE; du -sh /root/hf/hub/models--kevin954*; cat /root/affine_data/h10_decision.json 2>/dev/null'
ssh …40311… 'cat /root/affine_data/h11_decision.json 2>/dev/null; tail -5 /root/logs/bootstrap_h11.log; cat /root/affine_data/h11_sim_progress.json 2>/dev/null'
```
