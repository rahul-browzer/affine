# F13 p427 — GPU merge hang → CPU recover

## Evidence
- `merge_lora.py --device-map auto` pid 13709: `WCHAN=request_wait_answer`
- `/root/h108/merged/.tmpuGK0zx` stuck at **49739502312** B (flat over ≥2s)
- GPUs 6,7 ~34 GiB util 0% after load; save hung mid-shard 1/2

## Action
- Launched `merge_recover_pass393.sh` @01:02:02Z
- Killed merge 13709 + post_train 3193
- CPU merge started (`device-map cpu`, GPUs 6,7 freed to 0 MiB)

## Expected next
- merge.done → post_train `SKIP_MERGE=1` → chall serve → freeze → n80 d203
