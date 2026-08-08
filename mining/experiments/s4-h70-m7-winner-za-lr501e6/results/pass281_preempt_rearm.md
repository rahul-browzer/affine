# Pass 281 — H70 preempt rearm (late merge)

**UTC:** 2026-08-08T10:08Z
**Pod:** mine-h70-1 (cosmic-raven-9e)

## Why

Merge still writing shard2 (`.tmpu6PY6V` ~19G; shard1 49.7G done) while
`watch_preempt_bare_tcache_pass264` was at poll **144/240**. Same late-merge
failure mode as H69 (p277 @216/240 TIMEOUT). Rearm by PID before TIMEOUT.

## Action

- Killed preempt PID **942**; relaunched → PID **13587**
- Log: `START wait chall_serve/merged+8002` @ 10:08:08Z
- Marker: `/root/affine_data/h70_pass281_preempt_rearm.json`

## Concurrent status (not finished)

| item | state |
|---|---|
| merge_lora | running pid10950; no merge.done |
| Tok retarget DL | incomplete blob ~32G growing; scripts already patched to Tok331102@eb8bf9a |
| chall_serve | not started (waits merge) |
| n80 | retry armed; waits engines |

Next: merge.done → chall serve → retarget swaps :8001 → n80 vs Tok → `decision.json`.
