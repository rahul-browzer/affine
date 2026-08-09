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
| Lium / spend | **~$176,791** · cum ~$20,954 · **avail ~$166.8k** |
| miner burn | **~$31.92/h** (1) ≪$833 · free **19** |
| watch | `mine-f45-1` engines **200/200/200** · TTL **21:35Z (~0.25h)** |
| HF | unconst **public storage full** — H64 merged still **downloadable** |
| warm-stack | Triton tar p539 sha e55237b1…; **H64 chall LIVE** `/tmp/h64_merged` |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f45-1 | lunar-matrix-d4 | 38.255.28.21:20099 | **21:35Z** | **mine-watch-1** warm stack |

Chall: `/tmp/h64_merged` ← `unconst/Affine-5czsc2fc98-h64-merged@4ebe10443f7f`.
King: Tok af10 @ eb8bf9a. Teacher: GLM-4.5-Air-FP8. chall n_so=24.

SSH: `~/.ssh/id_ed25519` (`IdentitiesOnly=yes`). `/tmp/mine-f45.kh` libcrypto-broken — ignore.
Non-mine pods — **do not touch** (incl. `affine-*`, `minimax-*`).

## Blocked

No submit until simulated margin > 0.04 **vs a king with S<0.035** (or live king if recipe clears).
HF Hub push blocked until storage freed/Pro.
Do **not** rent a second `mine-*` without a new dated operator directive.
`lium schedules` has **no re-add** — leave Removal intact; never `schedules rm` to "renew".

## Next action

1. If `mine-f45-1` **gone** (TTL **21:35Z**): rent **one** `mine-watch-1` 8×H200 ≤$32/h `--ttl 6h` by UUID (p1113 catalog verified 4/4):
   - **1st** `37b3ea5c-d447-41ab-aac2-730437842243` lunar-eagle-9e **$28.00** dl=1025 — prefer for H64 66G DL
   - **2nd** `ea473ae7-0110-4a64-8a02-a47c03812548` golden-raven-d3 **$28.00** dl=553
   - alts: `646dcae7-d20f-47c2-828e-8dbaa0fc216d` noble-wolf-32 $24.40 / `4e66b752-a3f6-45c6-9c39-0d274c74bed8` lunar-shark-33 $23.20
   - verify COUNT=8 post-rent. Restore `experiments/warm-stack/` (tar sha e55237b1…; `serve_commands.md`); re-DL H64 → `/tmp/h64_merged`.
2. If pod still up: KING-WATCH idle — record king S; confirm engines 8000/8001/8002=200 + `:8002`=/tmp/h64_merged; **do not** rent a second pod.
3. If king S < 0.035 → H64 n80 re-screen on the single watch pod (never a second).
