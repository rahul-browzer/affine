# H72 pass290 — recover264 after bare-cache Triton ghost

## Symptom
- Merge done (`/root/h72/merged` present; `/root/logs/h72_merge.done` @10:43Z).
- post_train stuck: `wait_ready` t=1 k=1 c=0 for ≥560s; GPUs 4,5 = 0 MiB.
- `:8002` down. Teacher/king `:8000/:8001` = 200.

## Root cause
`vllm_chall.log` EngineCore fail:
`[Errno 2] … '/root/.triton/cache/chall/…/fused_moe_kernel.ttir'`
Bare post_train chall on `/root/.triton/cache/chall` died mid-load (ghost ENOENT).

## Action
2026-08-08T10:54:22Z launched
`relaunch_chall_pass264.sh` (pid 16974, nohup
`/root/logs/h72_recover264_pass290.nohup`).
Recover killed stuck post_train/retry/wait_ready; wiped chall caches;
attempt 1/3 king-seed writable diverse-warm → freeze.
Teacher+king left alone (still 200).

## Next
Await recover DONE → `h72_chall_serve.done` + rearmed n80 vs Tok.
Do not sed post_train; do not second recover while pid alive.
