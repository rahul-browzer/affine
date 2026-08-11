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
| Lium | ~$123,501 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| board | live duel **chal-00441** (thompsville cgpb8, `load_challenger`) |
| queue | 431→450→451→452→455→456→**458 whoami** |
| disk | **~494 GiB free** (72%) |
| R2d/e/f/h | 0.22× / REFUTE / SKIP / REFUTE −0.59× |
| **R2g** | Talent×saysth **REFUTE** hr **−0.89×** (n=79) |
| 440 saysth | hr **0.73×** (parent only; merge lost) |
| **R2j** | BKN-seven **SKIP** hr **−0.57×** |
| R2i/k…p | Reason+ waiters armed; merge scripts wait R2q before chall kill |
| **R2q** | pure saysth **RUNNING** · chall reload pid **165170** · waiter **165096** |
| **R2r** | Talent×whoami **ARMED** · after R2q + 458 hr>0 |
| gated+ | diane-new 0.54× / nvidia 0.45× / aurora 0.17× — still weight-gated |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · **R2q n80** + R2i/k…p + R2r |

- Teacher/king :8000/:8001 healthy; chall :8002 loading `/tmp/r2q_saysth_v9a` (pure saysth-v9a).
- R2q log: `tail /root/logs/r2q_saysth_reload.log` → `r2q_saysth_decision.json`.
- R2i…R2p premerge still Reason-gated; merge_reload wait `wait_r2q_before_chall_kill.inc.sh`.
- 441 watch: `tail /root/logs/watch_chal00441_reason.log` → `chal00441_reason.json`.
- whoami DONE; watch `watch_chal00458_reason.log` → R2r.

## Blocked

- No submit until sim hr ≥ **1.5×**. No S\* 0.04 gate / king-watch.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- Lane-free = **pidfile kill -0** only. Recompute Reason from lpC fields.
- No merge thomp/BKN6/sft3/cp200/asdf/zeus/sth until Reason+. No re-n80 R2e/R2g/R2h/R2j.
- nvidia/diane-new/aurora weight-gated. R2r GPU only after **458 hr>0** and R2q terminal.

## Next action

**Harvest R2q** (`r2q_saysth_decision.json`): if hr≥**1.5×** → Stage-5 submit; else harvest chal-00441 when gzip lands (R2i if hr>0). Keep R2k…R2p/R2r Reason+ gates.
