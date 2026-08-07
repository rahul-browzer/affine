# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5c train RUNNING; post-train pipe + prewarm ARMED on `mine-h5c-1`.**

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
| min_submission_block | **8767079** |
| weight_version_key | 1 |
| min_margin | 0.02 (duel) |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $33,684.34 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | prior ~$252 + `mine-h5c-1` **$5.92** @ $28/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 / H1 / H1v2 / H5 merge / H5b | **all REFUTED** |
| H5c | **open** — train pid **2820** step **5**/99; pipe **5222** waiting; prewarm **5206** loading teacher+king; mid **5194** |
| H1v2 HF merged | public `unconst/Affine-5czsc2fc98-h1v2-merged` @ `a314357…` (do not submit) |
| H5b HF | private `…-h5b-lora` / `…-h5b-merged` @ `e1d39a1…` (salvage only; do not submit) |
| H5c HF | private `…-h5c-lora` / `…-h5c-merged` (empty; salvage armed) |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-h5c-1` | `golden-hawk-dc` | H5c train + prewarm + post-train pipe | SSH `152.236.142.234:40298`; train **2820** GPUs 6,7; teacher **5268** :8000 GPUs 0,1; king **5270** :8001 GPUs 2,3; pipe **5222**; mid **5194**; corpus 9000 turns; TTL remove **2026-08-07T19:37:46Z** |

Validator pods `affine-eval` / `affine-bench` — do not touch.

Note: `current_eval` was kevin954 re-challenge (scoring). Re-check snapshot
before merge/sim/submit (king may change).

## Blocked

Nothing hard. **Do not submit** any H1/H1v2/H2/h5/h5b/h5c checkpoint until
n80 margin **> 0.04**. Cap remaining ~$3,748 − mine-h5c-1 spend.

## Next action (single, highest value)

**Poll until `h5c_pipeline.done` or train/pipe abort**, then triage n80.

```bash
ssh -i ~/.ssh/id_ed25519 -o UserKnownHostsFile=/tmp/mine-h5c-1.known_hosts \
  -o StrictHostKeyChecking=accept-new -p 40298 root@152.236.142.234 \
  'tail -5 /root/logs/h5c_train.nohup; tail -15 /root/logs/h5c_pipeline.nohup; \
   ls /root/logs/{h5c_prewarm.done,h5c_merge.done,h5c_chall_serve.done,h5c_sim_n80.done,h5c_pipeline.done,h5c_pipeline.aborted} 2>/dev/null; \
   test -f /root/affine_data/h5c_sim_progress.json && cat /root/affine_data/h5c_sim_progress.json; \
   test -f /root/affine_data/h5c_sim_result.json && python3 -c "import json;d=json.load(open(\"/root/affine_data/h5c_sim_result.json\"));print(d.get(\"verdict\"))"; \
   nvidia-smi --query-gpu=index,memory.used,utilization.gpu --format=csv,noheader; \
   for p in 8000 8001 8002; do echo -n ":$p "; curl -s -o /dev/null -w "%{http_code}" --max-time 2 http://127.0.0.1:$p/health; echo; done'
```

ETA: train ~11:20Z (@~47s/it from step5); merge+chall ~30m; n80 ~45–60m →
decision ~13:00Z. Soft 18:00Z / deadman 19:00Z / TTL 19:37Z.
Gate: margin **> 0.04**, r∈[0.70,0.85], clip-L1≥0.042. No submit below gate.
