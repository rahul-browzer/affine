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
| Lium | ~$123,568 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| board | **chal-00432** BKN seven @ `load_challenger` |
| disk | ~295 GiB free on `/root` (84%) |
| R2d/e/f/h | 0.22× / REFUTE / SKIP / REFUTE −0.59× |
| 440 saysth | hr **0.73×** · **R2g** n80 **~70/80** pid **130835** |
| R2i | Talent×thomp gated on 441 Reason+ (armed) |
| R2j | Talent×BKN7 wait 432 Reason+ · pids **150140/150142** |
| R2k | Talent×BKN6 wait 431 Reason+ · pids **152117/152132** |
| R2l | Talent×sft3 wait 450 Reason+ · pids **152852/152866** |
| **R2m** | Talent×cp200 **ARMED** · wait 456 Reason+ · pids **153337/153346** |
| prefetch | BKN6+sft3+asdf+zeus+sth+cp200 DONE |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · R2g · R2i/441 · R2j/432 · R2k/431 · R2l/450 · R2m/456 |

- Chall=`/tmp/r2g_alpha_merged`. Harvest → `r2g_alpha_decision.json`.
- R2m logs: `/root/logs/r2m_premerge.log`, `r2m_merge_reload.log`.
- 456 watch: `tail /root/logs/watch_chal00456_reason.log` → `chal00456_reason.json`.

## Blocked

- No submit on R1*/R2d/e/h (below bar). No S\* 0.04 gate / king-watch.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- Lane-free = **pidfile kill -0** only. Recompute Reason from lpC fields.
- No merge thomp/BKN/sft3/cp200 until Reason+. No re-n80 R2e/R2h. nvidia still weight-gated.

## Next action

**Harvest R2g** (`r2g_alpha_decision.json`); submit only if hr ≥ **1.5×**. Else let **R2i**/ **R2j**/ **R2k**/ **R2l**/ **R2m** fire on 441/432/431/450/456 Reason+. Next uncached queue parents: asdf/zeus/sth already DONE — arm Talent×asdf (451) after R2m waiters live if disk allows.
