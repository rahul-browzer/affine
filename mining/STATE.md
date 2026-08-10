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
| Lium balance | ~$124,675 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | engines **200/200/200**; H64 n80 Reason sim |

- **p1855:** n80 H64 sim pid **20566** alive @16:44Z: **challenger 19/80, king 19/80** (~2.5 turns/min/side; ETA ~25m).
- Staged R1 SFT data on pod (CPU, no GPU fight):
  - `/root/r1_data/teacher_refs_shortz.jsonl` — 791 rows (legacy refs)
  - `/root/r1_data/high_reason_za.jsonl` — **1403** deduped king `z_A` ranked by Reason (`lpC_yc_za−lpC_yc_e`); mean Reason 0.062; from top-40 public duels
- Harvest script: `experiments/r1-reason-distill/harvest_high_reason.py`

Poll: `cat /root/affine_data/r1_decision.json /root/affine_data/r1_reason_progress.json 2>/dev/null; tail -n 20 /root/logs/r1_reason_sim.log`

## Blocked

- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Do **not** treat telemetry gates as crown blockers.
- HF: `unconst` public storage may still be full — verify before push.
- Coldkey TAO is not convertible without a dated instruction.

## Next action

**Harvest** `/root/affine_data/r1_decision.json` when n80 finishes. Submit only if headroom ≥ **1.5×(3·SE)**. If H64 REFUTE, start R1 train on GPUs **6–7** using `/root/r1_data/high_reason_za.jsonl` (primary) ± teacher_refs_shortz (init = Tok / H64).
