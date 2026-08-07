# s4-h1-sft progress

| UTC | event |
|---|---|
| 2026-08-07T01:51:14Z | harvest DONE — 440 examples / 0 missing |
| 2026-08-07T01:51:26Z | train launched pid 82057 on GPUs 6,7 |
| 2026-08-07T01:53:10Z | weights loaded; trainable 8.36M / 34.7B (0.024%) |
| 2026-08-07T01:54:20Z | step 1/110 @ ~63s/it; ETA ~03:50Z |
| 2026-08-07T01:56:31Z | post_train_pipeline.sh armed pid **83194** (wait→merge→serve→sim) |
| 2026-08-07T01:56:34Z | train at step 3/110 @ ~60s/it; ETA ~03:45Z |
| 2026-08-07T01:58:13Z | pipeline restarted pid **83414** with HF adapter salvage before merge |
| 2026-08-07T01:58:18Z | train at step 5/110 @ ~55s/it; ETA ~03:40Z; engines 200×3 |
| 2026-08-07T02:01:00Z | HF private repo `unconst/Affine-5czsc2fc98-h1-lora` pre-created |
| 2026-08-07T02:01:32Z | mid-ckpt salvage pid **83669** + host harvest pid **1375476** armed |
| 2026-08-07T02:01:34Z | train at step 8/110 @ ~63s/it; ETA ~03:48Z; engines 200×3 |
| 2026-08-07T02:04:13Z | pipeline restarted pid **84156** — merge now CUDA 6,7 (`--device-map auto`) for TTL margin |
| 2026-08-07T02:04:17Z | train at step 10/110 @ ~61s/it; ETA ~03:45Z; engines 200×3 |

## How to check

```bash
ssh -i ~/.ssh/id_ed25519 -p 40301 root@69.63.236.160
kill -0 $(cat /root/logs/h1_train.pid) && tail -20 /root/logs/h1_train.nohup
kill -0 $(cat /root/logs/h1_pipeline.pid) && tail -20 /root/logs/h1_pipeline.nohup
test -f /root/affine_data/h1_sim_result.json && cat /root/affine_data/h1_sim_result.json | head
```

## After train.done (automatic)

Pipeline `post_train_pipeline.sh` (pid 83414) handles:
1. HF salvage adapter → `unconst/Affine-5czsc2fc98-h1-lora` (private)
2. GPU merge on CUDA 6,7 → `/root/h1/merged`
3. `restart_for_h2.sh` with `MERGE=/root/h1/merged`
4. `run_sim_duel.py` → `/root/affine_data/h1_sim_result.json`

Done markers: `/root/logs/h1_pipeline.done`, `/root/logs/h1_sim.done`.
Salvage meta: `/root/h1/adapter_salvage.json`.
