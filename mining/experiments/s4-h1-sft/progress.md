# s4-h1-sft progress

| UTC | event |
|---|---|
| 2026-08-07T01:51:14Z | harvest DONE — 440 examples / 0 missing |
| 2026-08-07T01:51:26Z | train launched pid 82057 on GPUs 6,7 |
| 2026-08-07T01:53:10Z | weights loaded; trainable 8.36M / 34.7B (0.024%) |
| 2026-08-07T01:54:20Z | step 1/110 @ ~63s/it; ETA ~03:50Z |

## How to check

```bash
ssh root@69.63.236.160 -p 40301
kill -0 $(cat /root/logs/h1_train.pid) && tail -20 /root/logs/h1_train.nohup
test -f /root/h1/train/train.done && cat /root/h1/train/train_result.json
```

## After train.done (next pass)

```bash
# free train VRAM first (process exits on its own)
CUDA_VISIBLE_DEVICES=6,7 python3 /root/mining_src/s4-h1-sft/merge_lora.py \
  --base /root/hf/hub/models--kevin954--Affine-5dfqbbh8ev-sft/snapshots/6a5815fad8f4e34c983b1933c1fae5762fe25220 \
  --adapter /root/h1/train/adapter \
  --out /root/h1/merged
# then kill chall vllm, relaunch CHALL_REPO=/root/h1/merged on 4,5,
# then run_sim_duel.py --chall-repo /root/h1/merged
```
