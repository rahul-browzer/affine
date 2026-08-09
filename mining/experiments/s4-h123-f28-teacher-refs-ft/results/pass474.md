# pass 474 — F28 n80 start + fleet unstick

- F28: chall recover salvage (Triton ENOENT → pre-frozen TCACHE) → engines double-promptable → **n80 attempt 1/6 d203 @05:38:42Z**; progress `challenger=1/80` by 05:40:31Z.
- F27: train.done since 05:29 but post_train aborted (live-script edit syntax); relaunch → finalize **32.4s** OK_NON_IDENTICAL → serve_three.
- F29/F30: copytree hang salvaged (symlink `/tmp/*_full_ft_save`); pod `MERGED=/root/...` hung finalize (`request_wait_answer`) → scp local `/tmp` post_train → finalize OK → serve.
- F31: premature kill at 5/16 shards undone; finalize from `checkpoint-60` → `/tmp/h126_merged`.
- F33–F35: `TrainingArguments(tf33/tf34/tf35=True)` → TypeError; fixed to `tf32=True`, trains relaunched.
