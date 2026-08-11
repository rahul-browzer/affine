# R5 n80 fix (p2124)

## Bug
- Chall served as `vllm serve /root/h122/merged` → model id `/root/h122/merged`
- Sim used `readlink -f` → `/tmp/h122_merged` → completions **404** → FALSE_PROBE rc=42
- Also `max_model_len=32768` knife-edge vs live 65536

## Fix
- Kill chall by PID; relaunch `vllm serve /tmp/h122_merged --max-model-len 65536`
- Patch `relaunch_chall_072.sh` (+ local mining copies) 32768→65536
- Re-arm n80: progress ~42/80 at 22:50Z with matching model id (200s)

## Decision
Pending `h122_decision.json`.
