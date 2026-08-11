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
| Lium | ~$122,987 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| live eval | chal-**00456** cp200 **load_challenger** · queue whoami→v8→tpc9 |
| disk | `/root` **~577 GiB** free · R2p blend ~70 GiB |
| **R2n** | Talent×asdf **REFUTE** hr **−1.07×** (purged) |
| board 450/451/452/455 | sft3 **0.37×** / asdf **0.40×** / zeus **0.25×** / **sth 0.79×** |
| **R2o** | Talent×zeus **n80 ~53/80** · holding stamp · Stage-5 not armed |
| **R2p** | Talent×sth **premerge DONE** Δ=**0.671** · merge_reload waits R2o (r2m_busy=0) |
| **R2x** | Talent×v8 **eager weights DONE** Δ=**0.626** · DONE gated on 462 Reason+ |
| R2m/r | Reason+ waiters (456/458); yield to R2o/R2p GPU claimants |
| **R2y** | Talent×tpc9 **eager weights DONE** Δ=**0.622** · DONE gated on 463 Reason+ |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · **R2o n80** · **R2p** ready · R2x/R2y eager |

- R2o: `cat /root/affine_data/r2o_alpha_reason_progress.json` · decision → `r2o_alpha_decision.json`
- R2p: `r2p_premerge.done` · `tail /root/logs/r2p_merge_reload.log` (waits R2o; r2m_busy=0)
- R2x/R2y: eager stamps present; no `*_premerge.done` until Reason+
- Check: `tail /root/logs/r2o_merge_reload.log` · chall `/tmp/r2o_alpha_merged`

## Blocked

- No submit until sim hr ≥ **1.5×**. Board parents ≤0.79× — need blend crown (R2o/R2p…).
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- No re-n80 closed lanes; no saysth×Talent / near-identical α pairs.
- Do not merge awesome-v8/tpc9 until post-verdict Reason+ (eager OK; DONE gated).
- R2o/R2p must **not** wait on R2m Reason-only PIDs (gate on `r2m_premerge.done` only).
- diane613/new weights stay **gated** for unconst — use whoami (R2r) not diane.

## Next action

**Harvest R2o** n80 vs Tok; if hr≥1.5× → arm Stage-5 HF push then register+`--check`+submit; if 0<hr<1.5 keep blend and let **R2p** Talent×sth claim chall→n80; if hr≤0 purge R2o blend and let R2p advance.
