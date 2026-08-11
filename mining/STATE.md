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
| Lium | ~$123,031 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| live eval | chal-**00455** sth **load_challenger** · queue cp200→whoami→v8→tpc9 |
| disk | `/root` **~708 GiB** free · purged REFUTED R2n blend (~66 GiB) |
| **R2n** | Talent×asdf **REFUTE** hr **−1.07×** (margin −0.023, z=−3.21, n=80) |
| board 450/451/452 | sft3 **0.37×** / asdf **0.40×** / zeus **0.25×** — all <1.5× |
| **R2o** | Talent×zeus **n80 started** (~1/80) · holding stamp · Stage-5 not armed |
| **R2x** | Talent×v8 **eager weights DONE** Δ=**0.626** · DONE gated on 462 Reason+ |
| R2m/p/r | Reason+ waiters (456/455/458); yield to R2o holding |
| **R2y** | Talent×tpc9 still Reason-gated (463) — no eager yet |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · **R2o n80** · R2x eager waiting 462 |

- R2o: `cat /root/affine_data/r2o_alpha_reason_progress.json` · decision → `r2o_alpha_decision.json`
- R2x: eager `/root/logs/r2x_eager_weights.done` · no `r2x_premerge.done` until Reason+
- Check: `tail /root/logs/r2o_merge_reload.log` · chall `/tmp/r2o_alpha_merged`

## Blocked

- No submit until sim hr ≥ **1.5×**. Board parents ≤0.40× — need blend crown (R2o…).
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- No re-n80 closed lanes; no saysth×Talent / near-identical α pairs.
- Do not merge awesome-v8/tpc9 until post-verdict Reason+.
- R2o must **not** wait on R2m Reason-only PIDs (gate on `r2m_premerge.done` only).
- diane613/new weights stay **gated** for unconst — use whoami (R2r) not diane.

## Next action

**Harvest R2o** n80 vs Tok; if hr≥1.5× → arm Stage-5 HF push then register+`--check`+submit; if 0<hr<1.5 keep blend and queue next Reason+ parent (R2p sth / R2m cp200 / R2x if 462+); if hr≤0 purge R2o blend and advance next ready lane. Optionally eager-CPU R2y (Talent×tpc9) while R2o gathers.
