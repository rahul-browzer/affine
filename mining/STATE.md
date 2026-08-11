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
| Lium | ~$123,065 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| live eval | chal-**00452** zeus **done** · hr **0.25×** (lost) · queue sth→cp200→whoami→v8→tpc9 |
| disk | `/root` **775 GiB** free · R2n+R2o blends ~66 GiB each |
| **R2l** | Talent×sft3 **REFUTE** hr **−0.89×** |
| board 450/451/452 | sft3 **0.37×** / asdf **0.40×** / zeus **0.25×** — all <1.5× |
| **R2v/w** | sft3 0.39× / asdf SKIP_BOARD_FIRST 0.40× |
| **R2n** | Talent×asdf **n80 ~54/80** · chall pid **220421** · sim **224186** · Stage-5 armed |
| **R2o** | Talent×zeus **premerge DONE** Δ=**0.626** · Reason+ gate ok (hr0.25×) · merge_reload waiting R2n |
| R2m/p/r | Reason+ waiters (456/455/458); yield to R2n then R2o |
| **R2x/R2y** | Talent×v8 / Talent×tpc9 armed (wait 462/463 Reason+) |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · **R2n n80** · R2o ready · Stage-5 armed |

- R2n: `cat /root/affine_data/r2n_alpha_reason_progress.json` · decision → `r2n_alpha_decision.json`
- Stage-5: `tail /root/logs/watch_r2n_stage5_push.log`
- R2o: premerge done → `launch_r2o_merge_reload_sim.sh` waits R2n terminal then chall reload

## Blocked

- No submit until sim hr ≥ **1.5×**. Board parents ≤0.40× — need blend crown (R2n/R2o…).
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- No re-n80 closed lanes; no saysth×Talent / near-identical α pairs.
- Do not merge awesome-v8/tpc9 until post-verdict Reason+.
- R2n must **not** wait on R2m Reason-only PID (gate on `r2m_premerge.done` only).
- diane613/new weights stay **gated** for unconst — use whoami (R2r) not diane.

## Next action

**Harvest R2n** n80 vs Tok; if hr≥1.5× → confirm Stage-5 HF push then register+`--check`+submit; if 0<hr<1.5 keep blend best-so-far and let **R2o** take chall (premerge already DONE); if hr≤0 purge R2n blend and advance R2o. R2x/R2y stay gated on 462/463 Reason+.
