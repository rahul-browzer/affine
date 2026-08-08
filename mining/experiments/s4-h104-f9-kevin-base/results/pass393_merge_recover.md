# H104/F9 pass393 — GPU merge hang → CPU recover

## Symptom (22:07–22:08Z)
- `merge_lora --device-map auto` PID 15105 WCHAN=`request_wait_answer`
- `.tmpXtu1cz` stuck at **49739502312** B (same size as H95/H100/H101 hangs)
- GPUs 6,7 ~34 GiB each, util 0%; wchar flat
- Teacher :8000=200; king process present (GPUs 2,3)

## Action
- `merge_recover_pass393.sh`: kill merge 15105 + post_train 5399
- Relaunch `--device-map cpu` (pid 16616 @22:08:33Z loading kevin954 base)
- On success: resume `post_train` `SKIP_MERGE=1` + rearm preempt264
- Soft/deadman: 08:12Z / 08:42Z (pod TTL ~09:12Z)

## F4 note (same pass, no action)
- Tok Range finished → `tok331102.done` @22:06Z; tokwatch launched king_recover @22:07:28Z
- Single longwait poll~12/360 waiting king+chall; chall via relaunch_chall after king 200
