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
| Lium / spend | **~$176,750** · cum ~$20,995 · **avail ~$166.8k** |
| miner burn | **~$28.00/h** (1) ≪$833 · free **19** |
| watch | `mine-watch-1` / golden-wolf-bd · TTL **2026-08-10T03:38Z** (~5.9h) |
| restore | **IN PROGRESS** pid=901 · **HF DL** ~111G hub (teacher+king+h64 locks) · triton n_so 8/24/24 · engines 000 · no ready.done |
| HF | unconst **public storage full** — H64 still **downloadable** |
| warm-stack | Triton tar on pod; `restore_warm_stack.sh` stages: pip→triton→DL→serve |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-watch-1 | golden-wolf-bd | 152.236.142.236:40301 | **03:38Z** | warm stack restore |

Chall target: `/tmp/h64_merged` ← `unconst/Affine-5czsc2fc98-h64-merged@4ebe10443f7f`.
King: Tok af10 @ eb8bf9a. Teacher: GLM-4.5-Air-FP8.
SSH: `~/.ssh/id_ed25519` (`IdentitiesOnly=yes`).
Non-mine pods — **do not touch** (incl. `affine-*`, `minimax-*`).

## Blocked

No submit until simulated margin > 0.04 **vs a king with S<0.035** (or live king if recipe clears).
HF Hub push blocked until storage freed/Pro.
Do **not** rent a second `mine-*` without a new dated operator directive.
`lium schedules` has **no re-add** — leave Removal intact; never `schedules rm` to "renew".

## Next action

1. Poll restore: `tail /root/logs/restore_warm_stack.log`; wait for `/root/logs/warm_stack_ready.done` + engines **200/200/200** and `:8002`=/tmp/h64_merged.
2. If restore dead/failed: read log, relaunch `/root/restore_warm_stack.sh` (do not rent a second pod).
3. If ready: KING-WATCH idle — record king S; confirm engines; leave TTL (expires 03:38Z).
4. If king S < 0.035 → H64 n80 re-screen on this single watch pod only.
