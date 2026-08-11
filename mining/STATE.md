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
| Lium | ~$122,942 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| live eval | chal-**00456** cp200 · queue whoami→v8→tpc9→**v9**→sbs→sky→google |
| disk | `/root` **~642 GiB** free · R2p blend ~66 GiB |
| board 455 sth | hr **0.79×** (margin 0.0091 / 3·SE 0.0116) — lost |
| **R2p** | Talent×sth n80 **~2/80** · Δ=**0.671** · chall `/tmp/r2p_alpha_merged` |
| **R2x/R2y** | eager DONE Δ0.626/0.622 · wait 462/463 Reason+ |
| **v9 prefetch** | chal-00467 awesome-v9 @`75871c57…` **downloading** (~70 GiB) |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · **R2p n80** · v9 prefetch · R2x/y eager |

- R2p: `tail /root/logs/r2p_alpha_reason_sim.log` · progress `/root/affine_data/r2p_alpha_reason_progress.json` · decision → `r2p_alpha_decision.json`
- v9: `tail /root/logs/r2_prefetch_awesome_v9.log` · DONE `/root/logs/r2_prefetch_awesome_v9.done`
- Check: `curl -s localhost:8002/v1/models` then decision JSON

## Blocked

- No submit until sim hr ≥ **1.5×**. Board parents ≤0.79× — need blend crown (R2p…).
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- No re-n80 closed lanes; no saysth×Talent / near-identical α pairs.
- Do not merge awesome-v8/v9/tpc9 until post-verdict Reason+ (eager OK; DONE gated).
- R2p/R2x/R2y must **not** wait on R2m Reason-only PIDs (gate on `r2m_premerge.done` only).
- diane613/new weights stay **gated** for unconst — use whoami (R2r) not diane.

## Next action

**Harvest R2p** when n80 finishes (`r2p_alpha_decision.json`); if hr≥1.5× → Stage-5 HF push+register+`--check`+submit; if 0<hr<1.5 keep blend and advance next Reason+ lane; if hr≤0 purge R2p and queue R2x/R2y/v9 after their Reason+ stamps. Confirm v9 prefetch DONE before arming any Talent×v9 premerge.
