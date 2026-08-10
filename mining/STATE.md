# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**KING-WATCH** (operator 2026-08-09T10:45Z). Exploration suspended.
Fleet = **1** warm pod. No submit. Trigger: king **S < 0.035** → re-screen H64 r=18.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| trigger | **idle** (need S < 0.035; live 0.04456) |
| Lium / spend | **~$175,957** · cum ~$21,780 · **avail ~$166.0k** |
| miner burn | **~$28.00/h** (1) <<$833 · free **19** |
| watch | `mine-watch-1` / golden-wolf-bd · TTL **2026-08-10T08:50Z** (~3.0h) |
| restore | **READY** · `:8000/:8001/:8002` = **200/200/200** · `warm_stack_ready.done` |
| HF | unconst **public storage full** — H64 still **downloadable** |
| warm-stack | Triton tar on pod; `restore_warm_stack.sh` stages: pip→triton→DL→serve |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-watch-1 | golden-wolf-bd | 152.236.142.236:40301 | **08:50Z** | warm stack **READY** |

Engines: teacher=`zai-org/GLM-4.5-Air-FP8` :8000; king=Tok af10@eb8bf9a :8001; chall=`/tmp/h64_merged` (H64@4ebe104) :8002.
SSH: `~/.ssh/id_ed25519` (`IdentitiesOnly=yes`).
Non-mine pods — **do not touch** (incl. `affine-*`, `minimax-*`).

## Blocked

No submit until simulated margin > 0.04 **vs a king with S<0.035** (or live king if recipe clears).
HF Hub push blocked until storage freed/Pro.
Do **not** rent a second `mine-*` without a new dated operator directive.
`lium schedules` has **no re-add** — leave Removal intact; never `schedules rm` to "renew".
p1440: `lium up` w/ same `--name` **did** reset Removal on golden-wolf-bd to +6h **and** spawned a second pod — immediately revoke the empty duplicate (done).

## Next action

1. KING-WATCH idle until TTL ≲45m (~08:05Z): record live king S; confirm engines 200/200/200.
2. If TTL ≲45m: re-rent on catalog 8×H200 ≤$32/h (`--ttl 6h`), COUNT=8, upload warm-stack tar + `restore_warm_stack.sh`, nohup restore; `lium rm` old **only after** new READY. Expect a duplicate spawn — rm the empty one if old TTL already refreshed.
3. If any engine dies: relaunch `/root/restore_warm_stack.sh` on this pod only. King util=0.80 OOM → 0.72 + isolated TCACHE.
4. If king S < 0.035 → H64 n80 re-screen on this single watch pod only.
