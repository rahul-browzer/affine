# F22/H117 pass470 — Tok king Range-resume

## Symptom
- Bootstrap hung mid `snapshot_download(Tok@eb8bf9a)` after teacher+everest done.
- Two uuid `.incomplete` blobs: shard1 ~5.2 GiB/35.1 GiB (slow), shard2 ~9.1 GiB frozen @05:09Z.
- Many CLOSE-WAIT HF sockets; huggingface_hub 1.27 never resumes incompletes.

## Action
- Killed bootstrap python pid=2612 + bash pid=1222.
- Adopted hub incompletes → `{sha}.range.incomplete`.
- `nohup tok_range_resume_serve_p470.sh`: parallel HTTP `Range: bytes={have}-` → both shards HTTP **206**.
- On complete: symlink into snapshot, stamp `tok331102.done`, `sync_corpus` + `serve_three`, clear `h117_n80_retry.aborted`.

## At launch (2026-08-09T05:14:18Z)
- shard1 `3e0bd…` 5200691363/35101763136 (14.8%)
- shard2 `da0b5f…` 9712203980/35112732728 (27.7%)
- Growth confirmed within 20s (shard1→5.9G, shard2→10.2G).

## Next
- Await `tok331102.done` + `:8000/:8001/:8002=200` → n80 watcher fires.
- Log: `/root/logs/h117_tok_range_p470.nohup`
