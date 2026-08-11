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
| Lium | ~$122,696 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| **R2r** | **REFUTE** hr **−1.43×** (margin −0.0335, z=−4.29, n=80) · blend purged |
| **R2ae** | **SKIP_GATED** — `fortunateGambler/…-sth` HF `gated=manual` |
| **R2af** | chall loading `:8002` pid **273073** · pure awesome-v8@`6c04b16d` |
| **HF Stage-5** | pre-purged **+210.7 GiB** · R2r Stage-5 **SKIP_BELOW_BAR** |
| live board | phase duel **chal-00462** awesome-v8 (`scoring`) |
| disk | `/root` **~313 GiB** free · 7 eager Talent blends + v8 chall |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · R2af chall load · R2x–ad wait Reason+ |

- R2af: `tail -f /root/logs/r2af_awesome_v8_reload.log` · decision `/root/affine_data/r2af_awesome_v8_decision.json`
- Stage-5 R2af: `tail -f /root/logs/watch_r2af_stage5_push.log`
- Queue watchers: 462→463→467–471 (gzip still 404; 462 in scoring)

## Blocked

- No submit until sim hr ≥ **1.5×**.
- **sth** parent locked behind HF gated=manual — need owner approve or local residual (none).
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f` / self-matching `pgrep -f`.

## Next action

**Wait R2af engines 200/200/200 → n80 → harvest `r2af_awesome_v8_decision.json`.** If hr≥1.5× → Stage-5 HF push then register+`--check`+submit. On miss, first board Reason+ among 462/463/467–471 → R2x–ad (eager blends ready).
