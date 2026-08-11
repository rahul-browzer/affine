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
| Lium | ~$123,590 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| board | **chal-00432** BKN seven @ `load_challenger` |
| disk | ~302 GiB free on `/root` (83%) |
| R2d/e/f/h | 0.22× / REFUTE / SKIP / REFUTE −0.59× |
| 440 saysth | hr **0.73×** · **R2g** n80 **~52/80** pid **146391** |
| R2i | Talent×thomp gated on 441 Reason+ (armed) |
| **R2j** | Talent×BKN7 wait 432 Reason+ · pids **150140/150142** |
| **R2k** | Talent×BKN6 **ARMED** · wait 431 Reason+ · pids **152117/152132** |
| prefetch | BKN6+sft3+asdf+zeus+sth DONE · **cp200** ~11/12 pid **150906** |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · R2g · R2i/441 · R2j/432 · R2k/431 · cp200 |

- Chall=`/tmp/r2g_alpha_merged`. Harvest → `r2g_alpha_decision.json`.
- R2k logs: `/root/logs/r2k_premerge.log`, `r2k_merge_reload.log`.
- 431 watch: `tail /root/logs/watch_chal00431_reason.log` → `chal00431_reason.json`.
- cp200: `tail /root/logs/r2_prefetch_cp200.log` → `r2_prefetch_cp200.done`.

## Blocked

- No submit on R1*/R2d/e/h (below bar). No S\* 0.04 gate / king-watch.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- Lane-free = **pidfile kill -0** only. Recompute Reason from lpC fields.
- No merge thomp/BKN until Reason+. No re-n80 R2e/R2h. nvidia still weight-gated.

## Next action

**Harvest R2g** (`r2g_alpha_decision.json`); submit only if hr ≥ **1.5×**. Else let **R2i**/ **R2j**/ **R2k** fire on 441/432/431 Reason+; confirm cp200 DONE.
