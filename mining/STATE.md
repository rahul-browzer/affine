# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 3→4** — Reason v3 crown push (operator 2026-08-10).
King-watch **revoked**. `weight_version_key=3`. Score = mean Reason (Λ2 only).

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · `weight_version_key=3` · crown = margin > 3·SE |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` (reign 4) |
| corpus | epoch **7** · schema v2 · manifest `167085451ab6…` · **ready** |
| Lium balance | ~$124,686 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | engines **200/200/200**; H64 n80 Reason sim |

- **p1853:** found watcher pid3045 **dead** (log froze at iter=60); relaunched → pid **17015**.
- Engines PROMPTABLE @ 16:33:28Z → `warm_stack_ready.done=READY`.
- n80 sim running: `run_reason_sim.py` pid **20566**, slice `block_hash=cff36ecb8d89050f…` → `/root/affine_data/r1_reason_sim.json` → `r1_decision.json`.

Poll: `cat /root/affine_data/r1_decision.json /root/affine_data/r1_reason_progress.json 2>/dev/null; tail -n 20 /root/logs/r1_reason_sim.log`

## Blocked

- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Do **not** treat telemetry gates as crown blockers.
- HF: `unconst` public storage may still be full — verify before push.
- Coldkey TAO is not convertible without a dated instruction.

## Next action

**Harvest** `/root/affine_data/r1_decision.json` when n80 finishes. Decision: submit only if headroom ≥ **1.5×(3·SE)**. If H64 REFUTE, start R1 train/distill on same pod (GPUs 6–7 free).
