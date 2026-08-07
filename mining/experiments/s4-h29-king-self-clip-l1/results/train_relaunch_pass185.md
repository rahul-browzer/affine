# H29 train relaunch (pass 185)

- First train (pid2365) died: `supervised_tokens=0/8192` on raw row0
  (msg_chars=41524; fence verify still passed — char-level ≠ token fit).
- Fit-filter: msg_chars ≤ 8192×2.5=20480 → **368/686** kept; sorted short-first;
  row0=`pygments…pr_2551:2` msg_chars=5847. Backup:
  `/root/h29/king_self_high_l1.raw686.jsonl`. Meta: `fit_filter.json`.
- Relaunch pid4341 @19:34Z; `sample0 supervised_tokens=59/1513`; `[train] starting`.
- `train_lora.py` now applies the same fit-filter in-process.
- post_train_pipeline (pid2373) still waiting on `train.done`.
