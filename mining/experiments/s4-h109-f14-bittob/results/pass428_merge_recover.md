# F14 pass428 — GPU merge save hang → CPU recover393

**UTC:** 2026-08-09T01:06:15Z on `mine-f14-1` (eager-comet-be).

## Symptom (same as H95/H100/F13)
- `merge_lora.py --device-map auto` reached `Writing model shards: 0/2`
- `.tmp*` size flat at **49739502312** B
- `WCHAN=request_wait_answer`, `write_bytes=4096` / `cancelled_write_bytes=4096`
- Teacher:8000 + king:8001 still 200; chall:8002 down (expected mid-merge)

## Action
Launched existing `merge_recover_pass393.sh` (Bittob BASE @0c04fe92):
- killed merge pid 13229 + post_train 2749
- CPU merge `--device-map cpu` live (pid 14222) @01:06:24Z
- on DONE → `merge.done` + `post_train SKIP_MERGE=1` + preempt rearm

## Follow
Poll `h109_merge_recover_pass393.nohup` for `DONE recover393`, then chall serve → n80 d203.
