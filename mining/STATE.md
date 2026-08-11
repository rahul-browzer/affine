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
| Lium | ~$123,210 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| live eval | **chal-00451** asdf (duel scoring ~53/80) · queue zeus→sth→cp200→whoami→**awesome-v8**→**tpc9** |
| disk | **~492 GiB free** on `/root` (72%) |
| **R2v** | pure sft3 **hr 0.39×** — SIGNAL_POS_BELOW_3SE |
| board 450 | sft3 hr **0.37×** — agrees with local R2v |
| R2d/e/f/h | 0.22× / REFUTE / SKIP / REFUTE −0.59× |
| **R2g/q/t** | Talent×saysth / pure saysth / saysth×Talent **REFUTE** |
| **R2s/u** | saysth×awesome/kevin **WEAK_SKIP** |
| **R2j/i/k** | BKN7 SKIP / thomp SKIP / BKN6 SKIP |
| **R2l** | Talent×sft3 **n80 ~21/80** · chall pid **205129** · sim pid **208704** |
| **R2l stage5** | armed `watch_r2l_stage5_push` pid **209817** (HF if hr≥1.5×) |
| R2m…p+R2r | Reason+ waiters armed (456/451/452/455 + whoami) |
| **R2w** | pure asdf **yielding** to R2l (no holding stamp) |
| **R2x** | Talent×awesome-v8 **armed** (prefetch DONE; wait chal-00462 Reason+) |
| tpc9 | prefetch **in flight** after v8 DONE |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · **R2l n80** · R2w yield · stage5 · **R2x wait** · tpc9 prefetch |

- R2l: `cat /root/affine_data/r2l_alpha_reason_progress.json` · decision → `r2l_alpha_decision.json`
- Stage5: `tail /root/logs/watch_r2l_stage5_push.log` · ready → `r2l_stage5_ready.json` · push → `r2l_stage5_hf_push.json`
- R2x: `tail /root/logs/r2x_premerge.log` · Reason+ → merge → `r2x_alpha_decision.json`
- Prefetch: tpc9 → `r2_prefetch_tpc9.done`
- Watch: `chal00462_reason.json` / `chal00463_reason.json`

## Blocked

- No submit until sim hr ≥ **1.5×**. R2v/board450 ~0.4× — need R2l (or later) crown.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- Do not wait R2w on pid alone — only `r2w_asdf_holding.stamp`.
- No re-n80 closed lanes; no saysth×Talent / near-identical α pairs.
- Do not merge awesome-v8/tpc9 until post-verdict Reason+.

## Next action

**Harvest R2l** n80 vs Tok; if hr≥1.5× → verify HF push (`r2l_stage5_hf_push.json`) then Stage-5 register+`--check`+submit; if 0<hr<1.5 keep blend as best-so-far and let R2w pure-asdf take chall; if hr≤0 purge blend and let R2w run. Confirm tpc9 prefetch DONE; arm Talent×tpc9 (R2y) only after Reason+ stamp (same pattern as R2x).
