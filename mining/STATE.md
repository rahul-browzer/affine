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
| Lium | ~$122,685 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| **R2r** | **REFUTE** hr **−1.43×** (p1985) |
| **R2ae** | **SKIP_GATED** — sth HF `gated=manual` |
| **R2af** | **SKIP_BOARD_FIRST** chal-00462 hr **−0.04×** (margin −0.0005, z=−0.11) |
| **R2x** | **SKIP** Talent×awesome-v8 (same board; blend purged) |
| live board | phase duel **chal-00463** tpc9 (`load_challenger`) |
| disk | `/root` **~379 GiB** free · eager R2y/z/aa–ad blends |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · GPU4–7 free · R2y wait 463 Reason+ |

- R2y: `tail -f /root/logs/r2y_merge_reload.log` · gate `/root/affine_data/chal00463_reason.json`
- 463 watch: `tail -f /root/logs/watch_chal00463_reason.log`
- Queue: 463→467–471 (R2z/aa–ad eager; gzip often 404 until history)

## Blocked

- No submit until sim hr ≥ **1.5×**.
- **sth** parent locked behind HF gated=manual.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f` / self-matching `pgrep -f`.

## Next action

**Wait chal-00463 tpc9 board Reason stamp.** If hr>0 → R2y stamps premerge.done → chall reload+n80. If hr≤0 → R2y SKIP+purge; first Reason+ among 467–471 owns next lane (eager blends ready).
