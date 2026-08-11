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
| Lium | ~$122,618 · burn **$64/h** (≤$833/h) · floor ≥$10k |
| fleet | `mine-crown-1` lunar-orbit-50 8×B300 · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| **R2ag** | pure tpc9 n80 **gathering** ~49/49 of 80 · Stage-5 waiter armed |
| **R2ah** | **armed** pure awesome-v9 (chal-00467) — waits R2ag terminal · pid **290751** |
| **R2y** | **SKIP_UNSERVABLE** (463); bridge_r2ag closed OK_BOARD_FIRST |
| **R2z/aa–ad** | wait Reason+ 467–471 · blocked behind R2ah PID · host hist bridge |
| live board | phase duel **chal-00467** awesome-v9 (`scoring` ~44+/80) |
| disk | `/root` **~444 GiB** free |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TKC@65536 · **R2ag** n80 pid **285579** · **R2ah** waiter **290751** |

- R2ag sim: `tail -f /root/logs/r2ag_tpc9_reason_sim.log` · progress `/root/affine_data/r2ag_tpc9_reason_progress.json`
- R2ah: `tail -f /root/logs/r2ah_awesome_v9_reload.log` · Stage-5 `/root/logs/watch_r2ah_stage5_push.log`
- Host bridge: `tail -f experiments/r2-multiking-merge/logs/host_history_stamp_bridge.log` (pid **1202431**)
- Eager Talent blends R2z/aa–ad wait Reason+ only (no DONE until hr>0)

## Blocked

- No submit until sim hr ≥ **1.5×**.
- **sth** parent locked behind HF gated=manual.
- Board tpc9 **unservable** — do not re-arm Talent×tpc9.
- Pod `affine.io` history/snapshot often **CF 403** — use host bridge / hippius gzip.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f` / self-matching `pgrep -f`.

## Next action

**Harvest R2ag** `r2ag_tpc9_decision.json`. hr≥1.5× → Stage-5 HF. Else **R2ah** auto-claims pure awesome-v9 n80 (skip if board 467 hr≤0). Then first Reason+ among **468–471**.
