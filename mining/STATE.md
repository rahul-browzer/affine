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
| Lium | ~$122,797 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| live eval | **chal-00458** whoami dueling · queue 462→463→467→468→469→470→471 |
| disk | `/root` **~248 GiB** free (86%) after purge+R2r eager |
| **R2p** | **REFUTE** hr **−0.93×** · Stage-5 SKIP |
| **R2r** | Talent×whoami eager **DONE** Δ=**0.671** · wait 458 Reason+ |
| **R2x–ad** | eager DONE Δ0.622–0.671 · wait 462/463/467–471 Reason+ |
| **p1979 fix** | R2x–ad no longer always-busy on Reason-only R2r |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TK@65536 · chall **idle** · R2r/R2x–ad wait Reason+ |

- R2r eager: `cat /root/logs/r2r_eager_weights.done`
- First lane with `*_premerge.done` (post-Reason+) claims chall → n80
- GPU claim path unblocked (R2r busy only if `r2r_premerge.done`)

## Blocked

- No submit until sim hr ≥ **1.5×**. Board parents ≤0.79×; Talent×sth local **−0.93×**.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f`.
- Do not stamp `*_premerge.done` until post-verdict Reason+ (eager OK).

## Next action

**Harvest first Reason+ among 458/462/463/467–471** → that lane stamps `premerge.done` → chall reload → n80.
