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
| 2026-08-07T02:09:14Z | pipeline restarted pid **84834** — chall-only serve + sim progress JSON; freed h2-kp50+genesis |
| 2026-08-07T02:09:20Z | train at step 16/110 @ ~50s/it; ETA ~03:28Z; engines 200×3 |
| 2026-08-07T02:12:15Z | pipeline restarted pid **85424** — dual-phase sim n40→n80 + soft TTL cutoff |
| 2026-08-07T02:12:20Z | `lium bk set` `/root/h1/train` every 1h keep 1d (adapter TTL insurance) |
| 2026-08-07T02:12:52Z | train at step 20/110 @ ~51s/it; ETA ~03:30Z; engines 200×3; host harvest 1393267 |

## How to check

```bash
ssh -i ~/.ssh/id_ed25519 -p 40301 root@69.63.236.160
kill -0 $(cat /root/logs/h1_train.pid) && tail -20 /root/logs/h1_train.nohup
kill -0 $(cat /root/logs/h1_pipeline.pid) && tail -20 /root/logs/h1_pipeline.nohup
test -f /root/affine_data/h1_sim_result.json && cat /root/affine_data/h1_sim_result.json | head
```

## After train.done (automatic)

Pipeline `post_train_pipeline.sh` (pid 84834) handles:
1. HF salvage adapter → `unconst/Affine-5czsc2fc98-h1-lora` (private)
2. GPU merge on CUDA 6,7 → `/root/h1/merged`
3. `restart_for_h2.sh` with `MERGE=/root/h1/merged` **`RESTART_KING=0`**
   (chall-only; teacher+king stay hot)
4. Reclaim `/root/merges/h2-kp65` after H1 chall up
5. `run_sim_duel.py` **n=40** → `/root/affine_data/h1_sim_result_n40.json`
6. If ≥50 min to soft deadline 04:50Z: **n=80** →
   `/root/affine_data/h1_sim_result.json` (else n40-only marker)

Done markers: `/root/logs/h1_pipeline.done`, `/root/logs/h1_sim.done`,
`/root/logs/h1_sim_n40.done`. Salvage meta: `/root/h1/adapter_salvage.json`.
