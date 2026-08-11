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
| Lium | ~$123,333 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| board | live duel **chal-00450** (sft3, load_challenger) |
| queue | 451→452→455→456→**458 whoami** |
| disk | **~1.3 TiB free** (57%); R2t blend purged |
| R2d/e/f/h | 0.22× / REFUTE / SKIP / REFUTE −0.59× |
| **R2g** | Talent×saysth **REFUTE** hr **−0.89×** |
| 440 saysth | hr **0.73×** (parent only; merge lost) |
| **R2q** | pure saysth **REFUTE** hr **−0.35×** |
| **R2s/u** | saysth×awesome/kevin **WEAK_SKIP** |
| **R2t** | saysth×Talent **REFUTE** hr **−0.93×** |
| **R2j/i/k** | BKN7 SKIP / thomp SKIP / **BKN6 SKIP** |
| R2l…p | Reason+ waiters armed (450/456/451/452/455) |
| **R2r** | Talent×whoami **ARMED** · after 458 hr>0 |
| gated+ | diane-new 0.54× / nvidia 0.45× / aurora 0.17× |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · R2l…p + R2r waiters |

- Teacher/king/chall :8000/:8001/:8002 all **200** (chall still R2t weights in GPU RAM).
- R2t terminal: `r2t_alpha_decision.json` · hr **−0.93×** · blend purged.
- R2l…p / R2r merge pids alive; blocked on board Reason stamps (450/458 gzip 404).
- Check: `tail /root/logs/r2l_premerge.log` / `watch_chal00450_reason.log`.

## Blocked

- No submit until sim hr ≥ **1.5×**. No S\* 0.04 gate / king-watch.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- Lane-free = **pidfile kill -0** only. Recompute Reason from lpC fields.
- No merge thomp/BKN6/BKN7/sft3/cp200/asdf/zeus/sth until Reason+. No re-n80 closed lanes.
- nvidia/diane-new/aurora weight-gated. R2r GPU only after **458 hr>0**.
- saysth×kevin/awesome/Tok near-identical — do not re-α those pairs.
- saysth×Talent (both α directions) **REFUTED** — do not re-blend.

## Next action

**Wait chal-00450 Reason stamp** → if hr>0 let R2l Talent×sft3 fire; else harvest SKIP and advance queue (451/…). R2r after 458 hr>0.
