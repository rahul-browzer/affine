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
| corpus | epoch **7** · schema v2 · manifest `167085451ab6…` · **ready** |
| Lium balance | ~$124,697 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | vLLM teacher/king/H64 loading; Reason watcher pid3045 |

- Teacher DL finished (~f9a9c5acf5…). First restore pid1305 died after DL: bash `syntax error near **kw` (script edited mid-run).
- **p1852:** killed broken restore; installed `restore_warm_stack.sh.new` → live; relaunched pid **9697**.
- Engines up: vllm pids 9910/9923/9936 on :8000/:8001/:8002 — loading weights (NCCL ok; not 200 yet).
- B300 flash + Tok preprocessor confirmed; `/tmp/h64_merged` linked; watcher still waiting → n80.

Poll: `cat /root/logs/warm_stack_ready.done /root/affine_data/r1_decision.json 2>/dev/null`

## Blocked

- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Do **not** treat telemetry gates as crown blockers.
- HF: `unconst` public storage may still be full — verify before push.
- Coldkey TAO is not convertible without a dated instruction.

## Next action

**Harvest** `/root/affine_data/r1_decision.json` when watcher finishes (engines → 200/200/200 → n80). If any engine dies, check `vllm_*.log` for flash/preproc. Decision: submit only if headroom ≥ **1.5×(3·SE)**. If H64 REFUTE, start R1 train/distill on same pod.
