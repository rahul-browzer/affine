# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5c train RUNNING past mid50; post-train pipe armed.**

Stage 0–3 complete. H2 / H1 / H1v2 / H5 / H5b **REFUTED**. H5c open.
Primary DATA = **791** shortz refs. No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` |
| king S / reign | 0.03150 / **#3** |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | **8767079** (llms; API null) |
| min_margin / eval | 0.02 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| Lium balance | $33,635.45 (floor $28k) |
| mining spend | ~$252 + mine-h5c-1 **$23.26** |
| miner free / submissions | τ10.000 / none |
| H5c mid50 | **salvaged** → `…-h5c-lora` @ `7085a43…` path `checkpoint-50` |
| H5c train | step **52**/99; loss@50 **0.4186** (peak 0.633@25) |
| H5c HF | private `…-h5c-lora` / `…-h5c-merged` (write-probe OK) |
| host | harvest **2090851** stop 18:45Z; deadman **2090852** rm@19:00Z |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-h5c-1` | `golden-hawk-dc` | train→n80 | SSH `152.236.142.234:40298`; train **2820** GPUs6,7; teacher:8000+king:8001 READY; pipe **10642**; mid **5194** (ckpt-50 done); TTL **19:37:46Z** |

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Do **not** submit until n80 margin **> 0.04**. Cap rem ~$3,725.

## Next action

**Poll `h5c_pipeline.done` / `h5c_decision.json`**, triage n80 vs gate.

```bash
cat experiments/s4-h5c-expand-refs/results/h5c_train_progress.json
test -f experiments/s4-h5c-expand-refs/results/h5c_decision.json && cat $_
# live:
ssh -i ~/.ssh/id_ed25519 -o UserKnownHostsFile=/tmp/mine-h5c-1.known_hosts \
  -o StrictHostKeyChecking=accept-new -p 40298 root@152.236.142.234 \
  'tail -5 /root/logs/h5c_train.nohup; cat /root/h5c/mid_ckpt_salvaged.txt;
   ls /root/logs/h5c_{train,merge,chall_serve,sim_n80,pipeline}.{done,aborted} 2>/dev/null;
   test -f /root/affine_data/h5c_decision.json && cat /root/affine_data/h5c_decision.json;
   nvidia-smi --query-gpu=index,memory.used,utilization.gpu --format=csv,noheader'
```

ETA: train done ~11:05Z; merge+chall ~30m; n80 ~45–60m → decision ~12:30–13:00Z.
Soft 18:00Z / harvest stop 18:45Z / deadman 19:00Z / TTL 19:37Z.
Gate: margin **> 0.04**, r∈[0.70,0.85], clip-L1≥0.042. No submit below gate.
Do **not** SCP-edit the live pipe without restarting it.
