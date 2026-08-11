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
| Lium | ~$122,774 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| **chal-00458** | whoami Reason+ hr **0.39×** (margin +0.00536, z=1.16, n=80) · lost crown |
| **R2r** | premerge **DONE** · chall **loading** pid **262297** → n80 |
| disk | `/root` **~248 GiB** free · 8 eager blends kept |
| Stage-5 | `watch_r2r_stage5_push` armed (hr≥1.5× → HF public) |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · R2r chall→n80 · R2x–ad wait Reason+ |

- R2r: `tail -f /root/logs/r2r_merge_reload.log` · decision `/root/affine_data/r2r_alpha_decision.json`
- Stage-5: `tail -f /root/logs/watch_r2r_stage5_push.log`
- Queue next: 462 awesome-v8 → 463 tpc9 → 467–471

## Blocked

- No submit until sim hr ≥ **1.5×**. Board whoami only **0.39×**; Talent×* locals mostly refute.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- Do not stamp sibling `*_premerge.done` until their board Reason+.

## Next action

**Harvest `r2r_alpha_decision.json`.** If hr≥1.5× → confirm Stage-5 HF push then register+`--check`+submit. Else purge whoami blend + advance first Reason+ among 462/463/467–471.
