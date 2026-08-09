# p473 — F26 train copytree salvage

- Train finished 60/60; `/tmp/h121_full_ft_save` 16/16 shards complete.
- Hung on `shutil.copytree(/tmp → /root/h121/train/full_ft)` WCHAN=`request_wait_answer` (gocryptfs).
- Kill train; `ln -sfn /tmp/h121_full_ft_save /root/h121/train/full_ft`; write `train.done`.
- First post_train aborted rc=2 (race); relaunch → finalize 36.4s OK_NON_IDENTICAL → serve_three.
- Patched `train_full.py` symlink-not-copytree on F26–F35 (local+pods).
