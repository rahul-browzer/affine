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
| Lium | ~$122,853 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| live eval | queue …→sbs→sky→google→pig (456 cp200 **hr −1.06×**) |
| disk | `/root` **~172 GiB** free · R2ac google blend writing |
| board 455 sth | hr **0.79×** — lost; local Talent×sth **REFUTE −0.93×** |
| **R2p** | **REFUTE** margin **−0.0282** · z=−2.78 · hr **−0.93×** · n=80 · Stage-5 SKIP · blend purged |
| **R2x/R2y** | eager DONE Δ0.626/0.622 · wait 462/463 Reason+ |
| **R2z** | Talent×awesome-v9 eager DONE Δ=**0.671** · wait 467 Reason+ |
| **R2aa** | Talent×sbs eager **DONE** Δ=**0.671** · wait 468 Reason+ |
| **R2ab** | Talent×sky eager **DONE** Δ=**0.626** · wait 469 Reason+ |
| **R2ac** | Talent×google eager **RUNNING** (~2/16) · wait 470 Reason+ |
| **v9/sbs/sky/google/pig** | prefetch **DONE** · Reason watches **ARMED** |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · chall **idle** · R2aa/ab wait · R2ac eager · watches 462/463/467–471 |

- R2ac: `tail /root/logs/r2ac_premerge.log` · eager → `/root/logs/r2ac_eager_weights.done`
- R2ac reload: `tail /root/logs/r2ac_merge_reload.log` (waits premerge.done + R2aa/ab)
- Next GPU: first lane with `*_premerge.done` (Reason+) claims chall

## Blocked

- No submit until sim hr ≥ **1.5×**. Board parents ≤0.79×; Talent×sth local **−0.93×**.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- Do not stamp `*_premerge.done` until post-verdict Reason+ (eager OK).
- R2m busy only on `r2m_premerge.done`. Next: Talent×pig after R2ac eager + disk ≥75 GiB.

## Next action

**Confirm R2ac eager stamp**; keep R2aa/ab/ac waiters on 468/469/470 Reason+. On first Reason+ → `premerge.done` → chall reload → n80. Arm Talent×pig (R2ad) after R2ac eager + disk ≥75 GiB. Harvest Reason+ 462/463/467–471 when gzips land.
