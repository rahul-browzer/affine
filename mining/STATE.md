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
| Lium | ~$122,874 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| live eval | queue …→sbs→sky→google→pig (456 cp200 **hr −1.06×** harvested) |
| disk | `/root` **~209 GiB** free · R2aa mid-blend · pig **DONE** |
| board 455 sth | hr **0.79×** (margin 0.0091 / 3·SE 0.0116) — lost |
| **R2p** | Talent×sth n80 **~66/80** · Δ=**0.671** · chall `/tmp/r2p_alpha_merged` |
| **R2x/R2y** | eager DONE Δ0.626/0.622 · wait 462/463 Reason+ |
| **R2z** | Talent×awesome-v9 eager **DONE** Δ=**0.671** · wait 467 Reason+ |
| **R2aa** | Talent×sbs **EAGER RUNNING** (~7/16) · wait 468 Reason+ · merge_reload **ARMED** |
| **R2ab** | Talent×sky **ARMED** · waits R2aa eager + 469 Reason+ · merge_reload **ARMED** |
| **v9/sbs/sky/google/pig** | prefetch **DONE** · Reason watches **ARMED** |
| **R2p Stage-5** | `watch_r2p_stage5_push` **ARMED** (hr≥1.5× → public HF; no submit) |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · **R2p n80** · R2aa eager · **R2ab wait-R2aa** · watches 462/463/467–471 · R2p Stage-5 |

- R2p: `tail /root/logs/r2p_alpha_reason_sim.log` · progress `/root/affine_data/r2p_alpha_reason_progress.json`
- R2aa: `tail /root/logs/r2aa_premerge.log` · eager `/root/logs/r2aa_eager_weights.done`
- R2ab: `tail /root/logs/r2ab_premerge.log` · eager `/root/logs/r2ab_eager_weights.done`
- Stage-5: `tail /root/logs/watch_r2p_stage5_push.log`

## Blocked

- No submit until sim hr ≥ **1.5×**. Board parents ≤0.79× — need blend crown (R2p…).
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- Do not merge awesome-v8/v9/tpc9/sbs/sky/google/pig until post-verdict Reason+ (eager OK; DONE gated).
- R2m busy only on `r2m_premerge.done`. Next: Talent×google/pig after R2ab eager + disk ≥75 GiB.

## Next action

**Harvest R2p** when `r2p_alpha_decision.json` lands; if hr≥1.5× confirm Stage-5 HF push then register+`--check`+submit; if 0<hr<1.5 keep blend; if hr≤0 purge R2p. Confirm R2aa eager stamp then R2ab eager; harvest Reason+ 462/463/467–471; arm Talent×google (R2ac) after R2ab eager + disk ≥75 GiB.
