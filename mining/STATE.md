# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5c mid50 n40 FAIL; final ckpt-99 merging → n80.**

Stage 0–3 done. H2/H1/H1v2/H5/H5b **REFUTED**. H5c open (mid50 dead; final pending). No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 reign#3 |
| teacher / eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | **8767079** · min_margin 0.02 |
| Lium / spend | $33,562.10 · ~$294 total · cap rem ~$3,706 |
| miner | τ10.000 free · 0 submissions |
| H5c train | **done** 99/99 · best loss **0.4186@50** · final noisy (1.87@90) |
| mid50 n40 | margin **−0.01924** z=−1.48 · r=0.897 · clipL1 0.015≪0.042 |
| H5c HF | `…-h5c-lora`@`7085a43` ckpt-50 · merged private push **FAIL** (storage) |
| host | harvest 2090851 · deadman 2090852 rm@19:00Z |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-h5c-1` | `golden-hawk-dc` | final merge→n80 | SSH `152.236.142.234:40298` |

pipe **10642** merging final on GPUs 6,7 (started 11:05Z) · teacher:8000+king:8001
still up · mid50 early **DONE** · GPUs 4,5 free · TTL **19:37:46Z**

Validator pods — do not touch.

## Blocked

No submit (mid50 −0.019; need final n80 >0.04 — unlikely).

## Next action

**Poll final merge → chall → n80.** If margin≤0.04, refute H5c and tear down pod.

```bash
ssh -i ~/.ssh/id_ed25519 -o UserKnownHostsFile=/tmp/mine-h5c-1.known_hosts \
  -o StrictHostKeyChecking=accept-new -p 40298 root@152.236.142.234 \
  'tail -5 /root/logs/h5c_pipeline.nohup | tr "\r" "\n";
   ls /root/logs/h5c_{merge,sim_n80,pipeline}.{done,aborted} 2>/dev/null;
   test -f /root/affine_data/h5c_decision.json && cat $_;
   nvidia-smi --query-gpu=index,memory.used,utilization.gpu --format=csv,noheader'
```

ETA merge~11:15Z; n80~12:30–13:00Z. Gate unchanged. Do not submit mid50.
If H5c refuted: design next hypo (not more kevin-thought LoRA at lr2e-5).
