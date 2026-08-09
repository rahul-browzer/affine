# F17 / H112 — pass 449 king_recover_pass449

## Symptom
Mid-n80 EngineDead on king `:8001` @02:43:32Z (challenger 14/80 →
`httpx.ConnectError`). Orphan `VLLM::Worker` ppid=1 on GPUs 2,3 (pids
9009/9010). Teacher `:8000=200`, chall `:8002=200` left alone. Retry
watcher already waiting engines (attempt 1 failed rc=1).

## Action
Armed `king_recover_pass449.sh`: reap GPUs 2,3 → seed isolated king
TCACHE from live chall (`n_so=23`) → `vllm serve` Tok @ util=0.72.
Watcher `retry_h112_n80_d203first` remains armed.

## Check next
`curl :8001/health` + completions probe; `/root/logs/h112_king_recover_pass449.done`;
n80 relaunch in `h112_n80_retry.nohup`.
