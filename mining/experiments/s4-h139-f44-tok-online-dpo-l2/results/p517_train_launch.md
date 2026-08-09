# p517 — F44 teacher recover → online-DPO train

- Teacher recover332 (p516) reached :8000=200 @ 2026-08-09T09:53:10Z (isolated TCACHE).
- Patched live+local `post_train_pipeline.sh` DEADMAN `06:36Z` → `20:58:00Z` (TTL−30m for remove≈21:28Z); SOFT≈20:28Z. Same stale default that aborted F43.
- `start_h139.sh` → `train_online_dpo.py` pid=15018 on GPUs 6,7; BOOTSTRAP_DONE; post_train waiting `train.done`.
- Engines: teacher+king 200; chall idle until merge.
