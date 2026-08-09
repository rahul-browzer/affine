# H123/F28 pass472 — gocryptfs finalize unstick

## Symptom
`finalize_full_ft.py` writing `--out /root/h123/merged` stuck in
`WCHAN=request_wait_answer` on `/lium-cipher` (gocryptfs). Shard 11 crawling
~70 MB/s with long stalls; pipeline blocked ~13m.

## Fix
1. Kill finalize pid 10688 + post_train 2409.
2. Finalize `/tmp/h123_full_ft_save` → `/tmp/h123_merged` (same overlay FS).
3. `ln -sfn /tmp/h123_merged /root/h123/merged`.
4. `SKIP_MERGE=1` relaunch `post_train_pipeline.sh`.

## Result
- finalize elapsed **36.1s**, visual 333/333, `OK_NON_IDENTICAL` vs Tok.
- serve_three started 05:25:55Z (teacher :8000 loading).
- Local `post_train_pipeline.sh` now defaults `FULL_FT`/`MERGED` to `/tmp`
  (+ symlink); same patch applied to F26/F27/F29–F35 scripts; F26/F27 pods
  received SCP.
