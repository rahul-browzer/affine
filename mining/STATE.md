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
| board | live duel **chal-00450** (sft3, load_challenger, gzip 404) |
| queue | 451→452→455→456→**458 whoami** |
| disk | **~625 GiB free** (65%) |
| R2d/e/f/h | 0.22× / REFUTE / SKIP / REFUTE −0.59× |
| **R2g/q/t** | Talent×saysth / pure saysth / saysth×Talent **REFUTE** |
| **R2s/u** | saysth×awesome/kevin **WEAK_SKIP** |
| **R2j/i/k** | BKN7 SKIP / thomp SKIP / **BKN6 SKIP** |
| R2l…p | Reason+ waiters armed (450/456/451/452/455) |
| **R2r** | Talent×whoami **ARMED** · after 458 hr>0 |
| **R2v** | pure sft3 **RUNNING** (chall reload → n80) |
| gated+ | diane-new 0.54× / nvidia 0.45× / aurora 0.17× |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · **R2v pure-sft3** · R2l…p+R2r wait |

- Teacher/king **200**; chall reloading sft3 on :8002 (pid **189540**).
- R2v pid **189465** · check `tail /root/logs/r2v_sft3_reload.log`.
- R2l…p / R2r waiters alive; yield on R2v via wait-include / R2r wait-lane.

## Blocked

- No submit until sim hr ≥ **1.5×**. No S\* 0.04 gate / king-watch.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- Lane-free = **pidfile kill -0** only. Recompute Reason from lpC fields.
- No merge thomp/BKN6/BKN7/sft3/cp200/asdf/zeus/sth until Reason+. No re-n80 closed lanes.
- nvidia/diane-new/aurora weight-gated. R2r GPU only after **458 hr>0** (+ R2v terminal).
- saysth×kevin/awesome/Tok near-identical — do not re-α those pairs.
- saysth×Talent (both α directions) **REFUTED** — do not re-blend.

## Next action

**Harvest R2v** (`r2v_sft3_decision.json`): if hr≥1.5× → Stage-5 submit path; else keep R2l on 450 Reason+ / R2r on 458.
