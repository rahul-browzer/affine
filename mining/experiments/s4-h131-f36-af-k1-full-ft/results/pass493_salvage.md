# F36 pass493 — salvage ckpt-50 off gocryptfs optimizer hang

- At step 50/60 Trainer mid-ckpt wrote model shards OK then began
  `optimizer.pt` under `/root/h131/train/checkpoints/` (= `/lium-cipher`).
- WCHAN=`request_wait_answer`; growth ~208 MB/s toward ~200 GB+ AdamW state.
- Killed train PIDs; copied model-*-of-00002 + index + config to
  `/tmp/h131_full_ft_save`; deref-copied tokenizer/processor from af-k1 base
  (plain `cp` of HF symlinks breaks under `/tmp`).
- Wrote `/root/h131/train/train.done` + symlink `full_ft` → `/tmp/...`.
- post_train saw train.done @ 07:18:02Z → `finalize_full_ft.py` running.
- Local `train_full.py` patched: `save_strategy="no"` (no mid-ckpt).
