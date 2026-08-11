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
| **R2ag** | pure tpc9 n80 **gathering** ~36/38 of 80 · Stage-5 waiter armed |
| **R2y** | **SKIP_UNSERVABLE** (463); bridge_r2ag closed OK_BOARD_FIRST |
| **R2z/aa–ad** | wait Reason+ 467–471 · **host history bridge** armed (pod CF 403) |
| live board | phase duel **chal-00467** awesome-v9 (`scoring` ~14+/80) |
| disk | `/root` **~444 GiB** free |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@86.38.182.50 -p 40300` | TKC@65536 · **R2ag** n80 pid **285579** |

- R2ag sim: `tail -f /root/logs/r2ag_tpc9_reason_sim.log` · progress `/root/affine_data/r2ag_tpc9_reason_progress.json` · decision `/root/affine_data/r2ag_tpc9_decision.json`
- Host bridge: `tail -f experiments/r2-multiking-merge/logs/host_history_stamp_bridge.log` (pid **1202431**)
- Queue watches on pod still loop gzip; host bridge scp-stamps on history verdict
- Eager blends R2z/aa–ad wait Reason+ only (no DONE until hr>0)

## Blocked

- No submit until sim hr ≥ **1.5×**.
- **sth** parent locked behind HF gated=manual.
- Board tpc9 **unservable** — do not re-arm Talent×tpc9.
- Pod `affine.io` history/snapshot often **CF 403** — use host bridge / hippius gzip.
- Never `max_model_len=32768`; never cu13→`/usr/local/cuda`; never `pkill -f` / self-matching `pgrep -f`.

## Next action

**Harvest R2ag** `r2ag_tpc9_decision.json`. hr≥1.5× → Stage-5 HF (waiter armed). Else first Reason+ among **467–471** (host bridge + R2z/aa–ad) owns next GPU.
