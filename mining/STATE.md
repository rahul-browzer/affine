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
| watch | `mine-f45-1` (=watch) engines **200/200/200** · TTL~21:35Z |
| HF | unconst **public storage full** — local MERGED ok; push blocked |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f45-1 | lunar-matrix-d4 | 38.255.28.21:20099 | ~21:35Z | **mine-watch-1** warm stack |

kh: `/tmp/mine-f45.kh`. SSH key `~/.ssh/id_ed25519`. Non-mine — **do not touch**.
Closed-class n80s aborted p538: F44@42/80, F45@13/80, F46 mid-flight — no margins.

## Blocked

No submit until simulated margin > 0.04 **vs a king with S<0.035** (or live king if recipe clears).
HF Hub push blocked until storage freed/Pro.
Do **not** rent a second `mine-*` without a new dated operator directive.

## Next action

1. On `mine-f45-1`: snapshot warm stack → `experiments/warm-stack/`
   (Triton cache tar + exact serve/merge commands).
2. Merge best Tok-init winner-zA (H64 r=18) locally on the pod; leave ready
   as challenger (HF push optional/blocked).
3. Renew TTL if <6h remain. Then idle: record king S, check pod, stop.
