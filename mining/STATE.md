# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4** — Reason v3 crown push (operator 2026-08-10).
King-watch **revoked**. `weight_version_key=3`. Score = mean Reason (Λ2 only).

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · `weight_version_key=3` · crown = margin > 3·SE |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` (reign 4) |
| corpus | epoch **7** · schema v2 |
| Lium | ~$122,651 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| **R2af** | **SKIP_BOARD_FIRST** chal-00462 hr **−0.04×** |
| **R2ag** | **n80 gathering** pure tpc9 (p1988) · ~9/5 of 80 · bridge→R2y |
| **R2y** | wait board/proxy 463 Reason+ (eager blend ready) |
| live board | phase duel **chal-00463** tpc9 (`load_challenger` at arm) |
| disk | `/root` **~378 GiB** free · eager R2z/aa–ad blends |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TKC@65536 · **R2ag** n80 pid **285579** |

- R2ag sim: `tail -f /root/logs/r2ag_tpc9_reason_sim.log` · progress `/root/affine_data/r2ag_tpc9_reason_progress.json` · decision `/root/affine_data/r2ag_tpc9_decision.json`
- Bridge: `tail -f /root/logs/bridge_r2ag_to_r2y.log`
- 463 watch: `tail -f /root/logs/watch_chal00463_reason.log`
- R2y: `tail -f /root/logs/r2y_merge_reload.log` · gate `/root/affine_data/chal00463_reason.json`
- Queue: 467–471 (R2z/aa–ad eager; gzip often 404 until history)

## Blocked

- No submit until sim hr ≥ **1.5×**.
- **sth** parent locked behind HF gated=manual.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f` / self-matching `pgrep -f`.

## Next action

**Harvest R2ag** `r2ag_tpc9_decision.json`. hr≥1.5× → Stage-5 HF (watcher armed). 0<hr<1.5 → bridge proxies 463 → R2y chall. hr≤0 → keep board wait; first Reason+ among 463/467–471 owns next lane.
