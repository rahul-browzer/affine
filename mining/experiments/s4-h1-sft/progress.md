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
| 2026-08-07T02:18:50Z | Lium TTL cancelled; host deadman 07:00Z; pipe **86845** soft 06:50Z; step 26 |
| 2026-08-07T02:21:57Z | step **30/110** @ ~59s/it; ETA ~**03:41Z**; HF write probe OK; host harvest **1414858** scrapes `results/h1_train_progress.json` |
| 2026-08-07T02:26:01Z | step **34/110** @ ~56s/it; ETA ~**03:37Z**; found stdout loss gap (tqdm+nohup); harvest **1421187** scrapes `trainer_state` loss + `h1_train_loss.json`; PrintLossCallback in train_lora.py for future runs |

## How to check

```bash
# Local (no SSH) — updated every ~60s by host harvest:
cat experiments/s4-h1-sft/results/h1_train_progress.json

ssh -i ~/.ssh/id_ed25519 -p 40301 root@69.63.236.160
kill -0 $(cat /root/logs/h1_train.pid) && tail -20 /root/logs/h1_train.nohup
kill -0 $(cat /root/logs/h1_pipeline.pid) && tail -20 /root/logs/h1_pipeline.nohup
test -f /root/affine_data/h1_sim_result.json && cat /root/affine_data/h1_sim_result.json | head
```

## After train.done (automatic)

Pipeline `post_train_pipeline.sh` (pid **86845**) handles:
1. HF salvage adapter → `unconst/Affine-5czsc2fc98-h1-lora` (private)
2. GPU merge on CUDA 6,7 → `/root/h1/merged`
3. `restart_for_h2.sh` with `MERGE=/root/h1/merged` **`RESTART_KING=0`**
   (chall-only; teacher+king stay hot)
4. Reclaim `/root/merges/h2-kp65` after H1 chall up
5. `run_sim_duel.py` **n=40** → `/root/affine_data/h1_sim_result_n40.json`
6. If ≥50 min to soft deadline **06:50Z**: **n=80** →
   `/root/affine_data/h1_sim_result.json` (else n40-only marker)
   Host deadman kills pod at **07:00Z**.

Done markers: `/root/logs/h1_pipeline.done`, `/root/logs/h1_sim.done`,
`/root/logs/h1_sim_n40.done`. Salvage meta: `/root/h1/adapter_salvage.json`.
| 2026-08-07T03:08:17Z | step **79/110**; host harvest **1486917** early-teardown accepts train_fallback/train.done + mid/merged salvage (was blocked on train_result only); chal-00274 H6 scoring; ETA train.done ~03:37Z |
| 2026-08-07T03:11:56Z | step **84/110**; triage **live-king guard** (User-Agent fetch; `re_sim_new_king` / `confirm_live_king`); sim writes `king_rev`; SCP'd `run_sim_duel.py`; H6 scoring **70/80**; ETA train.done ~**03:36Z** |
