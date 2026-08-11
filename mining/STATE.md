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
| Lium | ~$123,411 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| board | live duel **chal-00431** (BKN six, scoring) |
| queue | 450→451→452→455→456→**458 whoami** |
| disk | **~1296 GiB free** (57%) |
| R2d/e/f/h | 0.22× / REFUTE / SKIP / REFUTE −0.59× |
| **R2g** | Talent×saysth **REFUTE** hr **−0.89×** |
| 440 saysth | hr **0.73×** (parent only; merge lost) |
| **R2q** | pure saysth **REFUTE** hr **−0.35×** (margin −0.0066, z=−1.05, n=79) |
| **R2s** | saysth×awesome **WEAK_SKIP** Δ=**1.53e-05** |
| **R2t** | saysth×Talent **RELOADING** chall→n80 (Δ=**0.207**) |
| **R2j/i** | BKN7 SKIP / thomp SKIP_UNSERVABLE |
| R2k…p | Reason+ waiters armed; yield to R2t before chall kill |
| **R2r** | Talent×whoami **ARMED** · after R2t + 458 hr>0 |
| gated+ | diane-new 0.54× / nvidia 0.45× / aurora 0.17× — still weight-gated |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · **R2t reload→n80** + R2k…p + R2r |

- Teacher/king :8000/:8001 **200**; chall :8002 reloading `/tmp/r2t_alpha_merged` → saysth0.75×Talent0.25.
- R2t: `launch_r2t_merge_reload_sim.sh` pid 176482 · log `/root/logs/r2t_merge_reload.log` → `r2t_alpha_decision.json`.
- Check: `tail /root/logs/r2t_merge_reload.log`; decision: `/root/affine_data/r2t_alpha_decision.json`.
- R2q DONE (harvested p1939). R2s stubbed. 431/458 watches still 404 gzip.
- whoami DONE prefetch; watch `watch_chal00458_reason.log` → R2r.

## Blocked

- No submit until sim hr ≥ **1.5×**. No S\* 0.04 gate / king-watch.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- Lane-free = **pidfile kill -0** only. Recompute Reason from lpC fields.
- No merge thomp/BKN6/sft3/cp200/asdf/zeus/sth until Reason+. No re-n80 R2e/R2g/R2h/R2i/R2j/R2q/R2s.
- nvidia/diane-new/aurora weight-gated. R2r GPU only after **458 hr>0** and R2t terminal.

## Next action

**Harvest R2t** (`/root/affine_data/r2t_alpha_decision.json`): if hr≥**1.5×** → Stage-5 submit; else continue Reason+ queue waiters / R2r after 458. Harvest chal-00431 when gzip lands (R2k).
