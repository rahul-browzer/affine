# H136/F41 pass510 — zero-reward train aborted; teacher recover + retrain

## Finding
- At 09:06Z teacher `:8000=000`, king `:8001=200`, train pid=10459 still on GPUs 6,7 @step≈140.
- Teacher died **on first RL score** @08:34:07Z: Triton ENOENT
  `cache/teacher/EAUHKKZRGQP45BZT…/__triton_launcher.so` → EngineDead → 500 then refuse.
- All 31 logged steps had `mean_r=0.0` (Connection refused from step 0). Adapter garbage.
- Orphan `VLLM::Worker` still held GPUs 0,1 after APIServer exit.

## Action
1. Killed train pid=10459; wiped `/root/h136/train`; backed up
   `h136_train.nohup` → `*.p510_zero_reward.bak`.
2. `relaunch_teacher_pass332.sh` → teacher_pid=18438 @09:08:21Z
   TCACHE=`teacher_p332_1786266476_18272` (reaped orphans 7804/7805).
3. Armed `/root/logs/h136_relaunch_train_p510.sh`: wait `:8000=200` +
   completions smoke → `start_h136.sh` (king left alone).
4. `post_train_pipeline` pid=10465 still waiting on train.done (kept).

## Next pass check
- `curl :8000/v1/models` → 200; train log shows non-zero `mean_r` within ~5 steps.
- If teacher dies again on first score → hardware-bad / 3rd recovery → tear+rent.
