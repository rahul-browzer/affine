# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — parallel: H5c n80 + H6 train (mine-h5c-1); H7 merge (mine-h7-1).**

0–3 done. H2/H1/H1v2/H5/H5b **REFUTED**. H5c/H6/H7 open. No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 #3 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | **8767079** · min_margin 0.02 |
| Lium / spend | $33,529 · ~$354 · cap rem ~$3,650 |
| miner | τ10.000 free · 0 submissions |
| H5c mid50 | margin **−0.019** · r=0.897 · clipL1 0.015 |
| H5c HF | public `unconst/Affine-5czsc2fc98-h5c-merged` @ 0cda099e |
| H5c n80 | **RUNNING** pid 43690 · ~15/80 @11:28Z |
| H6 train | **RUNNING** pid 46680 · ~3/99 @11:29Z |
| H7 | **BOOTSTRAP** pid 829 · α0.75 then n80 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h5c-1 | golden-hawk-dc | 152.236.142.234:40298 | 19:37Z | n80+H6 |
| mine-h7-1 | lunar-orbit-1b | 152.236.142.232:40299 | ~19:28Z | H7 |

h5c known_hosts `/tmp/mine-h5c-1.known_hosts` · keep until H6 resolves.
h7 known_hosts `/tmp/mine-h7-1.known_hosts` · id 53e43d94-… .
Validator pods — do not touch.

## Blocked

No submit until some n80 margin > 0.04.

## Next action

**Poll H5c n80, H6 train, H7 pipeline** — act on first decision artifact.

```bash
ssh -i ~/.ssh/id_ed25519 -o UserKnownHostsFile=/tmp/mine-h5c-1.known_hosts \
  -o StrictHostKeyChecking=accept-new -p 40298 root@152.236.142.234 \
  'cat /root/affine_data/h5c_sim_progress.json; \
   test -f /root/affine_data/h5c_decision.json && cat $_; \
   test -f /root/h6/train/train.done && cat $_'
ssh -i ~/.ssh/id_ed25519 -o UserKnownHostsFile=/tmp/mine-h7-1.known_hosts \
  -o StrictHostKeyChecking=accept-new -p 40299 root@152.236.142.232 \
  'tail -n 15 /root/logs/bootstrap_h7.log; \
   test -f /root/affine_data/h7_decision.json && cat $_; \
   cat /root/affine_data/h7_sim_progress.json 2>/dev/null'
```

H5c≤0.04 → refute, keep pod for H6. H7 REFUTE → `lium rm` mine-h7-1 only
(name-check first). No submit without margin>0.04.
