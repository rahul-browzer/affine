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
| Lium | ~$122,830 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| live eval | queue v8→tpc9→v9→sbs→sky→google→pig · phase duel chal-00458 scoring |
| disk | `/root` **~49 GiB** free (98%) · 7 eager blends @~66 GiB each |
| board 455 sth | hr **0.79×** — lost; local Talent×sth **REFUTE −0.93×** |
| **R2p** | **REFUTE** margin **−0.0282** · z=−2.78 · hr **−0.93×** · n=80 · Stage-5 SKIP |
| **R2x/R2y** | eager DONE Δ0.626/0.622 · wait 462/463 Reason+ |
| **R2z** | Talent×awesome-v9 eager DONE Δ=**0.671** · wait 467 Reason+ |
| **R2aa** | Talent×sbs eager DONE Δ=**0.671** · wait 468 Reason+ |
| **R2ab** | Talent×sky eager DONE Δ=**0.626** · wait 469 Reason+ |
| **R2ac** | Talent×google eager DONE Δ=**0.626** · wait 470 Reason+ |
| **R2ad** | Talent×pig eager **DONE** Δ=**0.626** · wait 471 Reason+ |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · chall **idle** · R2x–ad wait Reason+ · watches 462/463/467–471 |

- All R2x–ad: eager weights ready; waiters block on `*_premerge.done` (post-Reason+)
- R2ad stamp: `cat /root/logs/r2ad_eager_weights.done`
- Next GPU: first lane with `*_premerge.done` (Reason+) claims chall → n80

## Blocked

- No submit until sim hr ≥ **1.5×**. Board parents ≤0.79×; Talent×sth local **−0.93×**.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- Do not stamp `*_premerge.done` until post-verdict Reason+ (eager OK).
- Disk **49 GiB** — do not arm another full blend until a REFUTE purge or verdict clears a lane.

## Next action

**Harvest first Reason+ among 462/463/467–471** → that lane stamps `premerge.done` → chall reload → n80. If disk blocks reload, purge the oldest REFUTE/unused blend first.
