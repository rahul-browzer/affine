# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H6/H9/H10/H11/H12 parallel.** 0–3 done.
H2/H1/H1v2/H5/H5b/H5c/H7/H8 **REFUTED**. H6/H9/H10/H11/H12 open. No submit. Cap **5/5**.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | **8767079** · min_margin 0.02 |
| Lium / spend | $33,315 · ~$460 · cap rem ~$3,540 |
| miner | τ10.000 free · 0 submissions |
| H6 | train~95/99; mid50 retry ~12/40 |
| H9 | n80 ~38/80 |
| H10 | merge ~10/16 shards |
| H11 | mirror OK; merge ~4/16 |
| H12 | boot (pip); TP×dfwas-alskdjf α0.75 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h5c-1 | golden-hawk-dc | 152.236.142.234:40298 | 19:37Z | H6 train+mid50+pipe |
| mine-h9-1 | noble-lion-ac | 38.255.28.21:20100 | ~20:07Z | H9 n80 |
| mine-h10-1 | gentle-eagle-d5 | 38.255.28.19:20099 | ~20:10Z | H10 merge→n80 |
| mine-h11-1 | swift-fox-b5 | 152.236.142.232:40311 | ~20:33Z | H11 merge→n80 |
| mine-h12-1 | calm-hawk-89 | 152.236.142.237:40311 | 20:42Z | H12 boot→merge→n80 |

known_hosts `/tmp/mine-h{5c,9,10,11,12}-1.known_hosts`. **Slots full.** Validator pods — do not touch.

## Blocked

No submit until some n80 margin > 0.04. No pandora / golden-crown merges (band).
Deleted near-miss parents (kkk/marsplan/adambell) — use live HF only.

## Next action

**Poll for first nested `*_decision.json` (H9 / H6 mid50 SIGNAL / H6 final / H11 / H10 / H12).**
H6 mid50 = SIGNAL only. REFUTE→`lium rm` that `mine-h*-1` only; TRY_ALPHA_085 if 0.02≤m≤0.04; ADVANCE if m>0.04.

```bash
ssh …40298… 'cat /root/affine_data/h6_mid50_decision.json 2>/dev/null; cat /root/affine_data/h6_decision.json 2>/dev/null; cat /root/affine_data/h6_mid50_sim_progress.json; grep train-log /root/logs/h6_train.nohup | tail -1'
ssh …20100… 'cat /root/affine_data/h9_decision.json 2>/dev/null; cat /root/affine_data/h9_sim_progress.json'
ssh …20099… 'cat /root/affine_data/h10_decision.json 2>/dev/null; tail -3 /root/logs/h10_merge.log; test -f /root/logs/h10_merge.done && echo MERGE_DONE'
ssh …40311… @.232 'cat /root/affine_data/h11_decision.json 2>/dev/null; tail -3 /root/logs/h11_merge.log'
ssh …40311… @.237 'cat /root/affine_data/h12_decision.json 2>/dev/null; tail -5 /root/logs/bootstrap_h12.log'
```
