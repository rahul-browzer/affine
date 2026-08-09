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
| Lium / spend | **~$177,954** · cum ~$19,781 · **avail ~$168.0k** |
| miner burn | **~$31.92/h** (1) ≪$833 · free **19** |
| watch | `mine-f45-1` engines **200/200/200** · TTL~21:35Z (~9.6h) |
| HF | unconst **public storage full** — H64 merged still **downloadable** |
| warm-stack | Triton tar saved (p539); **H64 chall swap in flight** (p540) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f45-1 | lunar-matrix-d4 | 38.255.28.21:20099 | ~21:35Z | **mine-watch-1** warm stack |

On pod: `nohup bash /root/swap_chall_to_h64.sh` → DL `unconst/Affine-5czsc2fc98-h64-merged@4ebe10443f7f` → `/tmp/h64_merged` → kill :8002 → serve H64 util=0.72. Log: `/root/logs/swap_chall_h64.nohup`. Done stamp: `/root/logs/h64_chall_swap.done`.

kh: `/tmp/mine-f45.kh`. SSH key `~/.ssh/id_ed25519`. Non-mine — **do not touch**.

## Blocked

No submit until simulated margin > 0.04 **vs a king with S<0.035** (or live king if recipe clears).
HF Hub push blocked until storage freed/Pro.
Do **not** rent a second `mine-*` without a new dated operator directive.

## Next action

1. On `mine-f45-1`: if `/root/logs/h64_chall_swap.done` → confirm `:8002` id=`/tmp/h64_merged`, engines 200/200/200; update `experiments/warm-stack/serve_commands.md`; if chall `n_so` ≠24 re-tar Triton cache.
2. If swap still running: check DL progress (`du -sh /tmp/h64_merged`); do **not** start a second swap.
3. Renew TTL only if <6h remain. Idle otherwise: record king S, stop.
