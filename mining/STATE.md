# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5c train ~55/99 + mid50 early n40 on GPUs 4,5.**

Stage 0–3 done. H2/H1/H1v2/H5/H5b **REFUTED**. H5c open. DATA=791 shortz. No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S=0.03150 reign#3 |
| teacher / eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | **8767079** · min_margin 0.02 |
| Lium / spend | $33,627.29 · ~$276 total · cap rem ~$3,724 |
| miner | τ10.000 free · 0 submissions |
| H5c train | step **55**/99 · loss@50 **0.4186** · loss@55 **0.5679** (rose) |
| H5c HF | `…-h5c-lora`@`7085a43…` ckpt-50 · `…-h5c-merged` private |
| host | harvest 2090851→18:45Z · deadman 2090852 rm@19:00Z |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-h5c-1` | `golden-hawk-dc` | train→n80 + mid50 early | SSH `152.236.142.234:40298` |

train **2820** GPUs6,7 · pipe **10642** waits train.done · mid **5194** ·
**mid50 early 21557** merge→n40 GPUs4,5 (yields on `h5c_merge.done`) ·
teacher:8000+king:8001 READY · TTL **19:37:46Z**

Validator pods — do not touch.

## Blocked

No submit until n80 margin **> 0.04**.

## Next action

**Poll mid50 n40 + train/final pipe.** Prefer mid50 if final loss stays >0.42.

```bash
ssh -i ~/.ssh/id_ed25519 -o UserKnownHostsFile=/tmp/mine-h5c-1.known_hosts \
  -o StrictHostKeyChecking=accept-new -p 40298 root@152.236.142.234 \
  'tail -8 /root/logs/h5c_mid50_early.nohup; tail -3 /root/logs/h5c_train.nohup;
   ls /root/logs/h5c_mid50_{merge,chall,sim_n40,early}.{done,aborted} 2>/dev/null;
   test -f /root/affine_data/h5c_mid50_sim_n40.json && python3 -c \
     "import json;d=json.load(open(\"/root/affine_data/h5c_mid50_sim_n40.json\"));print(d[\"verdict\"])";
   ls /root/logs/h5c_{train,merge,sim_n80,pipeline}.{done,aborted} 2>/dev/null;
   test -f /root/affine_data/h5c_decision.json && cat $_;
   nvidia-smi --query-gpu=index,memory.used,utilization.gpu --format=csv,noheader'
```

ETA train~11:05Z; mid50 n40~11:15–11:30Z; final n80~12:30–13:00Z.
Gate: margin>0.04, r∈[0.70,0.85], clip-L1≥0.042. No submit below.
Do **not** SCP-edit the live pipe without restarting it.
