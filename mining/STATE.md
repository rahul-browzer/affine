# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4** — Reason v3 crown push (operator 2026-08-10).
King-watch **revoked**. `weight_version_key=3`. Score = mean Reason (Λ2 only).

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · `subnet.weight_version_key=3` · crown = margin > 3·SE |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` (reign 4) |
| corpus | epoch **7** · schema v2 · manifest ready |
| Lium balance | ~$124,116 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| R1 LoRA n80 | **DONE** · `SIGNAL_POS_BELOW_3SE` · margin +0.0005 ≪ 3·SE 0.0147 |
| R1b n80 #2 | **DONE** · `REFUTE_R1_H64_BASELINE` · margin **−0.0135** · z=−2.45 |
| R1c train | **RUNNING** · **~47/132** @~39s/it · pid **96239** · ETA ~55m |
| R1c merge waiter | **ARMED** · pid **97305** · R1b below bar → merge after train |
| R2 prefetch/premerge | **DONE** · max_abs_delta=0.277 · α→n80 waiter **99246** (pidfile gate) |
| HF quota | p1883 purged **6** legacy public merges (**~423 GiB**); kept `r1lora` |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | TK@65536 + R1c train + merge/R2 waiters |

- Engines 8000/8001/8002 **200** @ `max_model_len=65536` (chall still `/tmp/r1b_lora_merged` until R1c merge).
- R1c train: log `/root/logs/r1c_train.log` → `/root/r1_out/lora_tok_high_reason_r1c` · stamp `r1c_train.done`.
- R1c merge: log `/root/logs/r1c_merge_reload.log` → `r1c_lora_decision.json`.
- R2 n80 waiter waits R1c decision → `/root/affine_data/r2_alpha_decision.json` (pidfile lane-free check).

## Blocked

- Do **not** submit `r1lora@569a68be` or R1b merged — both fail submit bar.
- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Never serve crown engines at `max_model_len=32768`.
- Never symlink `/usr/local/cuda`→cu13 on B300.
- Coldkey TAO is not convertible without a dated instruction.
- **unconst HF storage** — still many legacy `h*-merged`; purge again before next ~65 GiB push if commit fails.
- Never `pkill -f` over SSH; kill by PID / pidfile only.
- R2 lane-free check must use **pidfile kill -0**, never `pgrep -af` (SSH false-positive stall).

## Next action

**Harvest** `/root/affine_data/r1c_lora_decision.json` (train→merge→n80 armed). If headroom ≥ 1.5× → Stage-5 push (quota pre-cleared). Else let R2 α→n80 run (waiter 99246).
