# p2112 — R4/H121 train gocryptfs salvage

- Train finished 26/26; Trainer hung WCHAN=`request_wait_answer` writing `optimizer.pt` (111G) to `/root` (fuse.gocryptfs).
- Model shards complete in `checkpoints/checkpoint-26` (~47G+19G). Never reached `/tmp` save.
- Kill PID 2488; stage shards+tok → `/tmp/h121_full_ft_save`; `ln -sfn` → `train/full_ft`; stamp `train.done`.
- post_train → finalize OK_NON_IDENTICAL → serve_three started 21:20Z.
- Patched `train_full.py` `save_strategy="no"` (local+pod) so Trainer won't dump optimizer onto gocryptfs again.
