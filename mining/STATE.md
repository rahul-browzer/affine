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
| Lium / spend | **~$177,020** · cum ~$20,719 · **avail ~$167.0k** |
| miner burn | **~$31.92/h** (1) ≪$833 · free **19** |
| watch | `mine-f45-1` engines **200/200/200** · TTL 21:35Z (~2.6h) |
| HF | unconst **public storage full** — H64 merged still **downloadable** |
| warm-stack | Triton tar p539; **H64 chall LIVE** `/tmp/h64_merged` |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f45-1 | lunar-matrix-d4 | 38.255.28.21:20099 | 21:35Z | **mine-watch-1** warm stack |

Chall: `/tmp/h64_merged` ← `unconst/Affine-5czsc2fc98-h64-merged@4ebe10443f7f`.
King: Tok af10 @ eb8bf9a. Teacher: GLM-4.5-Air-FP8. chall n_so=24.

SSH: `~/.ssh/id_ed25519` (`IdentitiesOnly=yes`). `/tmp/mine-f45.kh` libcrypto-broken — ignore.
Non-mine pods — **do not touch** (incl. `affine-*`, `minimax-*`).

## Blocked

No submit until simulated margin > 0.04 **vs a king with S<0.035** (or live king if recipe clears).
HF Hub push blocked until storage freed/Pro.
Do **not** rent a second `mine-*` without a new dated operator directive.
`lium schedules` has **no re-add** — leave Removal at intact; never `schedules rm` to "renew".

## Next action

1. KING-WATCH idle: record live king S; confirm `mine-f45-1` engines 8000/8001/8002=200 and `:8002` id=`/tmp/h64_merged`.
2. Renew TTL only if <6h remain **and** a re-add path exists (today: none — leave 21:35Z). Else stop.
3. If king S < 0.035 → start H64 n80 re-screen on this pod (do not rent a second).
4. If pod gone after 21:35Z → restore from `experiments/warm-stack/` (tar sha e55237b1…) on a fresh `mine-watch-*` ≤$32/h.
