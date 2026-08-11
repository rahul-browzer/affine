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
| Lium | ~$122,752 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| **R2r** | n80 **~29/80** · pid **266016** · TKC 200/200/200 |
| **R2ae** | **SKIP_GATED** — `fortunateGambler/…-sth` HF `gated=manual` |
| **R2af** | armed: pure awesome-v8 after R2r · pid **268343** · Stage-5 armed |
| **HF Stage-5** | pre-purged **+210.7 GiB** (3× h*-merged) p1983 |
| live board | phase duel **chal-00462** awesome-v8 (`load_challenger`) |
| disk | `/root` **~248 GiB** free · 8 eager Talent blends |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · R2r n80 · R2af wait · R2x–ad wait Reason+ |

- R2r: `tail -f /root/logs/r2r_merge_reload.log` · progress `/root/affine_data/r2r_alpha_reason_progress.json`
- R2af: `tail -f /root/logs/r2af_awesome_v8_reload.log` · decision `/root/affine_data/r2af_awesome_v8_decision.json`
- Stage-5 R2r/R2af: `tail -f /root/logs/watch_r2r_stage5_push.log` / `watch_r2af_stage5_push.log`
- Queue watchers: 462→463→467–471 (still 404 until duel gzip)

## Blocked

- No submit until sim hr ≥ **1.5×**.
- **sth** parent locked behind HF gated=manual — need owner approve or local residual (none).
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f` / self-matching `pgrep -f`.

## Next action

**Harvest `r2r_alpha_decision.json`.** If hr≥1.5× → confirm Stage-5 HF push (space pre-cleared) then register+`--check`+submit. Else let **R2af** claim chall→pure awesome-v8 n80; harvest `r2af_awesome_v8_decision.json` (hr≥1.5× → Stage-5). On R2af miss, first board Reason+ among 462/463/467–471 → R2x–ad.
