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
| Lium | ~$123,557 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| board | live duel **chal-00432** (BKN seven); queue 441→431→450→451→452→455→456 |
| disk | ~295 GiB free on `/root` (84%) |
| R2d/e/f/h | 0.22× / REFUTE / SKIP / REFUTE −0.59× |
| **R2g** | Talent×saysth **REFUTE** hr **−0.89×** (n=79) |
| 440 saysth | hr **0.73×** (parent only; merge lost) |
| R2i | Talent×thomp wait 441 Reason+ · pids **138617/138637/139014** |
| R2j | Talent×BKN7 wait 432 Reason+ · pids **150140/150142** |
| R2k | Talent×BKN6 wait 431 Reason+ · pids **152117/152132** |
| R2l | Talent×sft3 wait 450 Reason+ · pids **152852/152866** |
| R2m | Talent×cp200 wait 456 Reason+ · pids **153337/153346** |
| R2n | Talent×asdf wait 451 Reason+ · pids **153903/153922/153931** |
| **R2o** | Talent×zeus **ARMED** · wait 452 Reason+ · pids **154867/154889/154904** |
| prefetch | BKN6+sft3+asdf+zeus+sth+cp200 DONE |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · R2i…R2o gated waiters |

- Engines 8000/8001/8002 healthy (chall still `/tmp/r2g_alpha_merged` idle).
- R2o logs: `/root/logs/r2o_premerge.log`, `r2o_merge_reload.log`.
- 452 watch: `tail /root/logs/watch_chal00452_reason.log` → `chal00452_reason.json`.

## Blocked

- No submit on R1*/R2d/e/g/h (below bar). No S\* 0.04 gate / king-watch.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- Lane-free = **pidfile kill -0** only. Recompute Reason from lpC fields.
- No merge thomp/BKN/sft3/cp200/asdf/zeus until Reason+. No re-n80 R2e/R2g/R2h.
- nvidia still weight-gated. Next uncached parent after a skip: chal-00455 sth (already cached).

## Next action

**Let R2i…R2o fire** on 441/432/431/450/456/451/452 Reason+ (GPU serial). Harvest first decision with hr ≥ **1.5×** → submit path. Else arm Talent×sth (455) if a refute frees merge disk (~70 GiB).
