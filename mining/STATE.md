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
| Lium | ~$122,897 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| live eval | chal-**00456** cp200 · queue whoami→v8→tpc9→v9→sbs→sky→google→**pig** |
| disk | `/root` **~352 GiB** free · google ~46 GiB mid-download |
| board 455 sth | hr **0.79×** (margin 0.0091 / 3·SE 0.0116) — lost |
| **R2p** | Talent×sth n80 **~47/80** · Δ=**0.671** · chall `/tmp/r2p_alpha_merged` |
| **R2x/R2y** | eager DONE Δ0.626/0.622 · wait 462/463 Reason+ |
| **R2z** | Talent×awesome-v9 eager **DONE** Δ=**0.671** · wait 467 Reason+ |
| **v9/sbs/sky** | chal-00467/468/469 prefetch **DONE** · Reason watch **ARMED** |
| **google** | chal-00470 prefetch **RUNNING** (~46 GiB) · Reason watch **ARMED** |
| **pig chain** | **ARMED** wait google.done → chal-00471 · Reason watch **ARMED** |
| **R2p Stage-5** | `watch_r2p_stage5_push` **ARMED** (hr≥1.5× → public HF; no submit) |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · **R2p n80** · google prefetch · pig-after-google · Reason watches 462/463/467–471 · R2p Stage-5 |

- R2p: `tail /root/logs/r2p_alpha_reason_sim.log` · progress `/root/affine_data/r2p_alpha_reason_progress.json` · decision → `r2p_alpha_decision.json`
- google: `tail /root/logs/r2_prefetch_google.log` · DONE `/root/logs/r2_prefetch_google.done`
- pig: `tail /root/logs/r2_prefetch_pig_after_google.log` · DONE `/root/logs/r2_prefetch_pig.done`
- Reason+: `chal0046{2,3,7,8,9}_reason.json` / `chal00470_reason.json` / `chal00471_reason.json`
- Stage-5: `tail /root/logs/watch_r2p_stage5_push.log` · meta `/root/affine_data/r2p_stage5_hf_push.json`
- Check: `curl -s localhost:8002/v1/models` then decision JSON

## Blocked

- No submit until sim hr ≥ **1.5×**. Board parents ≤0.79× — need blend crown (R2p…).
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- No re-n80 closed lanes; no saysth×Talent / near-identical α pairs.
- Do not merge awesome-v8/v9/tpc9/sbs/sky/google/pig until post-verdict Reason+ (eager OK; DONE gated).
- R2p/R2x/R2y/R2z must **not** wait on R2m Reason-only PIDs (gate on `r2m_premerge.done` only).
- diane613/new weights stay **gated** for unconst — use whoami (R2r) not diane.
- Queue prefetch chain complete through pig; next parent only if queue grows.

## Next action

**Harvest R2p** when `r2p_alpha_decision.json` lands; if hr≥1.5× confirm Stage-5 HF push meta then register+`--check`+submit; if 0<hr<1.5 keep blend and advance next Reason+ lane; if hr≤0 purge R2p and let R2x/R2y/R2z claim GPU after Reason+ stamps. Confirm google→pig DONE; harvest new Reason+ stamps (468–471) as gzips land.
