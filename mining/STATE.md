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
| Lium | ~$122,640 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| **R2ag** | pure tpc9 n80 **gathering** ~21/21 of 80 · Stage-5 waiter armed |
| **R2y** | **SKIP_UNSERVABLE** (chal-00463 board reject; blend purged) |
| **R2z/aa–ad** | wait board Reason+ on 467–471 (history fast-path live) |
| live board | phase duel **chal-00467** awesome-v9 (`load_challenger`) |
| disk | `/root` **~444 GiB** free |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TKC@65536 · **R2ag** n80 pid **285579** |

- R2ag sim: `tail -f /root/logs/r2ag_tpc9_reason_sim.log` · progress `/root/affine_data/r2ag_tpc9_reason_progress.json` · decision `/root/affine_data/r2ag_tpc9_decision.json`
- Bridge: `tail -f /root/logs/bridge_r2ag_to_r2y.log` (board stamp already won; Stage-5 still via `watch_r2ag_stage5_push`)
- Queue watches: `watch_chal00467`…`471` (+ history / unservable)
- Eager blends R2z/aa–ad wait Reason+ only (no DONE until hr>0)

## Blocked

- No submit until sim hr ≥ **1.5×**.
- **sth** parent locked behind HF gated=manual.
- Board tpc9 **unservable** — do not re-arm Talent×tpc9.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f` / self-matching `pgrep -f`.

## Next action

**Harvest R2ag** `r2ag_tpc9_decision.json`. hr≥1.5× → Stage-5 HF (waiter armed). Else keep local lane closed for tpc9; first Reason+ among **467–471** owns next GPU (R2z/aa–ad).
