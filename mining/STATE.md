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
| Lium | ~$122,573 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| **R2ag** | pure tpc9 **REFUTE** hr **−0.52×** (margin −0.0105, z=−1.56, n=79) |
| **R2ah/R2z** | **SKIP_BOARD_FIRST** chal-00467 awesome-v9 hr **0.21×** |
| **R2ai** | **armed** pure sbs-v0 (chal-00468) — chall loading :8002 · pid **296915** |
| **R2aa–ad** | wait Reason+ 468–471 · blocked behind R2ai PID · host hist bridge |
| live board | phase duel **chal-00468** sbs-v0 |
| disk | `/root` **~444 GiB** free |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TKC@65536 · **R2ai** reload pid **296915** · Stage-5 **watch_r2ai** |

- R2ai: `tail -f /root/logs/r2ai_sbs_reload.log` · progress `/root/affine_data/r2ai_sbs_reason_progress.json`
- Stage-5: `tail -f /root/logs/watch_r2ai_stage5_push.log`
- Host bridge: `tail -f experiments/r2-multiking-merge/logs/host_history_stamp_bridge.log` (pid **1202431**)
- Eager Talent blends R2aa–ad wait Reason+ only (no DONE until hr>0); R2ai PID blocks steal

## Blocked

- No submit until sim hr ≥ **1.5×**.
- **sth** parent locked behind HF gated=manual.
- Board tpc9 **unservable** — local R2ag also REFUTE; do not re-arm Talent×tpc9.
- Pod `affine.io` history/snapshot often **CF 403** — use host bridge / hippius gzip.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f` / self-matching `pgrep -f`.

## Next action

**Watch R2ai** engines→n80. Harvest `r2ai_sbs_decision.json`. hr≥1.5× → Stage-5 HF. Else board-skip or first Reason+ among **469–471** (prefer pure parent over Talent skew).
