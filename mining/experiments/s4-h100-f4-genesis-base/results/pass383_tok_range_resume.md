# H100/F4 pass383 — CPU merge done; Tok Range-resume

## Merge
- CPU `merge_lora` finished 2026-08-08T21:27:21Z (elapsed 1697s).
- Artifacts: 2 language shards + `model-visual-restored.safetensors` (2.5 GiB);
  arch `Qwen3_5MoeForConditionalGeneration`; identity OK_NON_IDENTICAL.
- `merge_recover_pass376` resumed post_train `SKIP_MERGE=1` + Tok DL.

## Tok race
- post_train `serve_three` launched king=`Tok331102@eb8bf9a` while cache only
  had ~29 GiB partial blobs → raced with `snapshot_download`.
- **huggingface_hub 1.27.0 never resumes**: `_download_to_tmp_and_move` opens a
  fresh `{etag}.{uuid8}.incomplete` with `"wb"` and deletes it on failure.
  Orphaned 12 GiB + 17 GiB incompletes from earlier hub behavior were ignored.

## Fix
- Killed king APIServer (GPUs 2,3) + non-resuming Tok DL; kept teacher.
- Dropped small uuid incompletes; kept ≥1 GiB orphans.
- `nohup` Range-resume script (`h100_tok_range_resume_pass383.nohup`):
  HTTP `Range: bytes={have}-` into `{sha}.range.incomplete`, then rename to
  blob + snapshot pointers; stamp `/root/logs/tok331102.done`.
- At launch: shard2 17.66→35.11 GiB (50%), shard1 12.59→35.10 GiB pending;
  9/9 small files already present. Growth confirmed (~51.8% @ 21:30Z).

## Next
- Await `tok331102.done` (~35 GiB remaining across 2 shards).
- prewarm waiter pid=9400 still polling `tok331102.done` → `prewarm_engines.sh`.
- post_train may need king+chall re-serve after Tok complete (king was killed;
  serve_three child gone; teacher still loading).
