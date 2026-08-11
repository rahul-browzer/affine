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
| Lium | ~$123,110 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| live eval | chal-**00452** zeus @ duel · queue sth→cp200→whoami→v8→tpc9 |
| disk | ~1.3 TiB free · purged REFUTED R2l blend |
| **R2l** | Talent×sft3 **REFUTE** hr **−0.89×** (margin −0.0307, z=−2.67, n=79) |
| board 450/451 | sft3 **0.37×** / asdf **0.40×** — both below 1.5× |
| **R2v/w** | sft3 0.39× / asdf SKIP_BOARD_FIRST 0.40× |
| R2d/e/f/h | 0.22× / REFUTE / SKIP / REFUTE −0.59× |
| **R2g/q/t** | Talent×saysth / pure saysth / saysth×Talent **REFUTE** |
| **R2s/u** | saysth×awesome/kevin **WEAK_SKIP** |
| **R2j/i/k** | BKN7 SKIP / thomp SKIP / BKN6 SKIP |
| **R2n** | Talent×asdf **n80 ~2/80** · chall pid **220421** · sim **224186** |
| R2m…p+R2r | Reason+ waiters (456/452/455/458); R2m yields to R2n |
| **R2x** | Talent×awesome-v8 **armed** (wait chal-00462 Reason+) |
| **R2y** | Talent×tpc9 **armed** (wait chal-00463 Reason+) |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · **R2n n80** · R2m/R2x/R2y wait |

- R2n: `cat /root/affine_data/r2n_alpha_reason_progress.json` · decision → `r2n_alpha_decision.json`
- R2m: waits chal-00456 Reason; yields while R2n owns chall (`r2n_premerge.done`)
- R2x/R2y: wait `chal00462_reason.json` / `chal00463_reason.json`

## Blocked

- No submit until sim hr ≥ **1.5×**. R2l/−board ~0.4× — need R2n (or later) crown.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- Do not wait R2w on pid alone — board skip stamps `r2w_asdf_reload.done`.
- No re-n80 closed lanes; no saysth×Talent / near-identical α pairs.
- Do not merge awesome-v8/tpc9 until post-verdict Reason+.
- R2n must **not** wait on R2m Reason-only PID (gate on `r2m_premerge.done` only).

## Next action

**Harvest R2n** n80 vs Tok; if hr≥1.5× → Stage-5 HF push then register+`--check`+submit; if 0<hr<1.5 keep blend as best-so-far and let next Reason+ lane (R2m/o/p/x/y) take chall; if hr≤0 purge R2n blend and advance. R2x/R2y stay gated on 462/463 Reason+.
