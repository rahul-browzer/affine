# R3b — GRPO alt-LR/rank results

## p2127 — launched on mine-r3-grpo-1 (2026-08-11T23:03Z)

- **Why here:** R3 REFUTE on this pod; T/K warm; GPUs 6–7 free; no free 8×B300 to rent `mine-r3-grpo-2`.
- **Knobs:** lr=2e-5, LoRA r=64/α128, G=8, max_new=512, max_steps=200, Tok af10 init, reward=Reason.
- **Train pid:** 51672 · log `/root/logs/r3_train.nohup` · meta `r3b_train_launched.json`.
- **Post-train:** `post_train_pipeline.sh` waiting on `train.done` → `/tmp/r3_merged` → n80.
- **Fleet:** removed `mine-r3-grpo-2` from rent QUEUE (no duplicate axis).
- **Check:** `ssh -p 40051 root@204.9.206.245 'tail -f /root/logs/r3_train.nohup'`
