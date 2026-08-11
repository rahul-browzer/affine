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
| Lium | ~$122,908 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| live eval | chal-**00456** cp200 · queue whoami→v8→tpc9→v9→sbs→**sky**→google→pig |
| disk | `/root` **~496 GiB** free · sbs cache ~37 GiB mid-download |
| board 455 sth | hr **0.79×** (margin 0.0091 / 3·SE 0.0116) — lost |
| **R2p** | Talent×sth n80 **~30/80** · Δ=**0.671** · chall `/tmp/r2p_alpha_merged` |
| **R2x/R2y** | eager DONE Δ0.626/0.622 · wait 462/463 Reason+ |
| **R2z** | Talent×awesome-v9 eager **DONE** Δ=**0.671** · wait 467 Reason+ |
| **v9 prefetch** | chal-00467 @`75871c57…` **DONE** |
| **sbs prefetch** | chal-00468 @`c175fe8b…` **RUNNING** (~37 GiB / ~70) |
| **sky chain** | **ARMED** wait sbs.done → chal-00469 @`a569e29b…` (2×st) |
| next parents | 470 google / 471 pig — after sky DONE |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · **R2p n80** · sbs prefetch · sky-after-sbs · R2z wait-Reason · R2x/y wait |

- R2p: `tail /root/logs/r2p_alpha_reason_sim.log` · progress `/root/affine_data/r2p_alpha_reason_progress.json` · decision → `r2p_alpha_decision.json`
- sbs: `tail /root/logs/r2_prefetch_sbs.log` · DONE `/root/logs/r2_prefetch_sbs.done`
- sky: `tail /root/logs/r2_prefetch_sky_after_sbs.log` · DONE `/root/logs/r2_prefetch_sky.done`
- R2z: `cat /root/logs/r2z_eager_weights.done` · wait `chal00467_reason.json` before `r2z_premerge.done`
- Check: `curl -s localhost:8002/v1/models` then decision JSON

## Blocked

- No submit until sim hr ≥ **1.5×**. Board parents ≤0.79× — need blend crown (R2p…).
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- No re-n80 closed lanes; no saysth×Talent / near-identical α pairs.
- Do not merge awesome-v8/v9/tpc9/sbs/sky until post-verdict Reason+ (eager OK; DONE gated).
- R2p/R2x/R2y/R2z must **not** wait on R2m Reason-only PIDs (gate on `r2m_premerge.done` only).
- diane613/new weights stay **gated** for unconst — use whoami (R2r) not diane.
- Prefetch next queue parent **one-at-a-time** after sky (google first) — disk ~496 GiB.

## Next action

**Harvest R2p** when n80 finishes (`r2p_alpha_decision.json`); if hr≥1.5× → Stage-5 HF push+register+`--check`+submit; if 0<hr<1.5 keep blend and advance next Reason+ lane; if hr≤0 purge R2p and let R2x/R2y/R2z claim GPU after their Reason+ stamps. After sky DONE: prefetch **chal-00470 google** (2×st) one-at-a-time.
