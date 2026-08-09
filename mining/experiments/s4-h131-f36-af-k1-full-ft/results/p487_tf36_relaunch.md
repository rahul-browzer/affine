# p487 — F36 train relaunch after tf36

- First launch @06:32Z loaded weights then died:
  `TypeError: TrainingArguments.__init__() got an unexpected keyword argument 'tf36'`
- Cause: family-number sed of `tf32` → `tf36` in `train_full.py` (same class as F33–F35 p474).
- Fix: `tf36=True` → `tf32=True` (local + pod). Relaunch pid=6090 @06:37:20Z.
- Confirmed past TrainingArguments: trainable=34.6B, fit-filter 477/1059, trainer 0/60.
- post_train_pipeline (pid 2553) still waiting on `train.done` — left alone.
