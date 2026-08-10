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
| corpus | epoch **7** · schema v2 · manifest `167085451ab6…` on pod |
| Lium balance | ~$124,719 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | HF DL (~44G+) + restore pid1305; Reason watcher pid3045 |

- Corpus: **DONE** (`/root/logs/corpus.done`, v2 index present).
- Restore: still downloading teacher/king/H64 → then serve → `warm_stack_ready.done`.
- Auto: `launch_when_ready.sh` pid **3045** will run n=80 H64 vs Tok when engines 200/200/200.
- Harness: `/root/mining_src/{affine_pkg,r1-reason-distill,s3-duel-sim}` uploaded.

Poll: `cat /root/logs/warm_stack_ready.done /root/affine_data/r1_decision.json 2>/dev/null`

## Blocked

- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Do **not** treat telemetry gates as crown blockers.
- HF: `unconst` public storage may still be full — verify before push.
- Coldkey TAO is not convertible without a dated instruction.

## Next action

**Harvest** `/root/affine_data/r1_decision.json` when watcher finishes (or unblock if restore stuck). Decision rule: submit only if headroom ≥ **1.5×(3·SE)**. If H64 REFUTE, start R1 train/distill on same pod.
