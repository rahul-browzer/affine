# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 3 bootstrap** — Reason v3 crown push (operator 2026-08-10).
King-watch **revoked**. `weight_version_key=3`. Score = mean Reason (Λ2 only).

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · `weight_version_key=3` · crown = margin > 3·SE |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` (reign 4) |
| Lium balance | ~$124,725 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | restore warm stack (pid 1305) |

Restore progress (p1848): vllm 0.22.1 OK · Triton n_so 8/24/24 · HF DL teacher+king+H64 in flight.
Poll: `/root/logs/warm_stack_ready.done` → engines 200/200/200.

## Blocked

- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Do **not** treat telemetry gates (r, bank, baseline, causality) as crown blockers.
- HF: `unconst` public storage may still be full — verify before push.
- Coldkey TAO is not convertible without a dated instruction.

## Next action

**Wait PROMPTABLE on `mine-crown-1`**, then wire Reason-only n=80 duel sim (from `affine/affine/score.py` read-only) and emit paired margin + SE vs Tok af10 (H64 chall first baseline).
