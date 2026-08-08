# H63 pass265 — merge still writing (preempt armed)

UTC: 2026-08-08T07:57Z · pod noble-eagle-3f

- train.done @ 07:43:06Z → merge started 07:43:21Z
- Writing shards slow vs H64: shard1/2 hit 50% @ 07:56Z (~10m for first shard;
  H64 first shard ~2.5m). Still `merge_lora.py` live; chall:000.
- preempt264 waiting poll~84/240 for chall_serve/merged+8002.
- Next: same bare→recover path as H64 once :8002=200.
