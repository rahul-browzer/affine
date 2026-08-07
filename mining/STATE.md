# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5c train RUNNING; HF salvage repos FIXED; post-train pipe waiting.**

Stage 0–3 complete. H2 / H1 / H1v2 / H5 merge / H5b **REFUTED**.
H5c autopsy + expand-refs harvest DONE. Primary DATA = **791** shortz refs.
No submit.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4` |
| king S | 0.031501971059510636 |
| reign # | **3** |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | **8767079** (llms; snapshot/contract field null) |
| weight_version_key | 1 |
| min_margin | 0.02 (duel) |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $33,676.21 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | prior ~$252 + `mine-h5c-1` **$9.64** @ $28/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 / H1 / H1v2 / H5 merge / H5b | **all REFUTED** |
| H5c | **open** — train pid **2820** step **14**/99; pipe **10642** (pidfile wait); prewarm DONE t=200 k=200; mid **5194** |
| host harvest | **2090851** → stop 18:45Z; scrapes → `experiments/s4-h5c-expand-refs/results/` |
| host deadman | **2090852** → `lium rm mine-h5c-1` at **19:00Z** (name-checked) |
| H1v2 HF merged | public `unconst/Affine-5czsc2fc98-h1v2-merged` @ `a314357…` (do not submit) |
| H5b HF | private `…-h5b-lora` / `…-h5b-merged` @ `e1d39a1…` (salvage only; do not submit) |
| H5c HF | private `…-h5c-lora` @ `bb26ad9…` / `…-h5c-merged` @ `128c6fa…` (empty shells; pod can write) |
| live eval | `chal-00301` kevin954 scoring 75/80 (unrelated) |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-h5c-1` | `golden-hawk-dc` | H5c train + prewarm + post-train→n80 | SSH `152.236.142.234:40298`; train **2820** GPUs 6,7 step14/99; teacher **5268** :8000 READY; king **5270** :8001 READY; pipe **10642** waiting train.done; mid **5194**; corpus 9000; TTL remove **2026-08-07T19:37:46Z** |

Host: harvest **2090851**, deadman **2090852**. Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** any H1/H1v2/H2/h5/h5b/h5c checkpoint until
n80 margin **> 0.04**. Cap remaining ~$3,748 − mine-h5c-1 spend.

## Next action (single, highest value)

**Poll until `h5c_pipeline.done` / `h5c_decision.json` or train/pipe abort**, then triage n80.
Watch mid-ckpt salvage around step **50** (save_steps=50) → should land in `…-h5c-lora`.

```bash
# host progress (preferred)
cat experiments/s4-h5c-expand-refs/results/h5c_train_progress.json
tail -20 .ralph/host_harvest_h5c.log
test -f experiments/s4-h5c-expand-refs/results/h5c_decision.json && cat experiments/s4-h5c-expand-refs/results/h5c_decision.json

# or live pod
ssh -i ~/.ssh/id_ed25519 -o UserKnownHostsFile=/tmp/mine-h5c-1.known_hosts \
  -o StrictHostKeyChecking=accept-new -p 40298 root@152.236.142.234 \
  'tail -5 /root/logs/h5c_train.nohup; tail -8 /root/logs/h5c_pipeline.nohup; \
   ls /root/logs/{h5c_prewarm.done,h5c_merge.done,h5c_chall_serve.done,h5c_sim_n80.done,h5c_pipeline.done,h5c_pipeline.aborted} 2>/dev/null; \
   test -f /root/affine_data/h5c_sim_progress.json && cat /root/affine_data/h5c_sim_progress.json; \
   cat /root/h5c/mid_ckpt_salvaged.txt 2>/dev/null; \
   nvidia-smi --query-gpu=index,memory.used,utilization.gpu --format=csv,noheader; \
   for p in 8000 8001 8002; do echo -n ":$p "; curl -s -o /dev/null -w "%{http_code}" --max-time 2 http://127.0.0.1:$p/v1/models; echo; done'
```

ETA: train ~11:20Z (@~48s/it from step14); merge+chall ~30m; n80 ~45–60m →
decision ~13:00Z. Soft 18:00Z / host harvest stop 18:45Z / deadman 19:00Z / TTL 19:37Z.
Gate: margin **> 0.04**, r∈[0.70,0.85], clip-L1≥0.042. No submit below gate.

Pass 107: created missing private HF shells (pass 104 claim was stale — repos 401'd).
Do **not** SCP-edit the live pipe script without restarting it.
