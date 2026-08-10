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

- **p1854:** n80 H64 sim pid **20566** alive (watcher 17015). Progress @16:38Z: **challenger 5/80, king 7/80**. Teacher GPUs 0–1 ~100%.
- Fixed ops landmine: `/root/mine.env` lacked `export` → sim child had **no HF_TOKEN** (unauth HF warn). Rewrote exports + `set -a` in `launch_when_ready.sh` (pod + local). Did **not** restart running sim.
- H64: `/tmp/h64_merged` → `unconst/Affine-5czsc2fc98-h64-merged` @ `4ebe104…` (3 shards, GPUs 4–5 loaded).

Poll: `cat /root/affine_data/r1_decision.json /root/affine_data/r1_reason_progress.json 2>/dev/null; tail -n 20 /root/logs/r1_reason_sim.log`

## Blocked

- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Do **not** treat telemetry gates as crown blockers.
- HF: `unconst` public storage may still be full — verify before push.
- Coldkey TAO is not convertible without a dated instruction.

## Next action

**Harvest** `/root/affine_data/r1_decision.json` when n80 finishes (~tens of min at current pace). Submit only if headroom ≥ **1.5×(3·SE)**. If H64 REFUTE, start R1 train/distill on same pod (GPUs 6–7 free).
