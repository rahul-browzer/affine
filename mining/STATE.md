# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 3→4** — new crown pod online; warm stack not yet restored. `weight_version_key=3`.

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · crown = margin > 3·SE |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` |
| corpus | epoch **7** · schema v2 (re-sync on new pod) |
| Lium | ~$122,516 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| **R2ai** | **RESET** — old lunar-orbit-50 died REBOOT_FAILED mid-n80 |
| board | duel **chal-00468** sbs-v0 (was scoring) |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | fresh 8×B200 · empty · needs warm restore |

- Host hist bridge pid **1202431** (SSH consts updated → new pod; restart if stamp needed)
- Old pod `lunar-orbit-50` **removed** (SSH port None after REBOOT_FAILED)

## Blocked

- No TKC engines until `experiments/warm-stack/restore_warm_stack.sh` on new box.
- B300 sold out → B200 fallback (@$52.25/h). Re-prefetch parents after restore.
- Submit only if sim hr ≥ **1.5×**.

## Next action

**Bootstrap warm stack** on new `mine-crown-1` (HF token → restore TK@65536 → corpus sync) → re-arm R2ai pure sbs-v0 n80 (or next Reason+ 469–471).
