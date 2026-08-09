# p509 — F42 teacher/king recover → train launched

**Symptom:** bootstrap stuck since 08:32Z waiting `:8000`; GPUs empty; `h137_n80_retry.aborted`=`aborted_engines_unhealthy`.
**Cause:** bare Triton race — teacher ENOENT `__triton_launcher.so` (POHQPAXF…); king ENOENT `fused_moe_kernel.json` (XKAYGTTQ…).
**Action:** `relaunch_teacher_pass332.sh` (TCACHE `teacher_p332_*`) + `king_recover_pass332.sh` (GPUs 2,3).
**Result:** teacher `:8000` up ~09:03:29Z → bootstrap iter=123 → `train_bon_l2.py` pid=19740 (G=4, max_steps=150, GPUs 6,7) + `post_train_pipeline` pid=19746. King loading util=0.72.
**Check:** `tail /root/logs/h137_train.nohup`; `:8000`/`:8001` `/v1/models`.
