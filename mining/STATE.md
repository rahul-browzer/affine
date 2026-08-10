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
| Lium / spend | **~$175,548** · cum ~$22,048 · **avail ~$165.5k** |
| miner burn | **~$28.00/h** (1) <<$833 · free **19** |
| watch | `mine-watch-1` / golden-wolf-bd · TTL **2026-08-10T13:59Z** (~4.0h) |
| restore | **READY** · `:8000/:8001/:8002` = **200/200/200** · `warm_stack_ready.done` |
| HF | unconst **public storage full** — H64 still **downloadable** |
| warm-stack | Triton tar on pod; `restore_warm_stack.sh` stages: pip→triton→DL→serve |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-watch-1 | golden-wolf-bd | 152.236.142.236:40301 | **13:59Z** | warm stack **READY** |

Engines: teacher=`zai-org/GLM-4.5-Air-FP8` :8000; king=Tok af10@eb8bf9a :8001; chall=`/tmp/h64_merged` (H64@4ebe104) :8002.
SSH: `~/.ssh/id_ed25519` (`IdentitiesOnly=yes`).
Non-mine pods — **do not touch** (incl. `affine-*`, `minimax-*`).

## Blocked

No submit until simulated margin > 0.04 **vs a king with S<0.035** (or live king if recipe clears).
HF Hub push blocked until storage freed/Pro.
Do **not** rent a second `mine-*` without a new dated operator directive.
`lium schedules` has **no re-add** — leave Removal intact; never `schedules rm` to "renew".
p1440/p1726: `lium up` w/ same `--name` **resets Removal to +6h** *and* spawns empty dup — **rm dup same pass**; keep READY golden-wolf-bd.

## Next action

1. KING-WATCH idle: record live king S; confirm engines 200/200/200; when TTL ≲45m (~13:15Z) re-rent same-name path again.
2. Re-rent: catalog 8×H200 ≤$32/h (`--ttl 6h`); expect TTL refresh + empty dup → rm dup; keep READY stack. Only full restore if old TTL did **not** refresh.
3. If any engine dies: relaunch `/root/restore_warm_stack.sh` on this pod only. King util=0.80 OOM → 0.72 + isolated TCACHE.
4. If king S < 0.035 → H64 n80 re-screen on this single watch pod only.
