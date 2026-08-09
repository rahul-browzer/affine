# H135/F40 pass507 — zero-reward train aborted; teacher recover + retrain

## Finding
- At 08:37Z teacher `:8000=000`, king hung (Triton ENOENT / shm_broadcast on
  GPUs 2,3), train still running on GPUs 6,7.
- All logged RL steps had `mean_r=0.0`, `z0=""`, then
  `[Errno 111] Connection refused` from ~step 38. Adapter was garbage.

## Action
1. Killed train pid=10621; wiped `/root/h135/train`; backed up
   `h135_train.nohup` → `*.p507_zero_reward.bak`.
2. Reaped hung king (pid 5787 + EngineCore/workers on GPUs 2,3).
3. Launched `relaunch_teacher_pass332.sh` → teacher_pid=13954 @08:38:18Z
   TCACHE=`teacher_p332_1786264675_13784`.
4. Armed `/root/logs/h135_relaunch_train_p507.sh`: wait `:8000=200` +
   completions smoke → `king_recover_pass332` + `start_h135.sh`.
5. `post_train_pipeline` pid=10627 still waiting on train.done (kept).

## Next pass check
- `curl :8000/v1/models` → 200; train log shows non-zero `mean_r` and
  non-empty `z0` within ~first 5 steps.
- If teacher fails again → treat pod as hardware-bad (3rd recovery).
